import 'package:quellenreiter_app/models/enemy.dart';
import '../constants/constants.dart';
import 'game.dart';

class Player {
  late String id;
  late String name;
  late String emoji;
  String? email;
  late int numPlayedGames;
  late int trueCorrectAnswers;
  late int trueFakeAnswers;
  late int falseCorrectAnswers;
  late int falseFakeAnswers;
  late Enemies? friends;
  late Games? openGames;
  late List<String>? safedStatementsIds;
  late List<String>? playedStatements;

  Player.fromMap(Map<String, dynamic>? map)
      : name = map?[DbFields.userName],
        emoji = map?[DbFields.userEmoji],
        numPlayedGames = map?[DbFields.userPlayedGames],
        trueCorrectAnswers = map?[DbFields.userTrueCorrectAnswers],
        trueFakeAnswers = map?[DbFields.userTrueFakeAnswers],
        falseCorrectAnswers = map?[DbFields.userFalseCorrectAnswers],
        falseFakeAnswers = map?[DbFields.userFalseFakeAnswers],
        friends = map?[DbFields.userFriendships] != null
            ? Enemies.fromFriendshipMap(map?[DbFields.userFriendships])
            : null,
        id = map?["objectId"],
        openGames = map?[DbFields.userFriendships] != null
            ? Games.fromMap(map?[DbFields.userFriendships])
            : null,
        playedStatements = map?[DbFields.userPlayedStatements] != null
            ? map![DbFields.userPlayedStatements]
                .map((x) => x["value"])
                .toList()
                .cast<String>()
            : null,
        safedStatementsIds = map?[DbFields.userSafedStatements] != null
            ? map![DbFields.userSafedStatements]
                .map((x) => x["value"])
                .toList()
                .cast<String>()
            : null;

  Map<String, dynamic> toMap() {
    var ret = {
      "id": id,
      "fields": {
        DbFields.userName: name,
        DbFields.userEmoji: emoji,
        DbFields.userPlayedGames: numPlayedGames,
        DbFields.userTrueCorrectAnswers: trueCorrectAnswers,
        DbFields.userFalseCorrectAnswers: falseCorrectAnswers,
        DbFields.userTrueFakeAnswers: trueFakeAnswers,
        DbFields.userFalseFakeAnswers: falseFakeAnswers,
        DbFields.userName: name,
      }
    };
    return ret;
  }
}
