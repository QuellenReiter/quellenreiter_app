import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  bool pointButtonTapped = false;

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

    return Stack(children: [
      Scaffold(
        body: SafeArea(
          child: Center(
            // if updates done, show final screen
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 100.0,
                    curve: Curves.bounceOut,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    ValueListenableBuilder<int>(
                        valueListenable: tempPlayerXp,
                        builder: (BuildContext context, val, child) {
                          return Container(
                            margin: const EdgeInsets.all(10),
                            clipBehavior: Clip.none,
                            padding: const EdgeInsets.all(10),
                            height: AppBar().preferredSize.height * 1.5,
                            // Set background color and rounded bottom corners.
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: DesignColors.backgroundBlue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    widget.appState.player!.emoji,
                                    style: TextStyle(fontSize: 50),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.appState.player!.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1,
                                      ),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // if (widget.appState.player!.getXp().toDouble() +
                                            //         countupStartValue >
                                            //     widget.appState.player!.getNextLevelXp())
                                            SfLinearGauge(
                                              minimum:
                                                  GameRules.xpForCurrentLevel(
                                                          widget.appState
                                                                  .player!
                                                                  .getXp() +
                                                              countupStartValue)
                                                      .toDouble(),
                                              maximum: GameRules.xpForNextLevel(
                                                      widget.appState.player!
                                                              .getXp() +
                                                          countupStartValue)
                                                  .toDouble(),
                                              animateAxis: true,
                                              axisTrackStyle:
                                                  LinearAxisTrackStyle(
                                                thickness: 20,
                                                edgeStyle:
                                                    LinearEdgeStyle.bothCurve,
                                              ),
                                              animateRange: true,
                                              animationDuration:
                                                  countupStartValue > 0
                                                      ? 3000
                                                      : 400,
                                              showTicks: false,
                                              showLabels: false,
                                              barPointers: [
                                                LinearBarPointer(
                                                  edgeStyle:
                                                      LinearEdgeStyle.bothCurve,
                                                  thickness: 20,
                                                  value: widget.appState.player!
                                                          .getXp()
                                                          .toDouble() +
                                                      countupStartValue,
                                                  color: DesignColors.pink,
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              child: AnimationLimiter(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children:
                                                      AnimationConfiguration
                                                          .toStaggeredList(
                                                    duration: const Duration(
                                                        milliseconds: 500),
                                                    childAnimationBuilder:
                                                        (widget) =>
                                                            SlideAnimation(
                                                      horizontalOffset: 50.0,
                                                      curve: Curves.bounceOut,
                                                      child: FadeInAnimation(
                                                        child: widget,
                                                      ),
                                                    ),
                                                    children: [
                                                      Text(
                                                        widget.appState.player!
                                                            .getLevel()
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5,
                                                      ),
                                                      Text(
                                                        (widget.appState.player!
                                                                        .getXp() +
                                                                    countupStartValue)
                                                                .toString() +
                                                            "/" +
                                                            widget.appState
                                                                .player!
                                                                .getNextLevelXp()
                                                                .toString() +
                                                            " XP",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5,
                                                      ),
                                                      Text(
                                                        (widget.appState.player!
                                                                    .getLevel() +
                                                                1)
                                                            .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ]),
                                    ],
                                  ),
                                ),
                                if (widget.appState.player!.getXp().toDouble() +
                                        countupStartValue <
                                    widget.appState.player!.getNextLevelXp())
                                  AnimationLimiter(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: AnimationConfiguration
                                          .toStaggeredList(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        childAnimationBuilder: (widget) =>
                                            SlideAnimation(
                                          horizontalOffset: 50.0,
                                          curve: Curves.bounceOut,
                                          child: FadeInAnimation(
                                            child: widget,
                                          ),
                                        ),
                                        children: [
                                          Icon(
                                            Icons.workspace_premium_rounded,
                                            size: 40,
                                            color: DesignColors.yellow,
                                          ),
                                          Text(
                                            '${GameRules.currentLevel(widget.appState.player!.getXp() + countupStartValue)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1!
                                                .copyWith(
                                                    color: DesignColors.yellow),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  PlayAnimation(
                                    duration: const Duration(milliseconds: 500),
                                    tween: Tween<double>(
                                      begin: 1,
                                      end: 1.5,
                                    ),
                                    curve: Curves.elasticOut,
                                    builder: (context, child, double value) =>
                                        Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.workspace_premium_rounded,
                                          size: 40 * value,
                                          color: DesignColors.yellow,
                                        ),
                                        Text(
                                          '${GameRules.currentLevel(widget.appState.player!.getXp() + countupStartValue)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .copyWith(
                                                  color: DesignColors.yellow,
                                                  fontSize: 40 * value),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                    PlayAnimation(
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 500),
                      tween: Tween<double>(
                        begin: 0.0,
                        end: 1,
                      ),
                      curve: Curves.bounceOut,
                      builder: (context, child, double value) => Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 70,
                            child: Container(
                              margin: EdgeInsets.all(500 - value * 500),
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
                                      .copyWith(
                                          color: DesignColors.pink,
                                          fontSize: 60 * value),
                                  textAlign: TextAlign.center,
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
                            style: TextStyle(fontSize: 100 * value),
                          ),
                        ],
                      ),
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
                        if (!pointButtonTapped)
                          MirrorAnimation(
                            duration: const Duration(milliseconds: 1000),
                            tween: Tween<double>(
                              begin: 1,
                              end: 1.05,
                            ),
                            curve: Curves.elasticIn,
                            builder: (context, child, double value) =>
                                ElevatedButton(
                              onPressed: onTapGetPoints,
                              child: Text(
                                "Punkte einsammeln",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(fontSize: 50 * value),
                              ),
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: null,
                            child: Text(
                              "Punkte eingesammelt",
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
              ),
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
        ),
      ),
    ]);
  }

  // called on tap of getCoins.
  void onTapGetPoints() async {
    pointButtonTapped = true;
    countupStartValue = tempPlayerXp.value;
    tempPlayerXp.value = 0;

    // await showDialog(
    //     context: context,
    //     builder: (context) {
    //       // show for 3 seconds
    //       // Future.delayed(const Duration(seconds: 3))
    //       //     .then((value) => Navigator.of(context).pop());
    //       return Dialog(
    //         insetPadding:
    //             const EdgeInsets.symmetric(horizontal: 40, vertical: 100),
    //         child: Center(
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Row(
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.only(right: 20),
    //                     child: Center(
    //                       // counts up
    //                       child: ValueListenableBuilder<int>(
    //                         valueListenable: tempPlayerXp,
    //                         builder: (BuildContext context, val, child) {
    //                           return Countup(
    //                             begin:
    //                                 widget.appState.player!.getXp().toDouble(),
    //                             end:
    //                                 widget.appState.player!.getXp().toDouble() +
    //                                     countupStartValue,
    //                             duration: const Duration(seconds: 3),
    //                             style: Theme.of(context)
    //                                 .textTheme
    //                                 .headline2!
    //                                 .copyWith(color: DesignColors.yellow),
    //                           );
    //                         },
    //                       ),
    //                     ),
    //                   ),
    //                   Text(
    //                     "XP",
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .headline1!
    //                         .copyWith(color: DesignColors.yellow),
    //                   ),
    //                 ],
    //               ),
    //               // if reached new level
    //               if (widget.appState.player!.getXp() + countupStartValue >=
    //                   widget.appState.player!.getNextLevelXp())
    //                 AnimationLimiter(
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: AnimationConfiguration.toStaggeredList(
    //                       duration: const Duration(milliseconds: 3000),
    //                       childAnimationBuilder: (widget) => SlideAnimation(
    //                         horizontalOffset: 50.0,
    //                         curve: Curves.bounceOut,
    //                         child: FadeInAnimation(
    //                           child: widget,
    //                         ),
    //                       ),
    //                       children: [
    //                         const Icon(
    //                           Icons.workspace_premium_rounded,
    //                           size: 50,
    //                           color: DesignColors.yellow,
    //                         ),
    //                         Text(
    //                           '${GameRules.currentLevel(widget.appState.player!.getXp() + countupStartValue)}',
    //                           style: Theme.of(context)
    //                               .textTheme
    //                               .headline1!
    //                               .copyWith(color: DesignColors.yellow),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //             ],
    //           ),
    //         ),
    //       );
    //     });

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
    await widget.appState.getFriends();
    HapticFeedback.heavyImpact();
    // pop the dialog and go to next screen.
    Navigator.of(context).pop();
    widget.appState.route = Routes.home;
  }
}
