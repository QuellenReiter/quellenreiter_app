import '../constants/constants.dart';
import 'game.dart';

class Enemy {
  late final int playerIndex;
  late String friendshipId;
  late List<String> playedStatementIds;
  late final String name;
  late final String userID;
  late final String emoji;
  late int numGamesPlayed;
  late int wonGamesPlayer;
  late int wonGamesOther;
  late bool acceptedByOther;
  late bool acceptedByPlayer;
  late Game? openGame;

  /// Constructor that takes a Map of a friendship query and resolves which of
  /// player1 and player2 is
  /// the player and which is the enemy.
  Enemy.fromFriendshipMap(Map<String, dynamic>? map) {
    if (map?[DbFields.friendshipPlayer1]["edges"]?.length == 0) {
      // The player corresponds to player1 in the database friendship.
      playerIndex = 0;
      if (map?[DbFields.friendshipPlayer2]["edges"][0]["node"]
              [DbFields.userPlayedStatements] ==
          null) {
        playedStatementIds = [];
      } else {
        playedStatementIds = map?[DbFields.friendshipPlayer2]["edges"][0]
                ["node"][DbFields.userPlayedStatements]
            .map((x) => x["value"])
            .toList()
            .cast<String>();
      }
      name = map?[DbFields.friendshipPlayer2]["edges"][0]["node"]
          [DbFields.userName];
      emoji = map?[DbFields.friendshipPlayer2]["edges"][0]["node"]
          [DbFields.userEmoji];
      userID = map?[DbFields.friendshipPlayer2]["edges"][0]["node"]["objectId"];
      wonGamesOther = map?[DbFields.friendshipWonGamesPlayer2];
      wonGamesPlayer = map?[DbFields.friendshipWonGamesPlayer1];
      acceptedByOther = map?[DbFields.friendshipApproved2];
      acceptedByPlayer = map?[DbFields.friendshipApproved1];
    } else {
      // The player corresponds to player2 in the database friendship.
      playerIndex = 1;
      playedStatementIds = map?[DbFields.friendshipPlayer1]["edges"][0]["node"]
              [DbFields.userPlayedStatements]
          .map((x) => x["value"])
          .toList()
          .cast<String>();
      name = map?[DbFields.friendshipPlayer1]["edges"][0]["node"]
          [DbFields.userName];
      emoji = map?[DbFields.friendshipPlayer1]["edges"][0]["node"]
          [DbFields.userEmoji];
      userID = map?[DbFields.friendshipPlayer1]["edges"][0]["node"]["objectId"];
      wonGamesOther = map?[DbFields.friendshipWonGamesPlayer1];
      wonGamesPlayer = map?[DbFields.friendshipWonGamesPlayer2];
      acceptedByOther = map?[DbFields.friendshipApproved1];
      acceptedByPlayer = map?[DbFields.friendshipApproved2];
    }
    numGamesPlayed = map?[DbFields.friendshipNumGamesPlayed];
    friendshipId = map?["objectId"];
    // if an open game exists, safe it.
    if (map?[DbFields.friendshipOpenGame]["edges"].isNotEmpty) {
      openGame = Game(
        //object Id
        map?[DbFields.friendshipOpenGame]["edges"][0]["node"]["objectId"],
        // enemyAnswers
        map?[DbFields.friendshipOpenGame]["edges"][0]["node"][playerIndex == 0
                ? DbFields.gameAnswersPlayer2
                : DbFields.gameAnswersPlayer1]
            .map((x) => x["value"])
            .toList()
            .cast<bool>(),
        // player answers
        map?[DbFields.friendshipOpenGame]["edges"][0]["node"][playerIndex == 0
                ? DbFields.gameAnswersPlayer1
                : DbFields.gameAnswersPlayer2]
            .map((x) => x["value"])
            .toList()
            .cast<bool>(),
        playerIndex,
        map?[DbFields.friendshipOpenGame]["edges"][0]["node"]
                [DbFields.gameStatementIds]
            .map((x) => x["value"])
            .toList()
            .cast<String>(),
        map?[DbFields.friendshipOpenGame]["edges"][0]["node"]
            [DbFields.gameWithTimer],
      );
    } else {
      openGame = null;
    }
  }

  Enemy.fromUserMap(Map<String, dynamic>? map) {
    name = map?[DbFields.userName];
    emoji = map?[DbFields.userEmoji];
    userID = map?["objectId"];
    wonGamesOther = 0;
    wonGamesPlayer = 0;
    acceptedByOther = false;
    acceptedByPlayer = false;
    numGamesPlayed = 0;
    friendshipId = "";
    openGame = null;
  }
}

class Enemies {
  List<Enemy> enemies = [];

  Enemies.fromFriendshipMap(Map<String, dynamic>? map) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      enemies.add(Enemy.fromFriendshipMap(enemy?["node"]));
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
