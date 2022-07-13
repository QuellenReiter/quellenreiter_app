import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../models/enemy.dart';
import '../../widgets/enemy_card.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // create finished games
    List<Widget> finishedGames = [];
    // if any open game is finished and points are not accessed yet.
    if (widget.appState.player!.friends == null) {
      widget.appState.getFriends();
      return const Center(child: CircularProgressIndicator());
    } else if (widget.appState.player!.friends!.enemies.any((element) =>
        (element.openGame != null
            ? (element.openGame!.gameFinished() &&
                    !element.openGame!.pointsAccessed) &&
                element.openGame!.requestingPlayerIndex !=
                    element.openGame!.playerIndex
            : false))) {
      // add the heading
      finishedGames.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.monetization_on,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "punkte abholen",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.player!.friends!.enemies) {
        if (e.openGame != null &&
            e.openGame!.gameFinished() &&
            e.openGame!.requestingPlayerIndex != e.openGame!.playerIndex) {
          finishedGames.add(EnemyCard(
            appState: widget.appState,
            enemy: e,
            onTapped: (enemy) => {},
          ));
        }
      }
    }

    // create "Its your turn" widgets
    List<Widget> playersTurn = [];
    // if any open game is finished and points are not accessed yet.
    if (widget.appState.player!.friends!.enemies.any((element) =>
        (element.openGame != null
            ? element.openGame!.isPlayersTurn()
            : false))) {
      // add the heading
      playersTurn.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_esports,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "du bist dran",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.player!.friends!.enemies) {
        if (e.openGame != null && e.openGame!.isPlayersTurn()) {
          playersTurn.add(EnemyCard(
            appState: widget.appState,
            enemy: e,
            onTapped: (enemy) => {},
          ));
        }
      }
    }

    // create "friendrequest" widgets
    List<Widget> friendRequests = [];
    // if any open game is finished and points are not accessed yet.
    if (widget.appState.enemyRequests != null &&
        widget.appState.enemyRequests!.enemies.isNotEmpty) {
      // add the heading
      friendRequests.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "Neue Anfragen",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.enemyRequests!.enemies) {
        friendRequests.add(EnemyCard(
          appState: widget.appState,
          enemy: e,
          onTapped: (enemy) => {},
        ));
      }
    }

    // create "Start new game" widgets
    List<Widget> startNewGame = [];
    // if any open game is finished and points are not accessed yet.
    if (widget.appState.player!.friends!.enemies
        .any((element) => (element.openGame == null))) {
      // add the heading
      startNewGame.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_esports_outlined,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "Neues Spiel starten",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.player!.friends!.enemies) {
        if (e.openGame == null) {
          startNewGame.add(EnemyCard(
            appState: widget.appState,
            enemy: e,
            onTapped: (enemy) => {},
          ));
        }
      }
    }

    return RefreshIndicator(
      onRefresh: widget.appState.getFriends,
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const AlwaysScrollableScrollPhysics(),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 300),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 20.0,
                curve: Curves.elasticOut,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: DesignColors.backgroundBlue,
                        size: Theme.of(context).textTheme.headline2!.fontSize! +
                            10,
                      ),
                      Text(
                        "Deine Skills",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
                IgnorePointer(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 15,
                            child: SfRadialGauge(
                              backgroundColor: Colors.transparent,
                              animationDuration: 0.4,
                              enableLoadingAnimation: true,
                              axes: [
                                RadialAxis(
                                  useRangeColorForAxis: false,
                                  startAngle: 90,
                                  endAngle: 90,
                                  minimum: 0,
                                  maximum: 1,
                                  ranges: [
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 1,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      startWidth: 0.1,
                                      endWidth: 0.1,
                                      color: Colors.transparent,
                                    ),
                                  ],
                                  showTicks: false,
                                  showLabels: false,
                                  pointers: [
                                    RangePointer(
                                      cornerStyle: CornerStyle.bothCurve,
                                      value: widget.appState.player!
                                                  .numPlayedGames ==
                                              0
                                          ? 0
                                          : widget.appState.player!
                                                  .trueFakeAnswers /
                                              (widget.appState.player!
                                                      .trueFakeAnswers +
                                                  widget.appState.player!
                                                      .falseFakeAnswers),
                                      enableAnimation: true,
                                      width: 20,
                                      color: DesignColors.green,
                                    ),
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                        widget: Container(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.appState.player!
                                                              .numPlayedGames ==
                                                          0
                                                      ? "0%"
                                                      : (widget.appState.player!
                                                                      .trueFakeAnswers /
                                                                  (widget
                                                                          .appState
                                                                          .player!
                                                                          .trueFakeAnswers +
                                                                      widget
                                                                          .appState
                                                                          .player!
                                                                          .falseFakeAnswers) *
                                                                  100)
                                                              .toString()
                                                              .substring(
                                                                  0,
                                                                  min(
                                                                      (widget.appState.player!.trueFakeAnswers /
                                                                              (widget.appState.player!.trueFakeAnswers + widget.appState.player!.falseFakeAnswers) *
                                                                              100)
                                                                          .toString()
                                                                          .length,
                                                                      4)) +
                                                          "%",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .copyWith(
                                                          color: DesignColors
                                                              .green),
                                                ),
                                                Text(
                                                  'Fakes entlarvt',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                          color: DesignColors
                                                              .backgroundBlue),
                                                ),
                                              ]),
                                        ),
                                        angle: 90,
                                        positionFactor: 0)
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 15,
                            child: SfRadialGauge(
                              animationDuration: 0.4,
                              enableLoadingAnimation: true,
                              axes: [
                                RadialAxis(
                                  startAngle: 90,
                                  endAngle: 90,
                                  minimum: 0,
                                  maximum: 1,
                                  ranges: [
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 1,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      color: Colors.transparent,
                                    ),
                                  ],
                                  showTicks: false,
                                  showLabels: false,
                                  pointers: [
                                    RangePointer(
                                      cornerStyle: CornerStyle.bothCurve,
                                      value: widget.appState.player!
                                                  .numPlayedGames ==
                                              0
                                          ? 0
                                          : widget.appState.player!
                                                  .trueCorrectAnswers /
                                              (widget.appState.player!
                                                      .trueCorrectAnswers +
                                                  widget.appState.player!
                                                      .falseCorrectAnswers),
                                      enableAnimation: true,
                                      width: 20,
                                      color: DesignColors.green,
                                    ),
                                  ],
                                  annotations: [
                                    GaugeAnnotation(
                                        widget: Container(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.appState.player!
                                                              .numPlayedGames ==
                                                          0
                                                      ? "0%"
                                                      : (widget.appState.player!
                                                                      .trueCorrectAnswers /
                                                                  (widget
                                                                          .appState
                                                                          .player!
                                                                          .trueCorrectAnswers +
                                                                      widget
                                                                          .appState
                                                                          .player!
                                                                          .falseCorrectAnswers) *
                                                                  100)
                                                              .toString()
                                                              .substring(
                                                                  0,
                                                                  min(
                                                                      (widget.appState.player!.trueCorrectAnswers /
                                                                              (widget.appState.player!.trueCorrectAnswers + widget.appState.player!.falseCorrectAnswers) *
                                                                              100)
                                                                          .toString()
                                                                          .length,
                                                                      4)) +
                                                          "%",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline1!
                                                      .copyWith(
                                                          color: DesignColors
                                                              .green),
                                                ),
                                                Text(
                                                  'Fakten erkannt',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                          color: DesignColors
                                                              .backgroundBlue),
                                                ),
                                              ]),
                                        ),
                                        angle: 90,
                                        positionFactor: 0)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.appState.route = Routes.addFriends;
                            },
                            icon: Icon(
                              Icons.person_search_rounded,
                            ),
                            label: Text(
                              "suchen",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Share.share(
                                  'Quiz-Duell nur mit "Fake News":\nhttps://quellenreiter.app',
                                  subject:
                                      "Teile die app mit deinen Freund:innen.");
                            },
                            icon: Icon(Icons.share_outlined),
                            label: Text(
                              "einladen",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                      ]),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Divider(
                    color: DesignColors.backgroundBlue,
                  ),
                ),
                ...finishedGames,
                ...friendRequests,
                if (playersTurn.isEmpty && finishedGames.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 50),
                    child: Text("Du hast keine offenen Spiele.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: DesignColors.lightBlue)),
                  ))
                else
                  ...playersTurn,
                ...startNewGame
              ],
            ),
          ),
        ),
      ),
    );
  }
}
