import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  double timerValue = 0;

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

    startTimer(statementIndex);
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
                LinearProgressIndicator(
                  minHeight: 5,
                  value: timerValue,
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
                      onPressed: () {},
                      child: Text("Fake"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
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

  void startTimer(int statementIndex) {
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (timerValue >= 1) {
          // timer is over, break round.
          timer.cancel();
          widget.appState.currentEnemy!.openGame!
              .playerAnswers[statementIndex] = false;
          // show in between screen with result
        } else {
          timerValue = timerValue + 0.05;
          // OTHERWISE THIS TRIGGERS A REBUILD.... AND THUS SWITCHES TO NEW STATEMENT.
          widget.appState.currentEnemy!.openGame!.playerAnswers.removeLast();
        }
      });
    });
  }

  void registerAnswer(int statementIndex, bool answer,
      {bool timeOver = false}) async {
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
    }
    // show some inbetween screen
  }
}
