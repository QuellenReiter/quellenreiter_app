import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/statement.dart';

import 'enemy.dart';

class Game {
  String? id;
  int round = 0;
  int statementIndex = 0;
  late Statements? statements;
  late List<String>? statementIds;
  late List<bool> playerAnswers;
  late List<bool> enemyAnswers;
  late int requestingPlayerIndex;
  bool withTimer = false;
  late int playerIndex;

  // Game.fromMap(Map<String, dynamic>? map) {

  // }
  Game(this.id, this.enemyAnswers, this.playerAnswers, this.playerIndex,
      this.statementIds, this.withTimer, this.requestingPlayerIndex);

  Game.empty(bool timer, int pIndex) {
    // where to get statement ids? download all possible and pickRandom on device.
    // not downloading all but only 50 could be the bin approach wanted.
    // sort by object ID should be date and category independent.

    // get statements directlly and then safe the ids ! :)
    requestingPlayerIndex = pIndex;
    id = null;
    playerIndex = pIndex;
    statements = null;
    playerAnswers = [];
    enemyAnswers = [];
    withTimer = timer;
    statementIds = null;
    statementIndex = 0;
    statements = null;
    round = 0;
    playerIndex = 0;
  }

  /// Returns true if the player is the next one to play.

  bool isPlayersTurn() {
    bool ret = false;
    // player starts and ( enemy has more or equal answers or player is within a round )
    if ((playerIndex != requestingPlayerIndex &&
            ((enemyAnswers.length >= playerAnswers.length) ||
                playerAnswers.length % 3 != 0)) ||
        // OR: enemy starts and enemy has a finished the round and enemy has more answers
        ((playerIndex == requestingPlayerIndex &&
                enemyAnswers.length % 3 == 0) &&
            enemyAnswers.length > playerAnswers.length)) {
      ret = true;
    } else {
      ret = false;
    }
    // if both have 9 answers.
    if (playerAnswers.length >= 9 && enemyAnswers.length >= 9) {
      ret = false;
    }
    return ret;
  }

  /// Returns true if both players have played 9 statements
  ///
  bool gameFinished() {
    return playerAnswers.length >= 9 && enemyAnswers.length >= 9;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> ret = {};
    if (playerIndex == 0) {
      ret = {
        "id": id,
        "fields": {
          DbFields.gameStatementIds: statementIds ?? [],
          DbFields.gameAnswersPlayer1: playerAnswers,
          DbFields.gameAnswersPlayer2: enemyAnswers,
          DbFields.gameWithTimer: withTimer,
          DbFields.gameRequestingPlayerIndex: requestingPlayerIndex,
        }
      };
    } else {
      ret = {
        "id": id,
        "fields": {
          DbFields.gameStatementIds: statementIds ?? [],
          DbFields.gameAnswersPlayer1: enemyAnswers,
          DbFields.gameAnswersPlayer2: playerAnswers,
          DbFields.gameWithTimer: withTimer,
          DbFields.gameRequestingPlayerIndex: requestingPlayerIndex,
        }
      };
    }

    print(ret);
    return ret;
  }
}

class Games {
  List<Game> games = [];
}
