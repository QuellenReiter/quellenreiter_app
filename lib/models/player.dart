import 'package:quellenreiter_app/models/enemy.dart';
import 'game.dart';

class Player {
  late String name;
  late String emoji;
  String? email;
  late int numPlayedGames;
  late int totalCorrectAnswers;
  late int falseCorrectAnswers;
  late int falseFakeAnswers;
  late List<Enemy> friends;
  late List<Game> openGames;
  late List<String> playedStatementIds;
}
