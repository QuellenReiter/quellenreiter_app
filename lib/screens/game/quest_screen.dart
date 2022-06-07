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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // image
              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
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
                child: Text(
                  widget.appState.currentEnemy!.openGame!.statements!
                      .statements[statementIndex].statementText,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: DesignColors.red,
                            minimumSize: Size(100, 70),
                          ),
                          onPressed: () =>
                              registerAnswer(statementIndex, false),
                          child: const Text("Fake"),
                        ),
                      ),
                      // Timer
                      if (widget.appState.currentEnemy!.openGame!.withTimer)
                        Expanded(
                          child: SimpleTimer(
                            controller: timerController,
                            duration: const Duration(seconds: 40),
                            onEnd: () => registerAnswer(statementIndex, false,
                                timeOver: true),
                            timerStyle: TimerStyle.expanding_sector,
                          ),
                        ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: DesignColors.green,
                            minimumSize: Size(100, 70),
                          ),
                          onPressed: () => registerAnswer(statementIndex, true),
                          child: const Text("Fakt"),
                        ),
                      ),
                    ],
                  ),
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
                  style: Theme.of(context).textTheme.headline3!),
            ),
          ),
        ),
      ),
    );

    // delay 3 seconds
    await Future.delayed(const Duration(seconds: 2), () {});

    // if game is finished
    if (widget.appState.currentEnemy!.openGame!.gameFinished()) {
      // show game finished screen
      widget.appState.route = Routes.gameFinishedScreen;
      return;
    } // if game is finished

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
