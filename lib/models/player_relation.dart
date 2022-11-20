import 'package:flutter/material.dart';

import '../constants/constants.dart';
import 'game.dart';
import 'player.dart';

enum RelationState {
  friend(acceptedByPlayer: true, acceptedByOther: true),
  sent(acceptedByPlayer: true, acceptedByOther: false),
  received(acceptedByPlayer: false, acceptedByOther: true),
  random(acceptedByPlayer: false, acceptedByOther: false);

  final bool acceptedByPlayer;
  final bool acceptedByOther;

  const RelationState(
      {required this.acceptedByPlayer, required this.acceptedByOther});

  factory RelationState.fromDbMap(Map<String, dynamic> map, bool isFirst) {
    bool player = isFirst
        ? map[DbFields.friendshipApproved1]
        : map[DbFields.friendshipApproved2];
    bool other = isFirst
        ? map[DbFields.friendshipApproved2]
        : map[DbFields.friendshipApproved1];
    if (player) {
      if (other) {
        return RelationState.friend;
      }
      return RelationState.sent;
    }
    if (other) {
      return RelationState.received;
    }
    return RelationState.random;
  }
}

class PlayerRelation {
  late int playerIndex;
  late String friendshipId;

  // stats
  late int numGamesPlayed;
  late int wonGamesPlayer;
  late int wonGamesOther;

  // State of friendship
  late RelationState relationState;
  late Game? openGame;

  // members
  late Player opponent;
  late Player player;

  /// Constructor that takes a Map of a friendship query and resolves which of
  /// player1 and player2 is the player and which is the opponent.
  PlayerRelation.fromFriendshipMap(Map<String, dynamic>? map, Player p) {
    if (map?[DbFields.friendshipPlayer2] == null ||
        map?[DbFields.friendshipPlayer1] == null) {
      throw Exception('Invalid friendship map');
    }
    // True if player corresponds to player1 in the database friendship table.
    bool _playerIsFirstInDB =
        map![DbFields.friendshipPlayer1]["objectId"] == p.id;

    player = p;
    playerIndex = _playerIsFirstInDB ? 0 : 1;
    relationState = RelationState.fromDbMap(map, _playerIsFirstInDB);

    opponent = Player.fromMap(_playerIsFirstInDB
        ? map[DbFields.friendshipPlayer2]
        : map[DbFields.friendshipPlayer1]);
    wonGamesOther = _playerIsFirstInDB
        ? map[DbFields.friendshipWonGamesPlayer2]
        : map[DbFields.friendshipWonGamesPlayer1];
    wonGamesPlayer = _playerIsFirstInDB
        ? map[DbFields.friendshipWonGamesPlayer1]
        : map[DbFields.friendshipWonGamesPlayer2];

    numGamesPlayed = map[DbFields.friendshipNumGamesPlayed];
    friendshipId = map["objectId"];

    // if an open game exists, save it.
    dynamic openGameDb = map[DbFields.friendshipOpenGame];
    if (openGameDb != null) {
      openGame = Game.fromDbMap(openGameDb, playerIndex);
    } else {
      openGame = null;
    }
  }

  // called when friends are searched and no actual friendship exists yet.
  PlayerRelation.fromUserMap(Map<String, dynamic>? map) {
    opponent = Player.fromMap(map);
    wonGamesOther = 0;
    wonGamesPlayer = 0;
    relationState = RelationState.random;
    numGamesPlayed = 0;
    friendshipId = "";
    openGame = null;
  }

  /// Convert to a map for saving to the database.
  /// Todo: refactor if/else statement.
  Map<String, dynamic> toFriendshipMap() {
    Map<String, dynamic> ret = {};
    if (playerIndex == 0) {
      ret = {
        "id": friendshipId,
        "fields": {
          DbFields.friendshipPlayer1Id: openGame!.player.id,
          DbFields.friendshipPlayer2Id: opponent.id,
          DbFields.friendshipApproved1: relationState.acceptedByPlayer,
          DbFields.friendshipApproved2: relationState.acceptedByOther,
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
          DbFields.friendshipPlayer1Id: opponent.id,
          DbFields.friendshipPlayer2Id: openGame!.player.id,
          DbFields.friendshipApproved2: relationState.acceptedByPlayer,
          DbFields.friendshipApproved1: relationState.acceptedByOther,
          DbFields.friendshipWonGamesPlayer2: wonGamesPlayer,
          DbFields.friendshipWonGamesPlayer1: wonGamesOther,
          DbFields.friendshipNumGamesPlayed: numGamesPlayed,
          DbFields.friendshipOpenGame: {
            "link": openGame!.id,
          }
        }
      };
    }
    return ret;
  }

  // to be removed
  int getXp() {
    return opponent.getXp();
  }

  // to be removed
  int getLevel() {
    return opponent.getLevel();
  }
}

class PlayerRelationCollection {
  List<PlayerRelation> playerRelations = [];

  PlayerRelationCollection.fromFriendshipMap(
      Map<String, dynamic>? map, Player p) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? playerRelation in map?["edges"]) {
      try {
        playerRelations
            .add(PlayerRelation.fromFriendshipMap(playerRelation?["node"], p));
      } catch (e) {
        debugPrint("Invalid friendship with ID:" +
            playerRelation?["node"]["objectId"]);
      }
    }
  }

  PlayerRelationCollection.fromUserMap(Map<String, dynamic>? map) {
    if (map?["edges"] == null) {
      return;
    }
    for (Map<String, dynamic>? opponent in map?["edges"]) {
      playerRelations.add(PlayerRelation.fromUserMap(opponent?["node"]));
    }
  }
  PlayerRelationCollection.empty() {
    playerRelations = [];
  }

  List<String> getNames() {
    List<String> ret = [];
    for (PlayerRelation pr in playerRelations) {
      ret.add(pr.opponent.name);
    }
    return ret;
  }

  List<PlayerRelation> filterRelationState(RelationState state) {
    List<PlayerRelation> filteredList =
        playerRelations.where((pr) => pr.relationState == state).toList();
    return filteredList;
  }

  List<PlayerRelation> get friends {
    return filterRelationState(RelationState.friend);
  }

  List<PlayerRelation> get sent {
    return filterRelationState(RelationState.sent);
  }

  List<PlayerRelation> get received {
    return filterRelationState(RelationState.received);
  }

  List<PlayerRelation> get playable {
    return playerRelations
        .where((pr) => (pr.openGame != null && pr.openGame!.isPlayersTurn()))
        .toList();
  }
}
