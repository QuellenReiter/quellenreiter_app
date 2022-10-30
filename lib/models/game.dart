import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/models/statement.dart';

import 'enemy.dart';

class GamePlayer {
  late String? id;
  late List<bool> answers;

  GamePlayer(this.id, this.answers);

  GamePlayer.fromDbMap(Map<String, dynamic> openGame, bool isFirstPlayer) {
    id = openGame[
        isFirstPlayer ? DbFields.gamePlayer1Id : DbFields.gamePlayer2Id];
    answers = openGame[isFirstPlayer
            ? DbFields.gameAnswersPlayer1
            : DbFields.gameAnswersPlayer2]
        .map((x) => x["value"])
        .toList()
        .cast<bool>();
  }
}

class Game {
  String? id;
  int statementIndex = 0;
  late Statements? statements;
  late List<String>? statementIds;
  late int requestingPlayerIndex;
  bool withTimer = false;
  late int playerIndex;
  late bool pointsAccessed;
  late GamePlayer player;
  late GamePlayer opponent;

  // Game.fromMap(Map<String, dynamic>? map) {

  // }
  Game(
      this.id,
      this.player,
      this.opponent,
      this.playerIndex,
      this.statementIds,
      this.withTimer,
      this.requestingPlayerIndex,
      this.statements,
      this.pointsAccessed);

  Game.empty(bool timer, Enemy e, Player p) {
    // where to get statement ids? download all possible and pickRandom on device.
    // not downloading all but only 50 could be the bin approach wanted.
    // sort by object ID should be date and category independent.

    // get statements directlly and then safe the ids ! :)
    requestingPlayerIndex = e.playerIndex;
    id = null;
    withTimer = timer;
    statementIds = null;
    statementIndex = 0;
    statements = null;
    playerIndex = 0;
    pointsAccessed = false;
    player = GamePlayer(p.id, []);
    opponent = GamePlayer(e.userId, []);
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
    return player.answers.length >= 9 && opponent.answers.length >= 9;
  }

  Map<String, dynamic> toMap() {
    GamePlayer player1Db = playerIndex == 0 ? player : opponent;
    GamePlayer player2Db = playerIndex == 1 ? player : opponent;

    Map<String, dynamic> ret = {
      "id": id,
      "fields": {
        DbFields.gamePlayer1Id: player1Db.id,
        DbFields.gamePlayer2Id: player2Db.id,
        DbFields.gameStatementIds: statementIds ?? [],
        DbFields.gameAnswersPlayer1: player1Db.answers,
        DbFields.gameAnswersPlayer2: player2Db.answers,
        DbFields.gameWithTimer: withTimer,
        DbFields.gameRequestingPlayerIndex: requestingPlayerIndex,
        DbFields.gamePointsAccessed: pointsAccessed == false ? null : true,
      }
    };

    // removes null values, important if enemyId and playerId are null.
    ret["fields"].removeWhere((key, value) => value == null);

    // print(ret);
    return ret;
  }

  GameResult getGameResult() {
    if (playerAnswers.fold<int>(0, (p, c) => p + (c ? 1 : 0)) >
        enemyAnswers.fold<int>(0, (p, c) => p + (c ? 1 : 0))) {
      return GameResult.playerWon;
    } else if (playerAnswers.fold<int>(0, (p, c) => p + (c ? 1 : 0)) <
        enemyAnswers.fold<int>(0, (p, c) => p + (c ? 1 : 0))) {
      return GameResult.enemyWon;
    } else {
      return GameResult.tied;
    }
  }

  int getPlayerXp() {
    int xp = 0;
    xp = playerAnswers.fold<int>(0, (p, c) => p + (c ? 1 : 0)) *
        GameRules.pointsPerCorrectAnswer;
    if (getGameResult() == GameResult.tied) {
      xp += GameRules.pointsPerTiedGame;
    } else if (getGameResult() == GameResult.playerWon) {
      xp += GameRules.pointsPerWonGame;
    }
    return xp;
  }
}

class Games {
  List<Game> games = [];
}

enum GameResult { playerWon, tied, enemyWon }
