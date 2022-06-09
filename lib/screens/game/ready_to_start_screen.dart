import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/start_game_button.dart';

import '../../widgets/error_banner.dart';

class ReadyToStartScreen extends StatefulWidget {
  const ReadyToStartScreen({Key? key, required this.appState})
      : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<ReadyToStartScreen> createState() => _ReadyToStartScreenState();
}

class _ReadyToStartScreenState extends State<ReadyToStartScreen> {
  var greyCircle = const Padding(
    padding: EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundColor: DesignColors.black,
    ),
  );
  List<Widget> enemyAnswerVisuals = [];
  List<Widget> playerAnswerVisuals = [];
  int commonLength = 0;

  @override
  void initState() {
    commonLength = min(
        widget.appState.currentEnemy!.openGame!.playerAnswers.length,
        widget.appState.currentEnemy!.openGame!.enemyAnswers.length);

    enemyAnswerVisuals.addAll([
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle
    ]);
    playerAnswerVisuals.addAll([
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle
    ]);
    for (int i = 0;
        i < widget.appState.currentEnemy!.openGame!.playerAnswers.length;
        i++) {
      playerAnswerVisuals[i] = Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          foregroundColor: DesignColors.pink,
          backgroundColor:
              widget.appState.currentEnemy!.openGame!.playerAnswers[i] == true
                  ? DesignColors.green
                  : DesignColors.red,
        ),
      );

      if (i > commonLength - 1) {
        continue;
      }
      enemyAnswerVisuals[i] = Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: widget.appState.currentEnemy!.openGame!.enemyAnswers
                      .sublist(0, commonLength)[i] ==
                  true
              ? DesignColors.green
              : DesignColors.red,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: widget.appState.db.error != null
          ? ErrorBanner(appState: widget.appState)
          : null,
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
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.appState.currentEnemy!.openGame!.gameFinished())
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.appState.currentEnemy!.openGame!.getGameResult() ==
                      GameResult.playerWon)
                    Text("Gewonnen",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: DesignColors.green))
                  else if (widget.appState.currentEnemy!.openGame!
                          .getGameResult() ==
                      GameResult.tied)
                    Text("Unentschieden",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: DesignColors.green))
                  else
                    Text("Verloren",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: DesignColors.red)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("+ "),
                      const Icon(
                        Icons.monetization_on,
                        color: DesignColors.yellow,
                        size: 24,
                      ),
                      Countup(
                        begin: 0,
                        end: widget.appState.currentEnemy!.openGame!
                            .getPlayerXp()
                            .toDouble(),
                        duration: const Duration(seconds: 1),
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ],
              ),

            // user and enemy
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.appState.player!.emoji,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          widget.appState.player!.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          widget.appState.currentEnemy!.openGame!.playerAnswers
                                  .fold<int>(0, (p, c) => p + (c ? 1 : 0))
                                  .toString() +
                              " Punkte",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: GridView.count(
                                clipBehavior: Clip.none,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                children: playerAnswerVisuals),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.appState.currentEnemy!.emoji,
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Text(
                          widget.appState.currentEnemy!.name,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                        Text(
                          widget.appState.currentEnemy!.openGame!.enemyAnswers
                                  .sublist(0, commonLength)
                                  .fold<int>(0, (p, c) => p + (c ? 1 : 0))
                                  .toString() +
                              " Punkte",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GridView.count(
                              clipBehavior: Clip.none,
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: enemyAnswerVisuals,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed:
                  widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty
                      ? null
                      : () => widget.appState.route = Routes.gameResults,
              icon: const Icon(Icons.fact_check),
              label: const Text("zu den Faktenchecks"),
            ),
            // Bottom button:
            // if error
            if (widget.appState.currentEnemy == null ||
                widget.appState.currentEnemy!.openGame == null)
              const Text("Fehler.")
            //if is players turn
            else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
              // if not played any quests
              if (widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Spielen"),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                )
              // if already played in this game
              else
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Weiter spielen"),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                )
            else if (widget.appState.currentEnemy!.openGame!.gameFinished() &&
                widget.appState.currentEnemy!.openGame!.requestingPlayerIndex ==
                    widget.appState.currentEnemy!.openGame!.playerIndex)
              Flexible(
                child: ElevatedButton(
                  child: Text(
                      "Warte bis ${widget.appState.currentEnemy!.name} die Punkte geholt hat."),
                  onPressed: null,
                ),
              )
            else if (widget.appState.currentEnemy!.openGame!.gameFinished())
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Das spiel ist beendet."),
                  Flexible(
                    child: StartGameButton(
                      appState: widget.appState,
                      enemy: widget.appState.currentEnemy!,
                    ),
                  )
                ],
              )
            else
              Flexible(
                child: ElevatedButton(
                  child: Text(
                      "Warten, bis ${widget.appState.currentEnemy!.name} gespielt hat."),
                  onPressed: null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
