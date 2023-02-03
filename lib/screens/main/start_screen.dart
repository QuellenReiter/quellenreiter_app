import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/custom_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../models/player_relation.dart';
import '../../models/player.dart';
import '../../widgets/opponent_card.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late Player _player;

  @override
  void initState() {
    _player = widget.appState.player!;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StartScreen oldWidget) {
    // make sure stats get rebuild when page is back in focus
    setState(() {
      _player = widget.appState.player!;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // create finished games
    List<Widget> finishedGames = [];

    List<PlayerRelation> friends = widget.appState.playerRelations.friends;
    List<bool> isFinished = friends
        .map((e) => // TODO write a member function for this
            e.openGame != null &&
            e.openGame!.gameFinished() &&
            !e.openGame!.pointsAccessed &&
            e.openGame!.requestingPlayerIndex != e.openGame!.playerIndex)
        .toList();

    if (isFinished.any((e) => e)) {
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
      for (var i = 0; i < friends.length; i++) {
        if (!isFinished[i]) {
          continue;
        }

        finishedGames.add(OpponentCard(
          appState: widget.appState,
          playerRelation: friends[i],
          onTapped: (_) => {},
        ));
      }
    }

    // create "Its your turn" widgets
    List<Widget> playersTurn = [];
    // if any open game is finished and points are not accessed yet.
    List<PlayerRelation> playableOpponents =
        widget.appState.playerRelations.playable;
    if (playableOpponents.isNotEmpty) {
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
      for (PlayerRelation pr in playableOpponents) {
        playersTurn.add(OpponentCard(
          appState: widget.appState,
          playerRelation: pr,
          onTapped: (opponent) => {},
        ));
      }
    }

    // create "friendrequest" widgets
    List<Widget> friendRequestWidgets = [];
    List<PlayerRelation> receivedFriendRequests =
        widget.appState.playerRelations.received;
    // if any open game is finished and points are not accessed yet.
    if (receivedFriendRequests.isNotEmpty) {
      // add the heading
      friendRequestWidgets.add(
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
      for (PlayerRelation pr in receivedFriendRequests) {
        friendRequestWidgets.add(OpponentCard(
          appState: widget.appState,
          playerRelation: pr,
          onTapped: (opponent) => {},
        ));
      }
    }

    // create "Start new game" widgets
    List<Widget> startableGameWidgets = [];
    // if no open game or open game is finished and points accessed.
    if (widget.appState.playerRelations.friends.any((pr) =>
        (pr.openGame == null ||
            (pr.openGame!.gameFinished() && pr.openGame!.pointsAccessed)))) {
      // add the heading
      startableGameWidgets.add(
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
      for (PlayerRelation pr in widget.appState.playerRelations.friends) {
        if (pr.openGame == null ||
            (pr.openGame!.gameFinished() && pr.openGame!.pointsAccessed)) {
          startableGameWidgets.add(OpponentCard(
            appState: widget.appState,
            playerRelation: pr,
            onTapped: (opponent) => {},
          ));
        }
      }
    }

    return RefreshIndicator(
      onRefresh: widget.appState.getPlayerRelations,
      child: SingleChildScrollView(
        key: WidgetKeys.startScreen,
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
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: PlayAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(
                      begin: 0.0,
                      end: 1,
                    ),
                    curve: Curves.easeInOut,
                    builder: (context, double value, _) =>
                        Stack(alignment: Alignment.center, children: [
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Countup(
                                duration: const Duration(seconds: 1),
                                begin: 0,
                                end: !_player.statsCanBeCalculated()
                                    ? 0
                                    : (((_player.trueCorrectAnswers +
                                                    _player.trueFakeAnswers) /
                                                (_player.numPlayedGames * 9)) *
                                            100)
                                        .round()
                                        .toDouble(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        color: DesignColors.green,
                                        fontSize: 100 * value),
                              ),
                              Text(
                                "%",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        color: DesignColors.green,
                                        fontSize: 100 * value),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right:
                              (MediaQuery.of(context).size.width * 0.5) - 100,
                          child: infoStatsButton())
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            icon: const Icon(
                              Icons.person_search_rounded,
                            ),
                            label: Text(
                              "suchen",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              Share.share(
                                  'Quiz-Duell nur mit "Fake News":\n${PublicURLs.quellenreiterWebsite}',
                                  subject:
                                      "Teile die app mit deinen Freund:innen");
                            },
                            icon: const Icon(Icons.share_outlined),
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
                ...friendRequestWidgets,
                if (widget.appState.playerRelations.friends.isEmpty)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(
                        top: 50, left: 20, right: 20, bottom: 50),
                    child: Text("Lade Freund:innen ein, um zu spielen",
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
                ...startableGameWidgets
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
          axisTrackStyle: const LinearAxisTrackStyle(
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
        "${val}x\n$label",
        style: Theme.of(context).textTheme.headline4!.copyWith(color: color),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget infoStatsButton() {
    return IconButton(
      iconSize: 30,
      color: DesignColors.backgroundBlue,
      icon: const Icon(Icons.info),
      onPressed: () {
        CustomBottomSheet.showCustomBottomSheet(
          context: context,
          scrollable: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 60,
                      color: DesignColors.backgroundBlue,
                    ),
                    SelectableText(
                      "Deine Statistiken",
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: DesignColors.backgroundBlue),
                    ),
                  ],
                ),
              ),
              Text(
                widget.appState.player!.name,
                style: Theme.of(context).textTheme.headline5,
              ),
              if (!_player.statsCanBeCalculated())
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "Nicht genügend Infos, spiele weiter!",
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: DesignColors.lightBlue),
                  ),
                )
              else
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Builder(builder: (context) {
                          return Flexible(
                            child: buildStatsWithRectangle(
                                val: _player.numGamesWon,
                                label: "Gewonnen",
                                color: DesignColors.green),
                          );
                        }),
                        Flexible(
                          child: buildStatsWithRectangle(
                              val: _player.numGamesTied,
                              label: "Gleichstand",
                              color: DesignColors.backgroundBlue),
                        ),
                        Flexible(
                          child: buildStatsWithRectangle(
                              val: _player.numPlayedGames -
                                  (_player.numGamesTied + _player.numGamesWon),
                              label: "Verloren",
                              color: DesignColors.red),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildLinearStatsBar(
                        max: (_player.trueCorrectAnswers +
                                _player.falseCorrectAnswers)
                            .toDouble(),
                        val: _player.trueCorrectAnswers.toDouble(),
                        label:
                            "Fakten: ${((_player.trueCorrectAnswers / (_player.trueCorrectAnswers + _player.falseCorrectAnswers)) * 100).round()}% erkannt"),
                    const SizedBox(
                      height: 10,
                    ),
                    buildLinearStatsBar(
                        max:
                            (_player.trueFakeAnswers + _player.falseFakeAnswers)
                                .toDouble(),
                        val: _player.trueFakeAnswers.toDouble(),
                        label:
                            "Fakes: ${((_player.trueFakeAnswers / (_player.trueFakeAnswers + _player.falseFakeAnswers)) * 100).round()}% erkannt"),
                    const SizedBox(
                      height: 10,
                    ),
                    buildLinearStatsBar(
                        max: (_player.numPlayedGames * 9).toDouble(),
                        val: (_player.trueCorrectAnswers +
                                _player.trueFakeAnswers)
                            .toDouble(),
                        label:
                            "Insgesamt: ${(((_player.trueCorrectAnswers + _player.trueFakeAnswers) / (_player.numPlayedGames * 9)) * 100).round()}% richtige Antworten"),
                    const SizedBox(height: 20),
                    SelectableText(
                      "Deine Statistiken werden nach jedem Spiel aktualisiert",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 16,
                          ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
