import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_animations/stateless_animation/play_animation.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../models/enemy.dart';
import '../../models/player.dart';
import '../../widgets/enemy_card.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Player player;

  @override
  void initState() {
    player = widget.appState.player!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StartScreen oldWidget) {
    // make sure stats get rebuild when page is back in focus
    setState(() {
      player = widget.appState.player!;
    });
    super.didUpdateWidget(oldWidget);
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
    if (widget.appState.playableEnemies != null &&
        widget.appState.playableEnemies!.enemies.isNotEmpty) {
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
      for (Enemy e in widget.appState.playableEnemies!.enemies) {
        playersTurn.add(EnemyCard(
          appState: widget.appState,
          enemy: e,
          onTapped: (enemy) => {},
        ));
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
    // if no open game or open game is finished and points accessed.
    if (widget.appState.player!.friends!.enemies.any((element) =>
        (element.openGame == null ||
            (element.openGame!.gameFinished() &&
                element.openGame!.pointsAccessed)))) {
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
        if (e.openGame == null ||
            (e.openGame!.gameFinished() && e.openGame!.pointsAccessed)) {
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
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        primary: false,
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
                        "Dein Skill",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: PlayAnimation(
                      duration: const Duration(milliseconds: 500),
                      tween: Tween<double>(
                        begin: 0.0,
                        end: 1,
                      ),
                      curve: Curves.easeInOut,
                      builder: (context, child, double value) => Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.topCenter,
                        children: [
                          Positioned(
                            top: 30,
                            child: Stack(children: [
                              Container(
                                margin: EdgeInsets.all(20 - value * 20),
                                padding: const EdgeInsets.all(30),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: DesignColors.lightBlue,
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Countup(
                                        duration: const Duration(seconds: 1),
                                        begin: 0,
                                        end: !player.statsCanBeCalculated()
                                            ? 0
                                            : (((player.trueCorrectAnswers +
                                                            player
                                                                .trueFakeAnswers) /
                                                        (player.numPlayedGames *
                                                            9)) *
                                                    100)
                                                .round()
                                                .toDouble(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                color: DesignColors.green,
                                                fontSize: 120 * value),
                                      ),
                                      Text(
                                        "%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1!
                                            .copyWith(
                                                color: DesignColors.green,
                                                fontSize: 120 * value),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 30,
                                child: IconButton(
                                  iconSize: 30,
                                  color: DesignColors.backgroundBlue,
                                  icon: const Icon(Icons.info),
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      isScrollControlled: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isDismissible: true,
                                      builder: (BuildContext context) {
                                        HapticFeedback.mediumImpact();
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                            ),
                                          ),
                                          child: SafeArea(
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              constraints: const BoxConstraints(
                                                maxWidth: 700,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Flexible(
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.trending_up,
                                                          size: 60,
                                                          color: DesignColors
                                                              .backgroundBlue,
                                                        ),
                                                        SelectableText(
                                                          "Deine Statistiken",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline2!
                                                              .copyWith(
                                                                  color: DesignColors
                                                                      .backgroundBlue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    widget
                                                        .appState.player!.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5,
                                                  ),
                                                  if (!player
                                                      .statsCanBeCalculated())
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Text(
                                                        "Nicht genügend Infos, spiele weiter!",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline2!
                                                            .copyWith(
                                                                color: DesignColors
                                                                    .lightBlue),
                                                      ),
                                                    )
                                                  else
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Builder(builder:
                                                                (context) {
                                                              return Flexible(
                                                                child: buildStatsWithRectangle(
                                                                    val: player
                                                                        .numGamesWon,
                                                                    label:
                                                                        "Gewonnen",
                                                                    color: DesignColors
                                                                        .green),
                                                              );
                                                            }),
                                                            Flexible(
                                                              child: buildStatsWithRectangle(
                                                                  val: player
                                                                      .numGamesTied,
                                                                  label:
                                                                      "Unentschieden",
                                                                  color: DesignColors
                                                                      .backgroundBlue),
                                                            ),
                                                            Flexible(
                                                              child: buildStatsWithRectangle(
                                                                  val: player.numPlayedGames -
                                                                      (player.numGamesTied +
                                                                          player
                                                                              .numGamesWon),
                                                                  label:
                                                                      "Verloren",
                                                                  color:
                                                                      DesignColors
                                                                          .red),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        buildLinearStatsBar(
                                                            max: (player.trueCorrectAnswers +
                                                                    player
                                                                        .falseCorrectAnswers)
                                                                .toDouble(),
                                                            val: player
                                                                .trueCorrectAnswers
                                                                .toDouble(),
                                                            label:
                                                                "Fakten: ${((player.trueCorrectAnswers / (player.trueCorrectAnswers + player.falseCorrectAnswers)) * 100).round()}% erkannt"),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        buildLinearStatsBar(
                                                            max: (player.trueFakeAnswers +
                                                                    player
                                                                        .falseFakeAnswers)
                                                                .toDouble(),
                                                            val: player
                                                                .trueFakeAnswers
                                                                .toDouble(),
                                                            label:
                                                                "Fakes: ${((player.trueFakeAnswers / (player.trueFakeAnswers + player.falseFakeAnswers)) * 100).round()}% erkannt"),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        buildLinearStatsBar(
                                                            max:
                                                                (player.numPlayedGames *
                                                                        9)
                                                                    .toDouble(),
                                                            val: (player.trueCorrectAnswers +
                                                                    player
                                                                        .trueFakeAnswers)
                                                                .toDouble(),
                                                            label:
                                                                "Insgesamt: ${(((player.trueCorrectAnswers + player.trueFakeAnswers) / (player.numPlayedGames * 9)) * 100).round()}% richtige Antworten"),
                                                        const SizedBox(
                                                            height: 20),
                                                        SelectableText(
                                                          "Deine Statistiken werden nach jedem Spiel aktualisiert.",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText2!
                                                                  .copyWith(
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                          textAlign:
                                                              TextAlign.start,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ]),
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
                if (widget.appState.player!.friends == null ||
                    widget.appState.player!.friends!.enemies.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 50),
                    child: Text("Lade Freund:innen ein, um zu spielen.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(color: DesignColors.lightBlue)),
                  ))
                else if (playersTurn.isEmpty && finishedGames.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 50),
                    child: Text("Du bist bei keinem Spiel an der Reihe",
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

  Widget buildLinearStatsBar(
      {double max = 0, double val = 0, String label = ""}) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SfLinearGauge(
          minimum: 0,
          maximum: max,
          animateAxis: true,
          axisTrackStyle: LinearAxisTrackStyle(
            thickness: 35,
            edgeStyle: LinearEdgeStyle.bothCurve,
          ),
          animateRange: true,
          animationDuration: 400,
          showTicks: false,
          showLabels: false,
          barPointers: [
            LinearBarPointer(
              edgeStyle: LinearEdgeStyle.bothCurve,
              thickness: 35,
              value: val,
              color: DesignColors.yellow,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: DesignColors.pink),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildStatsWithRectangle(
      {int val = 0, String label = "", Color color = Colors.transparent}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: DesignColors.lightGrey,
      ),
      child: Text(
        "${val}x \n ${label}",
        style: Theme.of(context).textTheme.headline4!.copyWith(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }
}
