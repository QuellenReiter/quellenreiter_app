import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/stats_app_bar.dart';
import 'package:share_plus/share_plus.dart';

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
  bool playerWon = false;
  bool enemyWon = false;

  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });

    playerWon = widget.appState.currentEnemy!.openGame!.getGameResult() ==
        GameResult.playerWon;

    enemyWon = widget.appState.currentEnemy!.openGame!.getGameResult() ==
        GameResult.enemyWon;

    tempPlayerXp.value = widget.appState.currentEnemy!.openGame!.getPlayerXp();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Spielen"),
      //   actions: [
      //     const Icon(
      //       Icons.monetization_on,
      //       color: DesignColors.yellow,
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.only(right: 20),
      //       child: Center(
      //         // counts up
      //         child: ValueListenableBuilder<int>(
      //           valueListenable: tempPlayerXp,
      //           builder: (BuildContext context, val, child) {
      //             if (countupStartValue == 0) {
      //               return Countup(
      //                 begin: widget.appState.player!.getXp().toDouble(),
      //                 end: widget.appState.player!.getXp().toDouble(),
      //                 duration: const Duration(seconds: 3),
      //                 style: Theme.of(context).textTheme.headline6,
      //               );
      //             } else {
      //               return Countup(
      //                 begin: widget.appState.player!.getXp().toDouble(),
      //                 end: widget.appState.player!.getXp().toDouble() +
      //                     countupStartValue,
      //                 duration: const Duration(seconds: 3),
      //                 style: Theme.of(context)
      //                     .textTheme
      //                     .headline2!
      //                     .copyWith(color: DesignColors.pink),
      //               );
      //             }
      //           },
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      appBar: StatsAppBar(appState: widget.appState),
      body: Center(
        // if updates done, show final screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 70,
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: DesignColors.lightBlue,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        playerWon
                            ? "Du hast\ngewonnen"
                            : enemyWon
                                ? "du hast\nverloren"
                                : "Unentschieden",
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: DesignColors.pink, fontSize: 60),
                      ),
                    ),
                  ),
                ),
                Text(
                  playerWon
                      ? "🏆"
                      : enemyWon
                          ? "🤦"
                          : "🪢",
                  style: const TextStyle(fontSize: 100),
                ),
              ],
            ),
            const SizedBox(height: 0),
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("+ ",
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: DesignColors.yellow)),
                    const Icon(
                      Icons.monetization_on,
                      color: DesignColors.yellow,
                      size: 30,
                    ),
                    ValueListenableBuilder<int>(
                      valueListenable: tempPlayerXp,
                      builder: (BuildContext context, val, child) {
                        return Countup(
                          begin: countupStartValue.toDouble(),
                          end: val.toDouble(),
                          duration: const Duration(seconds: 3),
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onTapGetPoints,
                  child: Text(
                    "Punkte einsammeln",
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 50),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => {
                Share.share("https://quellenreiter.app",
                    subject: "Teile die app mit deinen Freund:innen."),
              },
              icon: Icon(Icons.share),
              label: Text("Mit Freund:innen teilen",
                  style: Theme.of(context).textTheme.headline4),
            )
          ],
        ),

        // Column(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     mainAxisSize: MainAxisSize.max,
        //     children: [
        //       // animate ANIMATE
        //       // make clickable and only then go to next screen
        //       Text(
        //         playerWon
        //             ? "DU HAST GEWONNEN"
        //             : enemyWon
        //                 ? "Du hast verloren."
        //                 : "Unentschieden",
        //         style: Theme.of(context).textTheme.headline3!.copyWith(
        //             color: playerWon
        //                 ? DesignColors.green
        //                 : enemyWon
        //                     ? DesignColors.red
        //                     : DesignColors.backgroundBlue),
        //       ),
        //       Center(
        //         child: Material(
        //           color: DesignColors.pink,
        //           borderRadius: const BorderRadius.all(Radius.circular(10)),
        //           child: InkWell(
        //             borderRadius: const BorderRadius.all(Radius.circular(10)),
        //             onTap: onTapGetPoints,
        //             child: Container(
        //               padding: const EdgeInsets.all(10),
        //               decoration: const BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(10)),
        //               ),
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(
        //                     "+ ",
        //                     style: Theme.of(context).textTheme.headline3,
        //                   ),
        //                   const Icon(
        //                     Icons.monetization_on,
        //                     color: DesignColors.yellow,
        //                     size: 40,
        //                   ),
        //                   ValueListenableBuilder<int>(
        //                     valueListenable: tempPlayerXp,
        //                     builder: (BuildContext context, val, child) {
        //                       return Countup(
        //                         begin: countupStartValue.toDouble(),
        //                         end: val.toDouble(),
        //                         duration: const Duration(seconds: 3),
        //                         style: Theme.of(context).textTheme.headline3,
        //                       );
        //                     },
        //                   ),
        //                   Text(
        //                     "Punkte einsammeln.",
        //                     style: Theme.of(context).textTheme.headline1,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ]),
      ),
    );
  }

  // called on tap of getCoins.
  void onTapGetPoints() async {
    countupStartValue = tempPlayerXp.value;
    tempPlayerXp.value = 0;

    // count down the xp
    // count up the players xp by amount.
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(seconds: 3), () {});
    HapticFeedback.mediumImpact();
    // updating all stats, takes a while.
    await widget.appState.db.checkToken((p) async {
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
      // if statements are not downloaded (especially if player
      // wants to get its points), download them.
      if (widget.appState.currentEnemy!.openGame!.statements == null) {
        widget.appState.currentEnemy!.openGame!.statements =
            await widget.appState.db.getStatements(
                widget.appState.currentEnemy!.openGame!.statementIds!);
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
      } else if (enemyWon) {
        // enemy has won
        // update player
        widget.appState.player!.numPlayedGames += 1;
        widget.appState.player!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
      } else {
        // Game endet in a Tie
        // update player
        widget.appState.player!.numPlayedGames += 1;
        widget.appState.player!.numGamesTied += 1;
        widget.appState.player!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
      }
      // increase played games of friendship if playerIndex = 0
      if (widget.appState.currentEnemy!.openGame!.playerIndex == 0) {
        widget.appState.currentEnemy!.numGamesPlayed += 1;
      }
      bool success = await widget.appState.db.updateGame(widget.appState);

      // delete the game if last player has got its points.
      if (success &&
          widget.appState.currentEnemy!.openGame!.requestingPlayerIndex !=
              widget.appState.currentEnemy!.openGame!.playerIndex) {
        await widget.appState.db
            .deleteGame(widget.appState.currentEnemy!.openGame!);
      }

      return;
    });
    HapticFeedback.heavyImpact();
    widget.appState.route = Routes.home;
  }
}
