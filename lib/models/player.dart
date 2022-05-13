import 'package:quellenreiter_app/models/enemy.dart';
import '../constants/constants.dart';

class Player {
  late String id;
  late String dataId;
  late String name;
  late String emoji;
  String? email;
  late int numPlayedGames;
  late int trueCorrectAnswers;
  late int trueFakeAnswers;
  late int falseCorrectAnswers;
  late int falseFakeAnswers;
  late Enemies? friends;
  late List<String>? safedStatementsIds;
  late List<String>? playedStatements;

  Player.fromMap(Map<String, dynamic>? map)
      : name = map?[DbFields.userName],
        emoji = map?[DbFields.userData]?[DbFields.userEmoji],
        numPlayedGames = map?[DbFields.userData]?[DbFields.userPlayedGames],
        trueCorrectAnswers =
            map?[DbFields.userData]?[DbFields.userTrueCorrectAnswers],
        trueFakeAnswers =
            map?[DbFields.userData]?[DbFields.userTrueFakeAnswers],
        falseCorrectAnswers =
            map?[DbFields.userData]?[DbFields.userFalseCorrectAnswers],
        falseFakeAnswers =
            map?[DbFields.userData]?[DbFields.userFalseFakeAnswers],
        id = map?["objectId"],
        dataId = map?[DbFields.userData]?["objectId"],
        playedStatements =
            map?[DbFields.userData]?[DbFields.userPlayedStatements] != null
                ? map![DbFields.userData][DbFields.userPlayedStatements]
                    .map((x) => x["value"])
                    .toList()
                    .cast<String>()
                : null,
        safedStatementsIds =
            map?[DbFields.userData]?[DbFields.userSafedStatements] != null
                ? map![DbFields.userData][DbFields.userSafedStatements]
                    .map((x) => x["value"])
                    .toList()
                    .cast<String>()
                : null;

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
        DbFields.userPlayedStatements: playedStatements
      }
    };
    return ret;
  }

  Map<String, dynamic> toUserMap() {
    var ret = {
      "id": id,
      "fields": {
        DbFields.userName: name,
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
    playedStatements = map[DbFields.userPlayedStatements]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
  }
}
