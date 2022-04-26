import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/statement.dart';

import 'enemy.dart';

class Game {
  int round = 0;
  int statementIndex = 0;
  late final Statements? statements;
  late final Enemy enemy;
  late bool playersTurn;
  late List<bool> playerAnswers;
  late List<bool> enemyAnswers;

  Game.fromMap(Map<String, dynamic>? map) {
    statements = null;
    enemy = map?[DbFields.enemyName]; //  WRONG
    playersTurn = true;
    playerAnswers = [];
    enemyAnswers = [];
  }

  Game.new(Enemy e) {
    statements = null;
    enemy = e;
    playersTurn = true;
    playerAnswers = [];
    enemyAnswers = [];
  }
}

class Games {
  List<Game> games = [];

  Games.fromMap(Map<String, dynamic>? map) {
    for (Map<String, dynamic>? game in map?["edges"]) {
      if (game?["node"][DbFields.friendshipOpenGame]?["edges"].isEmpty) {
        return;
      }
      games.add(Game.fromMap(
          game?["node"][DbFields.friendshipOpenGame]?["edges"][0]["node"]));
    }
  }
}
