// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/models/player_relation.dart';
import 'package:quellenreiter_app/models/statement.dart';
import 'package:quellenreiter_app/provider/queries.dart';
import 'package:quellenreiter_app/provider/safe_storage.dart';
import 'package:http/http.dart' as http;

import '../consonents.dart';
import '../constants/constants.dart';
import 'database_connection.dart';

class PlayerProvider extends DatabaseConnection {
  /// Constructor is used to decide which implementation of [SafeStorageInterface] to use.
  /// This is passed to the super class.
  PlayerProvider({super.safeStorage = const SafeStoragePlugin()});

  /// Initialize the [Parse] database.
  Future<bool> initializeParse() async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    if (token == null) {
      return false;
    }
    // initialize parse
    var parse = await Parse().initialize(
      userDatabaseApplicationID,
      userDatabaseUrl.replaceAll("graphql", "parse"),
      clientKey: userDatabaseClientKey,
      autoSendSessionId: true,
      sessionId: token,
    );
    return parse.hasParseBeenInitialized();
  }

  Future<bool> getUserData(Player p) async {
    if (await createUserDatabaseClient()) {
      // The query result.
      var queryResult = await userDatabaseClient!.query(
        QueryOptions(
          document: gql(Queries.getUser()),
          variables: {"user": p.id},
        ),
      );

      if (!queryResult.hasException) {
        p = LocalPlayer.fromMap(queryResult.data!["user"]);
        return true;
      }
    }
    errorHandler.error = "Du bist offline!";
    return false;
  }

  /// Update a [LocalPlayer] in the Database by [String]. Only for username and
  /// device token! Thus only used for the logged in user.
  Future<void> updateUser(
      LocalPlayer player, Function(Player?) updateUserCallback) async {
    // TODO fetch player before updating so nothing is overwritten
    // check username for bad words
    bool isDirty = await _containsBadWord(player.name);
    if (isDirty) {
      updateUserCallback(null);
      return; //return if bad words are found
    }

    if (!await createUserDatabaseClient()) {
      await updateUserCallback(null);
      return;
    }

    var mutationResult = await userDatabaseClient!.mutate(
      MutationOptions(
        document: gql(Queries.updateUser()),
        variables: {
          "user": player.toUserMap(),
        },
      ),
    );

    if (mutationResult.hasException) {
      errorHandler.handleException(mutationResult.exception!);

      await updateUserCallback(null);
      return;
    } else {
      await updateUserCallback(
          LocalPlayer.fromMap(mutationResult.data?["updateUser"]["user"]));
      return;
    }
  }

  Future<bool> deleteAccount(
      LocalPlayer player, PlayerRelationCollection playerRelations) async {
    if (userDatabaseClient == null) {
      if (!await createUserDatabaseClient()) {
        return false;
      }
    }

    // Remeove the User and all open games and friendships.
    var mutationResult = await userDatabaseClient!.mutate(
      MutationOptions(
        document: gql(Queries.deleteUser(player, playerRelations)),
        variables: {
          "user": {
            "id": player.id,
          },
        },
      ),
    );

    if (mutationResult.hasException) {
      errorHandler.handleException(mutationResult.exception!);
      return false;
    }

    await safeStorage.delete(key: "token");

    return true;
  }

  /// Update a [Player.emoji] in the Database by [String].
  /// Class uses parse_server_sdk to update the emoji and not graphql.
  Future<void> updateEmoji(LocalPlayer player, String _emoji) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = player.dataId
        ..set(DbFields.userEmoji, _emoji);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        player.emoji = response.results!.first[DbFields.userEmoji];
        return;
      }
    } else {
      errorHandler.error = "Emoji konnte nicht gespeichert werden.";
      return;
    }
  }

  /// Update a [Player.name] in the Database by [String].
  Future<void> updateName(LocalPlayer _player, String _name) async {
    // if (await initializeParse()) {
    //   final parseUserData = ParseObject('User')
    //     ..objectId = _player.id
    //     ..set(DbFields.userName, _name);
    //   final response = await parseUserData.save();
    //   if (response.success && response.results != null) {
    //     _player.name = response.results!.first[DbFields.userName];
    //     return;
    //   }
    // } else {
    //   errorHandler.error = "Name konnte nicht gespeichert werden.";
    //   return;
    // }
    // This does not work, only if we sign in using the parse server sdk.
    // Currently we use the graphql server to sign in.
    // So we have to use the graphql server to update the name.
    _player.name = _name;
    await updateUser(_player, (Player? p) {});
    return;
  }

  /// Increment a [Player.numFriends] in the Database by [int].
  /// if [_increment] is negative, the number of friends will be decremented.
  /// This is used when a freiendship is created or deleted.
  Future<bool> incrementNumFriends(LocalPlayer _player, int _increment) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = _player.dataId
        ..setIncrement(DbFields.userNumFriends, _increment);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        _player.numFriends = response.results!.first[DbFields.userNumFriends];
        return true;
      }
    }
    errorHandler.error = "Anzahl Freunde konnte nicht gespeichert werden.";
    return false;
  }

  /// Add Statements to a [Player]s playedStatements in the Database by [List].
  Future<void> addPlayedStatements(Player _player, List<String> _statements,
      Function(Player?) updatePlayedStatementsCallback) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = _player.dataId
        ..setAddAllUnique(DbFields.userPlayedStatements, _statements);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        _player.addPlayedStatements(_statements);
        await updatePlayedStatementsCallback(_player);
        return;
      }
    } else {
      updatePlayedStatementsCallback(null);
      return;
    }
  }

  /// Add Statements to a [Player]s playedStatements in the Database by [List].
  Future<bool> removeAllPlayedStatements(Player _player) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = _player.dataId
        ..set(DbFields.userPlayedStatements, []);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        _player.removeAllPlayedStatements();
        return true;
      }
    }
    errorHandler.error =
        "Gespielte Statements konnten nicht zurückgesetzt werden.";
    return false;
  }

  /// Add a [Statement] toa [Player]s safedStatements in the Database.
  Future<bool> addSafedStatement(
      LocalPlayer _player, String _statementID) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = _player.dataId
        ..setAddUnique(DbFields.userSafedStatements, _statementID);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        _player.addSafedStatement(_statementID);
        return true;
      }
    }
    errorHandler.error = "Statement konnte nicht gespeichert werden.";
    return false;
  }

  /// Remove a [Statement] from a [Player]s safedStatements in the Database.
  Future<bool> removeSafedStatement(
      LocalPlayer _player, String _statementID) async {
    if (await initializeParse()) {
      final parseUserData = ParseObject('UserData')
        ..objectId = _player.dataId
        ..setRemove(DbFields.userSafedStatements, _statementID);
      final response = await parseUserData.save();
      if (response.success && response.results != null) {
        _player.removeSafedStatement(_statementID);
        return true;
      }
    }
    errorHandler.error = "Statement konnte nicht entfernt werden.";
    return false;
  }

  Future<bool> _containsBadWord(String username) async {
    if (username.isEmpty) {
      // return true because is empty
      errorHandler.error = "Username is empty";
      return true;
    }

    for (String s in customBadWords) {
      if (username.contains(s)) {
        errorHandler.error = "Username enthält ungültige Wörter.";
        return true;
      }
    }

    var url = Uri.https(
        badWordsUrl, "/text/", {'key': badWordsApiKey, 'msg': username});

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['bad_words'].isNotEmpty) {
        errorHandler.error = "Username enthält ungültige Wörter";
        return true;
      } else {
        return false;
      }
    } else {
      errorHandler.error = "Server Error";
      return true;
    }
  }

  Future<void> updatePlayerGameStats(
      LocalPlayer _player, Game currentGame) async {
    const int numGamesPlayedIncrement = 1;
    int numWonGamesIncrement = 0;
    int numTiedGamesIncrement = 0;
    int trueCorrectAnswersIncrement = 0;
    int falseCorrectAnswersIncrement = 0;
    int trueFakeAnswersIncrement = 0;
    int falseFakeAnswersIncrement = 0;
    if (currentGame.getGameResult() == GameResult.playerWon) {
      numWonGamesIncrement = 1;
    } else if (currentGame.getGameResult() == GameResult.tied) {
      numTiedGamesIncrement = 1;
    }
    Statements _statements = currentGame.statements!;
    List<bool> playerAnswers = currentGame.player.answers;
    for (int i = 0; i < GameRules.statementsPerGame; i++) {
      bool statementCorrect = CorrectnessCategory.isFact(
          _statements.statements[i].statementCorrectness);
      // correctly found as Reak News
      if (playerAnswers[i] && statementCorrect) {
        trueCorrectAnswersIncrement += 1;
      }
      // Correctly found as Fake News
      else if (playerAnswers[i] && !statementCorrect) {
        trueFakeAnswersIncrement += 1;
      }
      // Thought to be Real but was Fake News
      else if (!playerAnswers[i] && !statementCorrect) {
        falseFakeAnswersIncrement += 1;
      }
      // Thought to be Fake but was Real News
      else {
        falseCorrectAnswersIncrement += 1;
      }
    }
    await initializeParse();

    final parseUserData = ParseObject('UserData')
      ..objectId = _player.dataId
      ..setIncrement(DbFields.userPlayedGames, numGamesPlayedIncrement)
      ..setIncrement(DbFields.userGamesWon, numWonGamesIncrement)
      ..setIncrement(DbFields.userGamesTied, numTiedGamesIncrement)
      ..setIncrement(
          DbFields.userTrueCorrectAnswers, trueCorrectAnswersIncrement)
      ..setIncrement(
          DbFields.userFalseCorrectAnswers, falseCorrectAnswersIncrement)
      ..setIncrement(DbFields.userTrueFakeAnswers, trueFakeAnswersIncrement)
      ..setIncrement(DbFields.userFalseFakeAnswers, falseFakeAnswersIncrement);
    final response = await parseUserData.save();

    if (response.success && response.results != null) {
      _player.numGamesWon = response.results!.first[DbFields.userGamesWon];
      _player.numGamesTied = response.results!.first[DbFields.userGamesTied];
      _player.numPlayedGames =
          response.results!.first[DbFields.userPlayedGames];
      _player.trueCorrectAnswers =
          response.results!.first[DbFields.userTrueCorrectAnswers];
      _player.falseCorrectAnswers =
          response.results!.first[DbFields.userFalseCorrectAnswers];
      _player.trueFakeAnswers =
          response.results!.first[DbFields.userTrueFakeAnswers];
      _player.falseFakeAnswers =
          response.results!.first[DbFields.userFalseFakeAnswers];
    }
  }
}
