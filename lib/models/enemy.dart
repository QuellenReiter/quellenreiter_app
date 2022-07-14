import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'game.dart';
import 'player.dart';
import 'statement.dart';

class Enemy {
  late int playerIndex;
  late String friendshipId;
  late List<String> playedStatementIds;
  late String name;
  late String userId;
  late String userDataID;
  late String emoji;
  late int numGamesPlayed;
  late int wonGamesPlayer;
  late int wonGamesOther;
  late bool acceptedByOther;
  late bool acceptedByPlayer;
  late Game? openGame;
  late int trueCorrectAnswersOther;
  late int trueFakeAnswersOther;
  late int falseCorrectAnswersOther;
  late int falseFakeAnswersOther;
  late int numGamesWonOther;
  late int numGamesTiedOther;
  late int numGamesPlayedOther;

  /// Constructor that takes a Map of a friendship query and resolves which of
  /// player1 and player2 is
  /// the player and which is the enemy.
  Enemy.fromFriendshipMap(Map<String, dynamic>? map, Player p) {
    if (map?[DbFields.friendshipPlayer2] == null ||
        map?[DbFields.friendshipPlayer1] == null) {
      throw Exception('Invalid friendship map');
    }
    if (map?[DbFields.friendshipPlayer1]["objectId"] == p.id) {
      // The player corresponds to player1 in the database friendship.
      playerIndex = 0;
      if (map?[DbFields.friendshipPlayer2][DbFields.userData]
              [DbFields.userPlayedStatements] ==
          null) {
        playedStatementIds = [];
      } else {
        playedStatementIds = map?[DbFields.friendshipPlayer2][DbFields.userData]
                [DbFields.userPlayedStatements]
            .map((x) => x["value"])
            .toList()
            .cast<String>();
      }
      name = map?[DbFields.friendshipPlayer2][DbFields.userName];
      emoji = map?[DbFields.friendshipPlayer2][DbFields.userData]
          [DbFields.userEmoji];
      userDataID =
          map?[DbFields.friendshipPlayer2][DbFields.userData]["objectId"];
      userId = map?[DbFields.friendshipPlayer2]["objectId"];
      wonGamesOther = map?[DbFields.friendshipWonGamesPlayer2];
      wonGamesPlayer = map?[DbFields.friendshipWonGamesPlayer1];
      acceptedByOther = map?[DbFields.friendshipApproved2];
      acceptedByPlayer = map?[DbFields.friendshipApproved1];
      trueCorrectAnswersOther = map?[DbFields.friendshipPlayer2]
          [DbFields.userData][DbFields.userTrueCorrectAnswers];
      trueFakeAnswersOther = map?[DbFields.friendshipPlayer2][DbFields.userData]
          [DbFields.userTrueFakeAnswers];
      falseCorrectAnswersOther = map?[DbFields.friendshipPlayer2]
          [DbFields.userData][DbFields.userFalseCorrectAnswers];
      falseFakeAnswersOther = map?[DbFields.friendshipPlayer2]
          [DbFields.userData][DbFields.userFalseFakeAnswers];
      numGamesWonOther = map?[DbFields.friendshipPlayer2][DbFields.userData]
          [DbFields.userGamesWon];
      numGamesTiedOther = map?[DbFields.friendshipPlayer2][DbFields.userData]
          [DbFields.userGamesTied];
      numGamesPlayedOther = map?[DbFields.friendshipPlayer2][DbFields.userData]
          [DbFields.userPlayedGames];
    } else {
      // The player corresponds to player2 in the database friendship.
      playerIndex = 1;
      playedStatementIds = map?[DbFields.friendshipPlayer1][DbFields.userData]
              [DbFields.userPlayedStatements]
          .map((x) => x["value"])
          .toList()
          .cast<String>();
      name = map?[DbFields.friendshipPlayer1][DbFields.userName];
      emoji = map?[DbFields.friendshipPlayer1][DbFields.userData]
          [DbFields.userEmoji];
      userDataID =
          map?[DbFields.friendshipPlayer1][DbFields.userData]["objectId"];
      userId = map?[DbFields.friendshipPlayer1]["objectId"];
      wonGamesOther = map?[DbFields.friendshipWonGamesPlayer1];
      wonGamesPlayer = map?[DbFields.friendshipWonGamesPlayer2];
      acceptedByOther = map?[DbFields.friendshipApproved1];
      acceptedByPlayer = map?[DbFields.friendshipApproved2];
      trueCorrectAnswersOther = map?[DbFields.friendshipPlayer1]
          [DbFields.userData][DbFields.userTrueCorrectAnswers];
      trueFakeAnswersOther = map?[DbFields.friendshipPlayer1][DbFields.userData]
          [DbFields.userTrueFakeAnswers];
      falseCorrectAnswersOther = map?[DbFields.friendshipPlayer1]
          [DbFields.userData][DbFields.userFalseCorrectAnswers];
      falseFakeAnswersOther = map?[DbFields.friendshipPlayer1]
          [DbFields.userData][DbFields.userFalseFakeAnswers];
      numGamesWonOther = map?[DbFields.friendshipPlayer1][DbFields.userData]
          [DbFields.userGamesWon];
      numGamesTiedOther = map?[DbFields.friendshipPlayer1][DbFields.userData]
          [DbFields.userGamesTied];
      numGamesPlayedOther = map?[DbFields.friendshipPlayer1][DbFields.userData]
          [DbFields.userPlayedGames];
    }
    numGamesPlayed = map?[DbFields.friendshipNumGamesPlayed];
    friendshipId = map?["objectId"];
    // if an open game exists, safe it.
    if (map?[DbFields.friendshipOpenGame] != null) {
      openGame = Game(
          //object Id
          map?[DbFields.friendshipOpenGame]["objectId"],
          // enemyAnswers
          map?[DbFields.friendshipOpenGame][playerIndex == 0
                  ? DbFields.gameAnswersPlayer2
                  : DbFields.gameAnswersPlayer1]
              .map((x) => x["value"])
              .toList()
              .cast<bool>(),
          // player answers
          map?[DbFields.friendshipOpenGame][playerIndex == 0
                  ? DbFields.gameAnswersPlayer1
                  : DbFields.gameAnswersPlayer2]
              .map((x) => x["value"])
              .toList()
              .cast<bool>(),
          playerIndex,
          map?[DbFields.friendshipOpenGame][DbFields.gameStatementIds]
              .map((x) => x["value"])
              .toList()
              .cast<String>(),
          map?[DbFields.friendshipOpenGame][DbFields.gameWithTimer],
          map?[DbFields.friendshipOpenGame][DbFields.gameRequestingPlayerIndex],
          null,
          map?[DbFields.friendshipOpenGame][DbFields.gamePointsAccessed]);
    } else {
      openGame = null;
    }
  }

  Enemy.fromUserMap(Map<String, dynamic>? map) {
    name = map?[DbFields.userName];
    emoji = map?[DbFields.userData] == null
        ? ""
        : map?[DbFields.userData][DbFields.userEmoji];
    userDataID = map?[DbFields.userData] == null
        ? ""
        : map?[DbFields.userData]["objectId"];
    userId = map?["objectId"];
    wonGamesOther = 0;
    wonGamesPlayer = 0;
    acceptedByOther = false;
    acceptedByPlayer = false;
    numGamesPlayed = 0;
    friendshipId = "";
    openGame = null;
    trueCorrectAnswersOther = 0;
    trueFakeAnswersOther = 0;
    falseCorrectAnswersOther = 0;
    falseFakeAnswersOther = 0;
    numGamesWonOther = 0;
    numGamesTiedOther = 0;
    numGamesPlayedOther = 0;
  }

  Map<String, dynamic> toUserDataMap() {
    var ret = {
      "id": userDataID,
      "fields": {
        DbFields.userEmoji: emoji,
        DbFields.userPlayedStatements: playedStatementIds,
        DbFields.userTrueCorrectAnswers: trueCorrectAnswersOther,
        DbFields.userTrueFakeAnswers: trueFakeAnswersOther,
        DbFields.userFalseCorrectAnswers: falseCorrectAnswersOther,
        DbFields.userFalseFakeAnswers: falseFakeAnswersOther,
        DbFields.userGamesWon: numGamesWonOther,
        DbFields.userGamesTied: numGamesTiedOther,
        DbFields.userPlayedGames: numGamesPlayedOther,
      }
    };
    return ret;
  }

  Map<String, dynamic> toFriendshipMap() {
    Map<String, dynamic> ret = {};
    if (playerIndex == 0) {
      ret = {
        "id": friendshipId,
        "fields": {
          DbFields.friendshipApproved1: acceptedByPlayer,
          DbFields.friendshipApproved2: acceptedByOther,
          DbFields.friendshipWonGamesPlayer1: wonGamesPlayer,
          DbFields.friendshipWonGamesPlayer2: wonGamesOther,
          DbFields.friendshipNumGamesPlayed: numGamesPlayed,
          DbFields.friendshipOpenGame: {
            "link": openGame!.id,
          }
        }
      };
    } else {
      ret = {
        "id": friendshipId,
        "fields": {
          DbFields.friendshipApproved2: acceptedByPlayer,
          DbFields.friendshipApproved1: acceptedByOther,
          DbFields.friendshipWonGamesPlayer2: wonGamesPlayer,
          DbFields.friendshipWonGamesPlayer1: wonGamesOther,
          DbFields.friendshipNumGamesPlayed: numGamesPlayed,
          DbFields.friendshipOpenGame: {
            "link": openGame!.id,
          }
        }
      };
    }
    // print(ret);
    return ret;
  }

  void updateAnswerStats(List<bool> enemyAnswers, Statements? statements) {
    if (statements == null) {
      return;
    }
    for (int i = 0; i < GameRules.statementsPerGame; i++) {
      // correctly found as Reak News
      if (enemyAnswers[i] &&
          statements.statements[i].statementCorrectness ==
              CorrectnessCategory.correct) {
        trueCorrectAnswersOther += 1;
      }
      // Correctly found as Fake News
      else if (enemyAnswers[i] &&
          statements.statements[i].statementCorrectness !=
              CorrectnessCategory.correct) {
        trueFakeAnswersOther += 1;
      }
      // Thought to be Real but was Fake News
      else if (!enemyAnswers[i] &&
          statements.statements[i].statementCorrectness !=
              CorrectnessCategory.correct) {
        falseFakeAnswersOther += 1;
      }
      // Thought to be Fake but was Real News
      else if (!enemyAnswers[i] &&
          statements.statements[i].statementCorrectness ==
              CorrectnessCategory.correct) {
        falseCorrectAnswersOther += 1;
      }
    }
  }

  void updateDataWithMap(Map<String, dynamic> map) {
    userDataID = map["objectId"];
    emoji = map[DbFields.userEmoji];

    playedStatementIds = map[DbFields.userPlayedStatements]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
    trueCorrectAnswersOther = map[DbFields.userTrueCorrectAnswers];
    trueFakeAnswersOther = map[DbFields.userTrueFakeAnswers];
    falseCorrectAnswersOther = map[DbFields.userFalseCorrectAnswers];
    falseFakeAnswersOther = map[DbFields.userFalseFakeAnswers];
    numGamesWonOther = map[DbFields.userGamesWon];
    numGamesTiedOther = map[DbFields.userGamesTied];
    numGamesPlayedOther = map[DbFields.userPlayedGames];
  }

  int getXp() {
    int xp = 0;
    xp = numGamesWonOther * GameRules.pointsPerWonGame + // won games give 20xp
        (trueCorrectAnswersOther + trueFakeAnswersOther) *
            GameRules.pointsPerCorrectAnswer + // correct answers give 12 xp
        numGamesTiedOther * GameRules.pointsPerTiedGame; // tied games give 5 xp
    return xp;
  }

  int getLevel() {
    return GameRules.currentLevel(getXp());
  }
}

class Enemies {
  List<Enemy> enemies = [];

  Enemies.fromFriendshipMap(Map<String, dynamic>? map, Player p) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      try {
        enemies.add(Enemy.fromFriendshipMap(enemy?["node"], p));
      } catch (e) {
        debugPrint("invalid Freindship with ID:" + enemy?["node"]["objectId"]);
      }
    }
  }

  Enemies.fromUserMap(Map<String, dynamic>? map) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      enemies.add(Enemy.fromUserMap(enemy?["node"]));
    }
  }
  Enemies.empty() {
    enemies = [];
  }

  List<String> getNames() {
    List<String> ret = [];
    for (Enemy e in enemies) {
      ret.add(e.name);
    }
    return ret;
  }
}
