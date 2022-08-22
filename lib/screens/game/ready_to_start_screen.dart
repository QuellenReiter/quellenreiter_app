import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/bottom_sheets.dart';
import 'package:quellenreiter_app/widgets/results_app_bar.dart';

import '../../widgets/statement_card.dart';

class ReadyToStartScreen extends StatefulWidget {
  ReadyToStartScreen(
      {Key? key, required this.appState, this.showOnlyLast = true})
      : super(key: key);
  final QuellenreiterAppState appState;
  bool showOnlyLast;
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
    // TODO: Check if this is the best place to do this
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
      body: AnimationLimiter(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 800),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 30.0,
              curve: Curves.elasticOut,
              child: FadeInAnimation(
                child: widget,
              ),
            ),
            children: [
              RefreshIndicator(
                onRefresh: widget.appState.getFriends,
                child: ListView(
                  primary: false,
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    if (widget.appState.currentEnemy!.openGame!.gameFinished())
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
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
                      ),
                    // display the statementcards
                    if (statementCardsWithAnswers.isEmpty)
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            top: 200, left: 20, right: 20),
                        child: Text("Du hast noch keine Statements gespielt",
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
              ),
              if (widget.appState.currentEnemy == null ||
                  widget.appState.currentEnemy!.openGame == null)
                const Text("Fehler.")
              //if both players accessed the points
              else if (widget.appState.currentEnemy!.openGame!.pointsAccessed)
                SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.pink,
                    label: Text("Neues spiel starten",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Colors.white)),
                    onPressed: () => BottomSheets.showStartGameBottomSheet(
                        context,
                        widget.appState,
                        widget.appState.currentEnemy!),
                  ),
                )
              //if only one player accessed the points adn this is the player which did not end the game
              else if ((widget.appState.currentEnemy!.openGame!
                              .requestingPlayerIndex !=
                          widget.appState.currentEnemy!.openGame!.playerIndex &&
                      widget.appState.currentEnemy!.openGame!.gameFinished()) &&
                  !widget.appState.currentEnemy!.openGame!.pointsAccessed)
                SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                      backgroundColor: DesignColors.pink,
                      label: Text("Punkte abholen",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white)),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        widget.appState.route = Routes.gameFinishedScreen;
                      }),
                )
              else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
                // if not played any quests
                if (widget
                    .appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
                  SafeArea(
                    minimum: const EdgeInsets.only(bottom: 20),
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
                    minimum: const EdgeInsets.only(bottom: 20),
                    child: FloatingActionButton.extended(
                      backgroundColor: DesignColors.pink,
                      label: Text("Weiter spielen",
                          style: Theme.of(context).textTheme.headline4),
                      onPressed: () => {widget.appState.playGame()},
                    ),
                  )
              // if game is finished and player wait for other to access points
              else if (widget.appState.currentEnemy!.openGame!.gameFinished() &&
                  widget.appState.currentEnemy!.openGame!
                          .requestingPlayerIndex ==
                      widget.appState.currentEnemy!.openGame!.playerIndex)
                SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.lightGrey,
                    label: Text("Warten...",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: DesignColors.pink)),
                    onPressed: null,
                  ),
                )
              // if game is finished and player can access its points
              else if (widget.appState.currentEnemy!.openGame!.gameFinished() &&
                  widget.appState.currentEnemy!.openGame!
                          .requestingPlayerIndex !=
                      widget.appState.currentEnemy!.openGame!.playerIndex)
                SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.lightGrey,
                    label: Text("Warten...",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: DesignColors.pink)),
                    onPressed: null,
                  ),
                )
              else
                SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: DesignColors.lightGrey,
                    label: Text("Warten...",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: DesignColors.pink)),
                    onPressed: null,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
