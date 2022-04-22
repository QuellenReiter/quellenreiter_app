import 'package:quellenreiter_app/models/statement.dart';

import 'enemy.dart';

class Game {
  int round = 0;
  int statementIndex = 0;
  late final Statements statements;
  late final Enemy enemy;
  late bool playersTurn;
  late List<bool> playerAnswers;
  late List<bool> enemyAnswers;
}

class Games {
  late List<Game> games;
}
