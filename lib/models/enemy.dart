import '../constants/constants.dart';

class Enemy {
  late final String name;
  late final String userID;
  late final String emoji;
  late final int numGamesPlayed;
  late final int wonGamesPlayer;
  late final int wonGamesOther;
  late final bool acceptedByOther;
  late final bool acceptedByPlayer;

  /// Constructor that takes a Map and resolves which of player1 and player2 is
  /// the player and which is the enemy.
  Enemy.fromMap(Map<String, dynamic>? map) {
    if (map?[DbFields.friendshipPlayer1]["edges"]?.length == 0) {
      // The player corresponds to player1 in the database friendship.
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
  }
}

class Enemies {
  List<Enemy> enemies = [];

  Enemies.fromMap(Map<String, dynamic>? map) {
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      enemies.add(Enemy.fromMap(enemy?["node"]));
    }
  }
}
