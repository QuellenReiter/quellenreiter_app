import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:transparent_image/transparent_image.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen>
    with SingleTickerProviderStateMixin {
  late TimerController timerController;

  @override
  void initState() {
    timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set index of statement to be shown
    int statementIndex =
        widget.appState.currentEnemy!.openGame!.playerAnswers.length;
    // set answer to false, incase user breaks the round.
    // But only if withTimer. Else doing research and closing the app is welcome.
    if (widget.appState.currentEnemy!.openGame!.withTimer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers.add(false);
      // Start timer when build is finished.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => timerController.start());
    }
    // show error if statements not downloaded.
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
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: SimpleTimer(
                    controller: timerController,
                    duration: const Duration(seconds: 40),
                    onEnd: () =>
                        registerAnswer(statementIndex, false, timeOver: true),
                    timerStyle: TimerStyle.ring,
                  ),
                ),
              // image
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.memoryNetwork(
                      fadeInDuration: const Duration(milliseconds: 400),
                      fadeInCurve: Curves.easeInOut,
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image: widget
                                  .appState
                                  .currentEnemy!
                                  .openGame!
                                  .statements!
                                  .statements[statementIndex]
                                  .statementPictureURL !=
                              null
                          ? widget.appState.currentEnemy!.openGame!.statements!
                              .statements[statementIndex].statementPictureURL!
                              .replaceAll(
                                  "https%3A%2F%2Fparsefiles.back4app.com%2FFeP6gb7k9R2K9OztjKWA1DgYhubqhW0yJMyrHbxH%2F",
                                  "")
                          : "https://quellenreiter.app/assets/logo-pink.png",
                    ),
                  ),
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
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: DesignColors.red,
                        ),
                        onPressed: () => registerAnswer(statementIndex, false),
                        child: const Text("Fake"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: DesignColors.green,
                        ),
                        onPressed: () => registerAnswer(statementIndex, true),
                        child: const Text("Fakt"),
                      ),
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
    timerController.reset();

    // PROBLEM: This is still not completely safe.
    // some other player could update the players stats between the above call
    // and the below update and will then be lost.
    // add false as a placeHolder if not with timer.
    if (!widget.appState.currentEnemy!.openGame!.withTimer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers.add(false);
    }
    // if time is over (only if with timer)
    if (timeOver) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          false;
      // if statemetn and answer are true.
    } else if (widget.appState.currentEnemy!.openGame!.statements!
                .statements[statementIndex].statementCorrectness ==
            CorrectnessCategory.correct &&
        answer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          true;
    }
    // if statement and answer are fake.
    else if (widget.appState.currentEnemy!.openGame!.statements!
                .statements[statementIndex].statementCorrectness !=
            CorrectnessCategory.correct &&
        !answer) {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          true;
    }
    // else answer is false.
    else {
      widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex] =
          false;
    }
    HapticFeedback.heavyImpact();

    var answerCorrect =
        widget.appState.currentEnemy!.openGame!.playerAnswers[statementIndex];

    // if game is not finished
    if (!widget.appState.currentEnemy!.openGame!.gameFinished()) {
      // show some inbetween screen
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: answerCorrect ? DesignColors.green : DesignColors.red,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  answerCorrect ? "Richtige Antwort" : "Falsche Antwort",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
          ),
        ),
      );
    }
    // if game is finished
    else if (widget.appState.currentEnemy!.openGame!.gameFinished()) {
      var playerWon = widget.appState.currentEnemy!.openGame!.playerAnswers
              .fold<int>(0, (p, e) => p + (e ? 1 : 0)) >
          widget.appState.currentEnemy!.openGame!.enemyAnswers
              .fold<int>(0, (p, e) => p + (e ? 1 : 0));

      var enemyWon = widget.appState.currentEnemy!.openGame!.playerAnswers
              .fold<int>(0, (p, e) => p + (e ? 1 : 0)) <
          widget.appState.currentEnemy!.openGame!.enemyAnswers
              .fold<int>(0, (p, e) => p + (e ? 1 : 0));
      // show some inbetween screen
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          insetPadding: const EdgeInsets.all(0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(100),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: answerCorrect ? DesignColors.green : DesignColors.red,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    answerCorrect ? "Richtige Antwort" : "Falsche Antwort",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ),
            ),
            Text(
              playerWon
                  ? "DU HAST GEWONNEN"
                  : enemyWon
                      ? "Du hast verloren."
                      : "unentschieden",
              style: Theme.of(context).textTheme.headline4,
            ),
          ]),
        ),
      );

      // update the player so we dont miss any updates made by other player/games.
      await widget.appState.db.checkToken((p) {
        if (p != null) {
          widget.appState.player = p;
          widget.appState.error = null;
          return;
        } else {
          widget.appState.error = "Spieler nicht up to date.";
          return;
        }
      });
      // if update not working, break!
      if (widget.appState.error != null) {
        return;
      }
      if (playerWon) {
        // player has won
        widget.appState.currentEnemy!.wonGamesPlayer += 1;
        // update player
        widget.appState.player!.numGamesWon += 1;
        widget.appState.player!.numPlayedGames += 1;
        widget.appState.player!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
        // update enemy
        widget.appState.currentEnemy!.numGamesPlayedOther += 1;
        widget.appState.currentEnemy!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.enemyAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
      } else if (enemyWon) {
        // enemy has won
        widget.appState.currentEnemy!.wonGamesOther += 1;
        // update player
        widget.appState.player!.numPlayedGames += 1;
        widget.appState.player!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
        // update enemy
        widget.appState.currentEnemy!.numGamesPlayedOther += 1;
        widget.appState.currentEnemy!.numGamesWonOther += 1;
        widget.appState.currentEnemy!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
      } else {
        // Game endet in a Tie
        // update player
        widget.appState.player!.numPlayedGames += 1;
        widget.appState.player!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.playerAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
        // update enemy
        widget.appState.currentEnemy!.numGamesPlayedOther += 1;
        widget.appState.currentEnemy!.updateAnswerStats(
            widget.appState.currentEnemy!.openGame!.enemyAnswers,
            widget.appState.currentEnemy!.openGame!.statements);
      }
      // increase played games of friendship
      widget.appState.currentEnemy!.numGamesPlayed += 1;
    }
    // delay 3 seconds
    await Future.delayed(const Duration(seconds: 3), () {});
    // push to DB
    await widget.appState.db.updateGame(widget.appState);

    // restart timer
    if (widget.appState.currentEnemy!.openGame!.withTimer) {
      timerController.restart();
    }
    Navigator.of(context).pop();
    widget.appState.route = Routes.quest;
    HapticFeedback.mediumImpact();
  }
}
