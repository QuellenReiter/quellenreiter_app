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
  bool withTimer = false;
  late int playerIndex;

  // Game.fromMap(Map<String, dynamic>? map) {

  // }
  Game(this.id, this.enemyAnswers, this.playerAnswers, this.playerIndex,
      this.statementIds, this.withTimer);
  Game.empty(bool timer, int playerIndex) {
    // where to get statement ids? download all possible and pickRandom on device.
    // not downloading all but only 50 could be the bin approach wanted.
    // sort by object ID should be date and category independent.

    // get statements directlly and then safe the ids ! :)
    id = null;
    playerIndex = playerIndex;
    id = null;
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
    /// if enemy has answered more or equal number of quests and player is not initiator.
    /// and number of enemy answers is 0,3,6or9
    if (((playerIndex == 1 && enemyAnswers.length % 3 == 0) &&
            enemyAnswers.length >= playerAnswers.length) ||
        ((playerIndex == 0 && enemyAnswers.length % 3 == 0) &&
            enemyAnswers.length > playerAnswers.length)) {
      return true;
    } else {
      return false;
    }
  }
}

class Games {
  List<Game> games = [];
}
