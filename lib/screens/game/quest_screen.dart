import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:simple_timer/simple_timer.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // set index of statement to be shown
    int statementIndex =
        widget.appState.currentEnemy!.openGame!.playerAnswers.length;
    // set answer to false, incase user breaks the round.
    // But only if withTimer. Else doing research and closing the app is welcome.
    if (widget.appState.currentEnemy!.openGame!.withTimer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers.add(false);
    }

    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      return const Scaffold(
        body: Text("Fehler"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Timer
              if (widget.appState.currentEnemy!.openGame!.withTimer)
                SimpleTimer(
                  // controller: _timerController
                  //   ..start(startFrom: const Duration(seconds: 30)),
                  status: TimerStatus.start,
                  duration: const Duration(seconds: 40),
                  onEnd: () =>
                      registerAnswer(statementIndex, false, timeOver: true),
                  timerStyle: TimerStyle.ring,
                ),
              // image
              Flexible(
                child: Image(
                  image: NetworkImage(widget
                      .appState
                      .currentEnemy!
                      .openGame!
                      .statements!
                      .statements[statementIndex]
                      .statementPictureURL!),
                ),
              ),
              // text
              Flexible(
                child: Text(widget.appState.currentEnemy!.openGame!.statements!
                    .statements[statementIndex].statementText),
              ),
              // detail
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    widget.appState.currentEnemy!.openGame!.statements!
                        .statements[statementIndex]
                        .dateAsString(),
                  ),
                  Text(
                    widget.appState.currentEnemy!.openGame!.statements!
                        .statements[statementIndex].statementMedia,
                  ),
                ],
              ),
              //buttons

              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => registerAnswer(statementIndex, false),
                      child: Text("Fake"),
                    ),
                    ElevatedButton(
                      onPressed: () => registerAnswer(statementIndex, true),
                      child: Text("Fakt"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void registerAnswer(int statementIndex, bool answer,
      {bool timeOver = false}) async {
    widget.appState.route = Routes.loading;
    if (timeOver) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          false;
    } else if (widget.appState.currentEnemy!.openGame!.statements!
                .statements[statementIndex].statementCorrectness ==
            CorrectnessCategory.correct &&
        answer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          true;
    } else if (widget.appState.currentEnemy!.openGame!.statements!
                .statements[statementIndex].statementCorrectness !=
            CorrectnessCategory.correct &&
        !answer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          true;
    } else {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          false;
    }
    // push to DB
    await widget.appState.db.updateGame(widget.appState.currentEnemy!);
    // if its the end of the round (after 3 statements)
    if ([2, 5, 8].contains(statementIndex)) {
      //return to readyToStartGameScreen
      widget.appState.route = Routes.gameReadyToStart;
    } else {
      widget.appState.route = Routes.quest;
    }
    // show some inbetween screen
  }
}
