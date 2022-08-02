import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/statement.dart';
import '../constants/constants.dart';

class Player {
  late String id;
  late String? dataId;
  late String name;
  late String emoji;
  String? email;
  late int numPlayedGames;
  late int numGamesWon;
  late int numGamesTied;
  late int trueCorrectAnswers;
  late int trueFakeAnswers;
  late int falseCorrectAnswers;
  late int falseFakeAnswers;
  late Enemies? friends;
  late List<String>? safedStatementsIds;
  late List<String>? playedStatements;
  late String? deviceToken;
  int numFriends = 0;

  Player.fromMap(Map<String, dynamic>? map)
      : name = map?[DbFields.userName],
        dataId = map?[DbFields.userData] == null
            ? null
            : map?[DbFields.userData]?["objectId"],
        emoji = map?[DbFields.userData] == null
            ? ""
            : map?[DbFields.userData]?[DbFields.userEmoji],
        numPlayedGames = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userPlayedGames],
        trueCorrectAnswers = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userTrueCorrectAnswers],
        trueFakeAnswers = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userTrueFakeAnswers],
        falseCorrectAnswers = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userFalseCorrectAnswers],
        falseFakeAnswers = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userFalseFakeAnswers],
        numGamesWon = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userGamesWon],
        numGamesTied = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData]?[DbFields.userGamesTied],
        id = map?["objectId"],
        playedStatements = map?[DbFields.userData] == null
            ? []
            : map?[DbFields.userData]?[DbFields.userPlayedStatements] != null
                ? map![DbFields.userData][DbFields.userPlayedStatements]
                    .map((x) => x["value"])
                    .toList()
                    .cast<String>()
                : null,
        safedStatementsIds = map?[DbFields.userData] == null
            ? []
            : map?[DbFields.userData]?[DbFields.userSafedStatements] != null
                ? map![DbFields.userData][DbFields.userSafedStatements]
                    .map((x) => x["value"])
                    .toList()
                    .cast<String>()
                : null,
        friends = null,
        numFriends = map?[DbFields.userData] == null
            ? 0
            : map?[DbFields.userData][DbFields.userNumFriends];

  Map<String, dynamic> toUserDataMap() {
    var ret = {
      "id": dataId,
      "fields": {
        DbFields.userEmoji: emoji,
        DbFields.userPlayedGames: numPlayedGames,
        DbFields.userTrueCorrectAnswers: trueCorrectAnswers,
        DbFields.userFalseCorrectAnswers: falseCorrectAnswers,
        DbFields.userTrueFakeAnswers: trueFakeAnswers,
        DbFields.userFalseFakeAnswers: falseFakeAnswers,
        DbFields.userPlayedStatements: playedStatements,
        DbFields.userSafedStatements: safedStatementsIds,
        DbFields.userGamesWon: numGamesWon,
        DbFields.userGamesTied: numGamesTied,
        DbFields.userNumFriends: numFriends,
      }
    };
    return ret;
  }

  Map<String, dynamic> toUserMap() {
    Map<String, dynamic> ret = {
      "id": id,
      "fields": {
        DbFields.userName: name,
        DbFields.userDeviceToken: deviceToken,
      }
    };
    // remove token if its null
    ret["fields"].removeWhere((key, value) => value == null);
    return ret;
  }

  Map<String, dynamic> toUserMapWithNewUserData() {
    var ret = {
      "id": id,
      "fields": {
        DbFields.userData: {
          "createAndLink": {
            DbFields.userEmoji: emoji,
            DbFields.userPlayedGames: numPlayedGames,
            DbFields.userTrueCorrectAnswers: trueCorrectAnswers,
            DbFields.userFalseCorrectAnswers: falseCorrectAnswers,
            DbFields.userTrueFakeAnswers: trueFakeAnswers,
            DbFields.userFalseFakeAnswers: falseFakeAnswers,
            DbFields.userPlayedStatements: playedStatements,
            DbFields.userSafedStatements: safedStatementsIds,
            DbFields.userGamesWon: numGamesWon,
            DbFields.userGamesTied: numGamesTied,
            DbFields.userNumFriends: 0,
          }
        }
      }
    };
    return ret;
  }

  void updateDataWithMap(Map<String, dynamic> map) {
    dataId = map["objectId"];
    emoji = map[DbFields.userEmoji];
    numPlayedGames = map[DbFields.userPlayedGames];
    trueCorrectAnswers = map[DbFields.userTrueCorrectAnswers];
    trueFakeAnswers = map[DbFields.userTrueFakeAnswers];
    falseCorrectAnswers = map[DbFields.userFalseCorrectAnswers];
    falseFakeAnswers = map[DbFields.userFalseFakeAnswers];
    numGamesWon = map[DbFields.userGamesWon];
    numGamesTied = map[DbFields.userGamesTied];
    playedStatements = map[DbFields.userPlayedStatements]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
    safedStatementsIds = map[DbFields.userSafedStatements]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
    numFriends = map[DbFields.userNumFriends];
  }

  void updateAnswerStats(List<bool> playerAnswers, Statements? statements) {
    if (statements == null) {
      return;
    }
    for (int i = 0; i < GameRules.statementsPerGame; i++) {
      // correctly found as Reak News
      if (playerAnswers[i] &&
          statements.statements[i].statementCorrectness ==
              CorrectnessCategory.correct) {
        trueCorrectAnswers += 1;
      }
      // Correctly found as Fake News
      else if (playerAnswers[i] &&
          statements.statements[i].statementCorrectness !=
              CorrectnessCategory.correct) {
        trueFakeAnswers += 1;
      }
      // Thought to be Real but was Fake News
      else if (!playerAnswers[i] &&
          statements.statements[i].statementCorrectness !=
              CorrectnessCategory.correct) {
        falseFakeAnswers += 1;
      }
      // Thought to be Fake but was Real News
      else if (!playerAnswers[i] &&
          statements.statements[i].statementCorrectness ==
              CorrectnessCategory.correct) {
        falseCorrectAnswers += 1;
      }
    }
  }

  int getXp() {
    int xp = 0;
    xp = numGamesWon * GameRules.pointsPerWonGame + // won games give 20xp
        (trueCorrectAnswers + trueFakeAnswers) *
            GameRules.pointsPerCorrectAnswer + // correct answers give 12 xp
        numGamesTied * GameRules.pointsPerTiedGame +
        numFriends * 10; // tied games give 5 xp
    return xp;
  }

  int getLevel() {
    return GameRules.currentLevel(getXp());
  }

  int getPreviousLevelXp() {
    return GameRules.xpForCurrentLevel(getXp());
  }

  int getNextLevelXp() {
    return GameRules.xpForNextLevel(getXp());
  }

  int getNexNexttLevelXp() {
    return GameRules.xpForNextNextLevel(getXp());
  }
}
