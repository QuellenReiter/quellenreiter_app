import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/models/statement.dart';

import 'player_relation.dart';

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

  int getPoints() {
    return answers.where((ans) => ans).length;
  }

  int get amountAnswered {
    return answers.length;
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

  Game.fromDbMap(Map<String, dynamic> openGame, int playerIdx) {
    playerIndex = playerIdx;

    bool isFirstPlayer = playerIndex == 0;
    //object Id
    id = openGame["objectId"];
    // player [GamePlayer] object
    player = GamePlayer.fromDbMap(openGame, isFirstPlayer);
    // opponent [GamePlayer] object
    opponent = GamePlayer.fromDbMap(openGame, !isFirstPlayer);

    statementIds = openGame[DbFields.gameStatementIds]
        .map((x) => x["value"])
        .toList()
        .cast<String>();
    withTimer = openGame[DbFields.gameWithTimer];
    requestingPlayerIndex = openGame[DbFields.gameRequestingPlayerIndex];
    statements = null;
    pointsAccessed = openGame[DbFields.gamePointsAccessed];
  }

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

  Game.empty(bool timer, PlayerRelation e, Player p) {
    // where to get statement ids? download all possible and pickRandom on device.
    // not downloading all but only 50 could be the bin approach wanted.
    // sort by object ID should be date and category independent.

    // get statements directly and then save the ids! :)
    requestingPlayerIndex = e.playerIndex;
    id = null;
    withTimer = timer;
    statementIds = null;
    statementIndex = 0;
    statements = null;
    playerIndex = 0;
    pointsAccessed = false;
    player = GamePlayer(p.id, []);
    opponent = GamePlayer(e.opponent.id, []);
  }

  /// Returns true if the player is the next one to play.
  bool isPlayersTurn() {
    if (gameFinished()) {
      return false;
    }
    // player starts and (opponent has more or equal answers or player is within a round)
    return (playerIndex != requestingPlayerIndex &&
            (opponent.amountAnswered >= player.amountAnswered ||
                player.amountAnswered % 3 != 0) ||
        // OR: opponent starts, has finished a round and has more answers
        (playerIndex == requestingPlayerIndex &&
            opponent.amountAnswered % 3 == 0 &&
            opponent.amountAnswered > player.amountAnswered));
  }

  /// Returns true if both players have played 9 statements
  bool gameFinished() {
    return player.amountAnswered >= 9 && opponent.amountAnswered >= 9;
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

    // removes null values, important if opponentId and playerId are null.
    ret["fields"].removeWhere((key, value) => value == null);

    return ret;
  }

  GameResult getGameResult() {
    int playerPoints = player.getPoints();
    int opponentPoints = opponent.getPoints();
    if (playerPoints > opponentPoints) {
      return GameResult.playerWon;
    } else if (playerPoints < opponentPoints) {
      return GameResult.opponentWon;
    } else {
      return GameResult.tied;
    }
  }

  int getPlayerXp() {
    int xp = player.getPoints() * GameRules.pointsPerCorrectAnswer;
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

enum GameResult { playerWon, tied, opponentWon }
