import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/player.dart';

void main() {
  group("Testing Player class", () {
    // mock of a player map as returned from DB
    Map<String, dynamic> playerMap = {
      "objectId": "123456789",
      DbFields.userName: "TestUser",
      DbFields.userData: {
        "objectId": "987654321",
        DbFields.userEmoji: "👍",
        DbFields.userPlayedGames: 10,
        DbFields.userTrueCorrectAnswers: 5,
        DbFields.userTrueFakeAnswers: 2,
        DbFields.userFalseCorrectAnswers: 3,
        DbFields.userFalseFakeAnswers: 0,
        DbFields.userGamesWon: 4,
        DbFields.userGamesTied: 1,
        DbFields.userPlayedStatements: [
          {"value": "123456789"},
          {"value": "987654321"},
        ],
        DbFields.userSafedStatements: [
          {"value": "123456789"},
          {"value": "987654321"},
        ],
        DbFields.userNumFriends: 2,
      }
    };
    // Mock of a player object
    final player = Player.fromMap(playerMap);

    test("Player.fromMap() should return a Player object", () {
      expect(player, isA<Player>());
    });

    test("Player.fromMap() should return a Player object with correct values",
        () {
      expect(player.id, playerMap["objectId"]);
      expect(player.dataId, playerMap[DbFields.userData]["objectId"]);
      expect(player.name, playerMap[DbFields.userName]);
      expect(player.emoji, playerMap[DbFields.userData][DbFields.userEmoji]);
      expect(player.numPlayedGames,
          playerMap[DbFields.userData][DbFields.userPlayedGames]);
      expect(player.trueCorrectAnswers,
          playerMap[DbFields.userData][DbFields.userTrueCorrectAnswers]);
      expect(player.trueFakeAnswers,
          playerMap[DbFields.userData][DbFields.userTrueFakeAnswers]);
      expect(player.falseCorrectAnswers,
          playerMap[DbFields.userData][DbFields.userFalseCorrectAnswers]);
      expect(player.falseFakeAnswers,
          playerMap[DbFields.userData][DbFields.userFalseFakeAnswers]);
      expect(player.numGamesWon,
          playerMap[DbFields.userData][DbFields.userGamesWon]);
      expect(player.numGamesTied,
          playerMap[DbFields.userData][DbFields.userGamesTied]);
      expect(
          player.playedStatements![0],
          playerMap[DbFields.userData][DbFields.userPlayedStatements][0]
              ["value"]);
      expect(
          player.savedStatementsIds![0],
          playerMap[DbFields.userData][DbFields.userSafedStatements][0]
              ["value"]);
      expect(player.numFriends,
          playerMap[DbFields.userData][DbFields.userNumFriends]);
    });

    test(
        "Player.toUserMap() should return a map with name only, if deviceToken is null",
        () {
      expect(player.toUserMap(), {
        "id": player.id,
        "fields": {
          DbFields.userName: player.name,
        }
      });
    });

    test(
        "Player.toUserMap() should return a map with name and token, if deviceToken is not null",
        () {
      player.deviceToken = "123456789";
      expect(player.toUserMap(), {
        "id": player.id,
        "fields": {
          DbFields.userName: player.name,
          DbFields.userDeviceToken: player.deviceToken,
        }
      });
    });

    test("Player.toUserDataMap() should return a map with all fields", () {
      expect(player.toUserDataMap(), {
        "id": player.dataId,
        "fields": {
          DbFields.userEmoji: player.emoji,
          DbFields.userPlayedGames: player.numPlayedGames,
          DbFields.userTrueCorrectAnswers: player.trueCorrectAnswers,
          DbFields.userTrueFakeAnswers: player.trueFakeAnswers,
          DbFields.userFalseCorrectAnswers: player.falseCorrectAnswers,
          DbFields.userFalseFakeAnswers: player.falseFakeAnswers,
          DbFields.userGamesWon: player.numGamesWon,
          DbFields.userGamesTied: player.numGamesTied,
          DbFields.userPlayedStatements: player.playedStatements,
          DbFields.userSafedStatements: player.savedStatementsIds,
          DbFields.userNumFriends: player.numFriends,
        }
      });
    });
  });
}
