import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/results_app_bar.dart';

import '../../widgets/statement_card.dart';

class ReadyToStartScreen extends StatefulWidget {
  const ReadyToStartScreen(
      {Key? key, required this.appState, this.showOnlyLast = false})
      : super(key: key);
  final QuellenreiterAppState appState;
  final bool showOnlyLast;
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
                    const CircleAvatar(
                      backgroundColor: DesignColors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  else
                    const CircleAvatar(
                      backgroundColor: DesignColors.red,
                      child: Icon(
                        Icons.not_interested,
                        color: Colors.white,
                      ),
                    ),
                  if (commonLength <= i)
                    const CircleAvatar(
                      backgroundColor: DesignColors.lightGrey,
                      child: Icon(Icons.watch_later_outlined),
                    )
                  else if (widget
                          .appState.currentEnemy!.openGame!.enemyAnswers[i] ==
                      true)
                    const CircleAvatar(
                      backgroundColor: DesignColors.green,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  else
                    const CircleAvatar(
                      backgroundColor: DesignColors.red,
                      child: Icon(
                        Icons.not_interested,
                        color: Colors.white,
                      ),
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
      appBar: ResultsAppBar(
        appState: widget.appState,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10),
            children: [
              if (widget.appState.currentEnemy!.openGame!.gameFinished())
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.appState.currentEnemy!.openGame!
                            .getGameResult() ==
                        GameResult.playerWon)
                      Text("Gewonnen",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: DesignColors.green))
                    else if (widget.appState.currentEnemy!.openGame!
                            .getGameResult() ==
                        GameResult.tied)
                      Text("Unentschieden",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: DesignColors.green))
                    else
                      Text("Verloren",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: DesignColors.red)),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "+",
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: DesignColors.yellow),
                          ),
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
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: DesignColors.yellow),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              // display the statementcards
              if (statementCardsWithAnswers.isEmpty)
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 200, left: 20, right: 20),
                  child: Text("Du hast noch keine Statements gespielt.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline1!
                          .copyWith(color: DesignColors.lightBlue)),
                ))
              else if (statementCardsWithAnswers.isNotEmpty)
                ExpansionTile(
                  initiallyExpanded: !widget.showOnlyLast ||
                      (widget.showOnlyLast &&
                          statementCardsWithAnswers.length < 4),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "1. Runde",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  children: statementCardsWithAnswers.sublist(
                      0, min(3, statementCardsWithAnswers.length)),
                ),
              if (statementCardsWithAnswers.length > 3)
                ExpansionTile(
                  initiallyExpanded: !widget.showOnlyLast ||
                      (widget.showOnlyLast &&
                          statementCardsWithAnswers.length < 7),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "2. Runde",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  children: statementCardsWithAnswers.sublist(
                      3, min(6, statementCardsWithAnswers.length)),
                ),
              if (statementCardsWithAnswers.length > 6)
                ExpansionTile(
                  initiallyExpanded: !widget.showOnlyLast ||
                      (widget.showOnlyLast &&
                          6 < statementCardsWithAnswers.length),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "3. Runde",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  children: statementCardsWithAnswers.sublist(
                      6, statementCardsWithAnswers.length),
                ),
              // if error
            ],
          ),
          if (widget.appState.currentEnemy == null ||
              widget.appState.currentEnemy!.openGame == null)
            const Text("Fehler.")
          //if is players turn
          else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
            // if not played any quests
            if (widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
              SafeArea(
                child: FloatingActionButton.extended(
                  backgroundColor: DesignColors.pink,
                  label: Text("Spielen",
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: () => {widget.appState.playGame()},
                ),
              )
            // if already played in this game
            else
              SafeArea(
                child: FloatingActionButton.extended(
                  backgroundColor: DesignColors.pink,
                  label: Text("Weiter spielen",
                      style: Theme.of(context).textTheme.headline4),
                  onPressed: () => {widget.appState.playGame()},
                ),
              )
          else if (widget.appState.currentEnemy!.openGame!.gameFinished() &&
              widget.appState.currentEnemy!.openGame!.requestingPlayerIndex ==
                  widget.appState.currentEnemy!.openGame!.playerIndex)
            SafeArea(
              child: FloatingActionButton.extended(
                backgroundColor: DesignColors.lightGrey,
                label: Text("Warten...",
                    style: Theme.of(context).textTheme.headline4),
                onPressed: null,
              ),
            )
          else
            SafeArea(
              child: FloatingActionButton.extended(
                backgroundColor: DesignColors.lightGrey,
                label: Text("Warten...",
                    style: Theme.of(context).textTheme.headline4),
                onPressed: null,
              ),
            ),
        ],
      ),
    );
  }
}
