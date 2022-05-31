import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../constants/constants.dart';
import '../../models/game.dart';

class GameFinishedScreen extends StatefulWidget {
  const GameFinishedScreen({Key? key, required this.appState})
      : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<GameFinishedScreen> createState() => _GameFinishedScreenState();
}

class _GameFinishedScreenState extends State<GameFinishedScreen> {
  ValueNotifier<int> tempPlayerXp = ValueNotifier(0);
  int countupStartValue = 0;
  bool updatesDone = false;

  @override
  Widget build(BuildContext context) {
    var playerWon = widget.appState.currentEnemy!.openGame!.getGameResult() ==
        GameResult.playerWon;

    var enemyWon = widget.appState.currentEnemy!.openGame!.getGameResult() ==
        GameResult.enemyWon;

    tempPlayerXp.value = widget.appState.currentEnemy!.openGame!.getPlayerXp();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielen"),
        actions: [
          const Icon(
            Icons.monetization_on,
            color: DesignColors.yellow,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(
                child: Countup(
              begin: 0,
              end: widget.appState.player!.getXp().toDouble(),
              duration: const Duration(milliseconds: 500),
              style: Theme.of(context).textTheme.headline6,
            )),
          ),
        ],
      ),
      body: Center(
        // if updates done, show final screen
        child: Column(children: [
          // animate ANIMATE
          // make clickable and only then go to next screen
          Text(
            playerWon
                ? "DU HAST GEWONNEN"
                : enemyWon
                    ? "Du hast verloren."
                    : "unentschieden",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(color: DesignColors.green),
          ),
          Center(
            child: Material(
              color: DesignColors.pink,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                onTap: () async {
                  countupStartValue = tempPlayerXp.value;
                  tempPlayerXp.value = 0;

                  // count down the xp
                  // count up the players xp by amount.
                  HapticFeedback.mediumImpact();
                  await Future.delayed(const Duration(seconds: 3), () {});

                  // updating all stats, takes a while.
                  await widget.appState.db.checkToken((p) {
                    // if player is not null
                    if (p != null) {
                      // update current player
                      widget.appState.player = p;
                      widget.appState.error = null;
                    } else {
                      widget.appState.error = "Spieler nicht up to date.";
                      // return to ready to start screen.
                      widget.appState.route = Routes.gameReadyToStart;
                      return;
                    }
                    if (playerWon) {
                      // player has won
                      widget.appState.currentEnemy!.wonGamesPlayer += 1;
                      // update player
                      widget.appState.player!.numGamesWon += 1;
                      widget.appState.player!.numPlayedGames += 1;
                      widget.appState.player!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.playerAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                      // update enemy
                      widget.appState.currentEnemy!.numGamesPlayedOther += 1;
                      widget.appState.currentEnemy!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.enemyAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                    } else if (enemyWon) {
                      // enemy has won
                      widget.appState.currentEnemy!.wonGamesOther += 1;
                      // update player
                      widget.appState.player!.numPlayedGames += 1;
                      widget.appState.player!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.playerAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                      // update enemy
                      widget.appState.currentEnemy!.numGamesPlayedOther += 1;
                      widget.appState.currentEnemy!.numGamesWonOther += 1;
                      widget.appState.currentEnemy!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.playerAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                    } else {
                      // Game endet in a Tie
                      // update player
                      widget.appState.player!.numPlayedGames += 1;
                      widget.appState.player!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.playerAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                      // update enemy
                      widget.appState.currentEnemy!.numGamesPlayedOther += 1;
                      widget.appState.currentEnemy!.updateAnswerStats(
                          widget.appState.currentEnemy!.openGame!.enemyAnswers,
                          widget.appState.currentEnemy!.openGame!.statements);
                    }
                    // increase played games of friendship
                    widget.appState.currentEnemy!.numGamesPlayed += 1;

                    // update the player so we dont miss any updates made by other player/games.
                    widget.appState.db.updateGame(widget.appState);
                    widget.appState.route = Routes.gameReadyToStart;
                    return;
                  });

                  HapticFeedback.mediumImpact();
                  widget.appState.route = Routes.gameReadyToStart;
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "+ ",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      const Icon(
                        Icons.monetization_on,
                        color: DesignColors.yellow,
                        size: 40,
                      ),
                      ValueListenableBuilder<int>(
                        valueListenable: tempPlayerXp,
                        builder: (BuildContext context, val, child) {
                          return Countup(
                            begin: countupStartValue.toDouble(),
                            end: val.toDouble(),
                            duration: const Duration(seconds: 3),
                            style: Theme.of(context).textTheme.headline3,
                          );
                        },
                      ),
                      Text(
                        " abholen.",
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
