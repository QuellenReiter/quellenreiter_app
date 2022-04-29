import '../constants/constants.dart';
import 'game.dart';

class Enemy {
  late final int playerIndex;
  late final String friendshipId;
  late final String name;
  late final String userID;
  late final String emoji;
  late final int numGamesPlayed;
  late final int wonGamesPlayer;
  late final int wonGamesOther;
  late final bool acceptedByOther;
  late final bool acceptedByPlayer;
  late final Game? openGame;

  /// Constructor that takes a Map and resolves which of player1 and player2 is
  /// the player and which is the enemy.
  Enemy.fromMap(Map<String, dynamic>? map) {
    if (map?[DbFields.friendshipPlayer1]["edges"]?.length == 0) {
      // The player corresponds to player1 in the database friendship.
      playerIndex = 0;
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
      openGame =
          Game.fromMap(map?[DbFields.friendshipOpenGame]["edges"][0]["node"]);
    } else {
      openGame = null;
    }
  }
}

class Enemies {
  List<Enemy> enemies = [];

  Enemies.fromMap(Map<String, dynamic>? map) {
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      enemies.add(Enemy.fromMap(enemy?["node"]));
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
