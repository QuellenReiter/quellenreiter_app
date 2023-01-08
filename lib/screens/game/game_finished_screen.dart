import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
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
  final ValueNotifier<int> _tempPlayerXp = ValueNotifier(0);
  int _countupStartValue = 0;
  late final int _newLevel;
  late GameResult _result;
  bool _pointButtonTapped = false;

  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });

    Game currentGame = widget.appState.focusedPlayerRelation!.openGame!;
    _result = currentGame.getGameResult();

    _tempPlayerXp.value = currentGame.getPlayerXp();

    String finalText = "";
    String finalEmoji = "";
    switch (_result) {
      case GameResult.playerWon:
        finalText = "Du hast\ngewonnen";
        finalEmoji = "🏆";
        break;
      case GameResult.opponentWon:
        finalText = "Du hast\nverloren";
        finalEmoji = "🤦";
        break;
      case GameResult.tied:
        finalText = "Unentschieden";
        finalEmoji = "🪢";
        break;
    }

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
                    resultBarStack(),
                    gameResultInfo(finalText, finalEmoji),
                    const SizedBox(height: 0),
                    Column(children: [
                      earnablePointsRow(),
                      const SizedBox(height: 20),
                      earnPointsButton()
                    ]),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Row earnablePointsRow() {
    return Row(
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
            valueListenable: _tempPlayerXp,
            builder: (BuildContext context, val, child) {
              return Countup(
                begin: _countupStartValue.toDouble(),
                end: val.toDouble(),
                duration: const Duration(seconds: 1),
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(color: DesignColors.yellow),
              );
            },
          ),
        ]);
  }

  dynamic earnPointsButton() {
    if (!_pointButtonTapped) {
      return MirrorAnimation(
          duration: const Duration(milliseconds: 1000),
          tween: Tween<double>(
            begin: 1,
            end: 1.05,
          ),
          curve: Curves.elasticIn,
          builder: (context, child, double value) => ElevatedButton(
                onPressed: onTapGetPoints,
                child: Text(
                  "Punkte einsammeln",
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 35 * value),
                ),
              ));
    } else {
      return ElevatedButton(
          onPressed: null,
          child: Text(
            "Punkte eingesammelt",
            style:
                Theme.of(context).textTheme.headline1!.copyWith(fontSize: 35),
          ));
    }
  }

  PlayAnimation gameResultInfo(String finalText, String finalEmoji) {
    return PlayAnimation<double>(
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
                  finalText,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(color: DesignColors.pink, fontSize: 60 * value),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Text(
            finalEmoji,
            style: TextStyle(fontSize: 100 * value),
          ),
          Positioned(
            top: 30,
            child: newLevelIndicator(),
          )
        ],
      ),
    );
  }

  ValueListenableBuilder<int> resultBarStack() {
    return ValueListenableBuilder<int>(
        valueListenable: _tempPlayerXp,
        builder: (BuildContext context, val, child) {
          return Container(
            margin: const EdgeInsets.all(10),
            clipBehavior: Clip.none,
            padding: const EdgeInsets.all(10),
            height: AppBar().preferredSize.height * 1.5,
            // Set background color and rounded bottom corners.
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              color: DesignColors.backgroundBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
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
                    style: const TextStyle(fontSize: 50),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.appState.player!.name,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Stack(alignment: Alignment.center, children: [
                        SfLinearGauge(
                          minimum: GameRules.xpForCurrentLevel(
                                  widget.appState.player!.getXp() +
                                      _countupStartValue)
                              .toDouble(),
                          maximum: GameRules.xpForNextLevel(
                                  widget.appState.player!.getXp() +
                                      _countupStartValue)
                              .toDouble(),
                          animateAxis: true,
                          axisTrackStyle: const LinearAxisTrackStyle(
                            thickness: 20,
                            edgeStyle: LinearEdgeStyle.bothCurve,
                          ),
                          animateRange: true,
                          animationDuration:
                              _countupStartValue > 0 ? 1000 : 400,
                          showTicks: false,
                          showLabels: false,
                          barPointers: [
                            LinearBarPointer(
                              edgeStyle: LinearEdgeStyle.bothCurve,
                              thickness: 20,
                              value:
                                  widget.appState.player!.getXp().toDouble() +
                                      _countupStartValue,
                              color: DesignColors.pink,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AnimationLimiter(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 500),
                                childAnimationBuilder: (widget) =>
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
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    (widget.appState.player!.getXp() +
                                                _countupStartValue)
                                            .toString() +
                                        "/" +
                                        widget.appState.player!
                                            .getNextLevelXp()
                                            .toString() +
                                        " XP",
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Text(
                                    (widget.appState.player!.getLevel() + 1)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.headline5,
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
                // if player did not reach new Level.
                if (widget.appState.player!.getXp().toDouble() +
                        _countupStartValue <
                    widget.appState.player!.getNextLevelXp())
                  AnimationLimiter(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50.0,
                          curve: Curves.bounceOut,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          const Icon(
                            Icons.workspace_premium_rounded,
                            size: 40,
                            color: DesignColors.yellow,
                          ),
                          Text(
                            '${GameRules.currentLevel(widget.appState.player!.getXp())}',
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(color: DesignColors.yellow),
                          ),
                        ],
                      ),
                    ),
                  )
                // if player reached new Level.
                else
                  PlayAnimation(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(
                      begin: 1,
                      end: 1.5,
                    ),
                    curve: Curves.elasticOut,
                    builder: (context, child, double value) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 40 * value,
                          color: DesignColors.yellow,
                        ),
                        Text(
                          '${GameRules.currentLevel(widget.appState.player!.getXp() + _countupStartValue)}',
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
        });
  }

  ValueListenableBuilder<int> newLevelIndicator() {
    return ValueListenableBuilder<int>(
        valueListenable: _tempPlayerXp,
        builder: (BuildContext context, val, child) {
          if (widget.appState.player!.getXp().toDouble() + _countupStartValue <
              widget.appState.player!.getNextLevelXp()) {
            return const SizedBox.shrink();
          } else {
            HapticFeedback.heavyImpact();
            return PlayAnimation(
              duration: const Duration(milliseconds: 1000),
              tween: Tween<double>(
                begin: 2,
                end: 1,
              ),
              curve: Curves.elasticOut,
              builder: (context, child, double value) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LevelUp: ',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: DesignColors.yellow,
                        fontSize: 55 * value,
                        shadows: [
                          const Shadow(
                            color: DesignColors.black,
                            blurRadius: 15,
                            offset: Offset(
                              3,
                              3,
                            ),
                          ),
                        ]),
                  ),
                  Icon(Icons.workspace_premium_rounded,
                      size: 50 * value,
                      color: DesignColors.yellow,
                      shadows: const [
                        Shadow(
                          color: DesignColors.black,
                          blurRadius: 10,
                          offset: Offset(
                            3,
                            3,
                          ),
                        ),
                      ]),
                  Text(
                    '$_newLevel',
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                      color: DesignColors.yellow,
                      fontSize: 50 * value,
                      shadows: [
                        const Shadow(
                          color: DesignColors.black,
                          blurRadius: 10,
                          offset: Offset(
                            3,
                            3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  // called on tap of getCoins.
  void onTapGetPoints() async {
    _pointButtonTapped = true;
    _countupStartValue = _tempPlayerXp.value;
    _tempPlayerXp.value = 0;
    _newLevel = GameRules.currentLevel(
        widget.appState.player!.getXp() + _countupStartValue);

    // count down the xp
    // count up the players xp by amount.
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(seconds: 2), () {});
    HapticFeedback.mediumImpact();
    // updating all stats, takes a while.
    await widget.appState.db.checkToken((p) async {
      // if player is not null
      if (p != null) {
        // update current player
        widget.appState.player = p;
        widget.appState.msg = null;
      } else {
        widget.appState.msg = "Spieler nicht up to date.";
        // return to ready to start screen.
        widget.appState.route = Routes.gameReadyToStart;
        return;
      }

      Game currentGame = widget.appState.focusedPlayerRelation!.openGame!;
      Player currentPlayer = widget.appState.player!;

      if (_result == GameResult.playerWon) {
        // player has won, update player
        widget.appState.focusedPlayerRelation!.wonGamesPlayer += 1;
        currentPlayer.numGamesWon += 1;
      } else if (_result == GameResult.tied) {
        // Game endet in a tie, update player
        currentPlayer.numGamesTied += 1;
      }

      // if statements are not downloaded (especially if player
      // wants to get its points), download them.
      currentGame.statements ??=
          await widget.appState.db.getStatements(currentGame.statementIds!);

      currentPlayer.updateAnswerStats(
          currentGame.player.answers, currentGame.statements);
      currentPlayer.numPlayedGames += 1;

      // increase played games of friendship if playerIndex = 0
      if (currentGame.playerIndex == 0) {
        widget.appState.focusedPlayerRelation!.numGamesPlayed += 1;
      }
      // if the last player accessed the points
      if (currentGame.requestingPlayerIndex != currentGame.playerIndex) {
        // both player have accessed their points
        currentGame.pointsAccessed = true;
      }
      await widget.appState.db.updateGame(widget.appState);

      HapticFeedback.heavyImpact();

      widget.appState.route = Routes.gameReadyToStart;
      return;
    });
    HapticFeedback.heavyImpact();
    showGeneralDialog(
        transitionDuration: const Duration(milliseconds: 50),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()));
        });

    await widget.appState.getPlayerRelations();

    // update player

    // wait for 1 secons
    // pop the dialog and go to next screen.
    Navigator.of(context).pop();
    widget.appState.route = Routes.gameReadyToStart;
  }
}
