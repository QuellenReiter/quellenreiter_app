import '../constants/constants.dart';
import 'game.dart';
import 'player.dart';

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

  /// Constructor that takes a Map of a friendship query and resolves which of
  /// player1 and player2 is
  /// the player and which is the enemy.
  Enemy.fromFriendshipMap(Map<String, dynamic>? map, Player p) {
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
      );
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
  }

  Map<String, dynamic> toUserDataMap() {
    var ret = {
      "id": userDataID,
      "fields": {
        DbFields.userEmoji: emoji,
        DbFields.userPlayedStatements: playedStatementIds
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

  void updateDataWithMap(Map<String, dynamic> map) {
    userDataID = map["objectId"];
    emoji = map[DbFields.userEmoji];
    playedStatementIds = map[DbFields.userPlayedStatements]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
  }
}

class Enemies {
  List<Enemy> enemies = [];

  Enemies.fromFriendshipMap(Map<String, dynamic>? map, Player p) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? enemy in map?["edges"]) {
      enemies.add(Enemy.fromFriendshipMap(enemy?["node"], p));
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
