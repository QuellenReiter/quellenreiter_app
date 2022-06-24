import 'dart:html';
import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/models/statement.dart';
import 'package:quellenreiter_app/widgets/start_game_button.dart';

import '../../widgets/error_banner.dart';
import '../../widgets/statement_card.dart';

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
  List<Widget> statementCardsWithAnswers = [];
  int commonLength = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    statementCardsWithAnswers = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    commonLength = min(
        widget.appState.currentEnemy!.openGame!.playerAnswers.length,
        widget.appState.currentEnemy!.openGame!.enemyAnswers.length);

    // Check if statements are loaded. If not, load them.
    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      widget.appState.getCurrentStatements();
      return Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()));
    }
    // build the list of statementcards
    statementCardsWithAnswers = [];
    for (int i = 0;
        i < widget.appState.currentEnemy!.openGame!.playerAnswers.length;
        i++) {
      var tempStatement =
          widget.appState.currentEnemy!.openGame!.statements!.statements[i];
      statementCardsWithAnswers.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: StatementCard(
                  statement: tempStatement,
                  appState: widget.appState,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget
                          .appState.currentEnemy!.openGame!.playerAnswers[i] ==
                      true)
                    CircleAvatar(
                      backgroundColor: DesignColors.green,
                    )
                  else
                    CircleAvatar(
                      backgroundColor: DesignColors.red,
                    ),
                  if (commonLength <= i)
                    CircleAvatar(
                      backgroundColor: DesignColors.lightGrey,
                      child: Icon(Icons.watch_later_outlined),
                    )
                  else if (widget
                          .appState.currentEnemy!.openGame!.enemyAnswers[i] ==
                      true)
                    CircleAvatar(
                      backgroundColor: DesignColors.green,
                    )
                  else
                    CircleAvatar(
                      backgroundColor: DesignColors.red,
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielen"),
        actions: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                  ],
                ),
              ),
            ],
          ),
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
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.appState.currentEnemy!.openGame!.gameFinished())
            Flexible(
              child: Column(
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
                  Flexible(
                    child: Row(
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
                  ),
                ],
              ),
            ),
          // display the statementcards
          ...statementCardsWithAnswers,
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
            Flexible(
              child: Column(
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
              ),
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
    );
  }
}
