import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/main_app_bar.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
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
  int animationLength = 40000;

  @override
  void initState() {
    timerController = TimerController(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });
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
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // image
                Expanded(
                  flex: 8,
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    elevation: 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.memoryNetwork(
                          fadeInDuration: const Duration(milliseconds: 200),
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
                              ? widget
                                  .appState
                                  .currentEnemy!
                                  .openGame!
                                  .statements!
                                  .statements[statementIndex]
                                  .statementPictureURL!
                                  .replaceAll(
                                      "https%3A%2F%2Fparsefiles.back4app.com%2FFeP6gb7k9R2K9OztjKWA1DgYhubqhW0yJMyrHbxH%2F",
                                      "")
                              : "https://quellenreiter.app/assets/logo-pink.png",
                        ),
                      ),
                    ),
                  ),
                ),
                // text
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  alignment: Alignment.topLeft,
                  clipBehavior: Clip.none,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: DesignColors.lightGrey,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.1,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                elevation: 10.0,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: DesignColors.backgroundBlue,
                                  ),
                                  child: Text(
                                      widget
                                          .appState
                                          .currentEnemy!
                                          .openGame!
                                          .statements!
                                          .statements[statementIndex]
                                          .statementText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Display more information.
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(widget
                                    .appState
                                    .currentEnemy!
                                    .openGame!
                                    .statements!
                                    .statements[statementIndex]
                                    .statementAuthor),
                              ),
                            ],
                          ),
                          // Media and Mediatype
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.newspaper),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(widget
                                        .appState
                                        .currentEnemy!
                                        .openGame!
                                        .statements!
                                        .statements[statementIndex]
                                        .statementMedia +
                                    ' | ' +
                                    widget
                                        .appState
                                        .currentEnemy!
                                        .openGame!
                                        .statements!
                                        .statements[statementIndex]
                                        .statementMediatype),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: SelectableText(widget
                                    .appState
                                    .currentEnemy!
                                    .openGame!
                                    .statements!
                                    .statements[statementIndex]
                                    .dateAsString()),
                              ),
                            ],
                          ),
                          // Language
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.language),
                              Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: SelectableText(widget
                                    .appState
                                    .currentEnemy!
                                    .openGame!
                                    .statements!
                                    .statements[statementIndex]
                                    .statementLanguage),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
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
                            child: Text("Fake",
                                style: Theme.of(context).textTheme.headline4),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: DesignColors.green,
                              minimumSize: Size(100, 70),
                            ),
                            onPressed: () =>
                                registerAnswer(statementIndex, true),
                            child: Text(
                              "Fakt",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Timer
                if (widget.appState.currentEnemy!.openGame!.withTimer)
                  SfLinearGauge(
                    minimum: 0,
                    maximum: 1,
                    animateAxis: true,
                    axisTrackStyle: const LinearAxisTrackStyle(
                      thickness: 20,
                      edgeStyle: LinearEdgeStyle.bothCurve,
                    ),
                    showTicks: false,
                    showLabels: false,
                    barPointers: [
                      LinearBarPointer(
                        enableAnimation: true,
                        animationDuration: animationLength,
                        edgeStyle: LinearEdgeStyle.bothCurve,
                        thickness: 20,
                        value: 1,
                        color: DesignColors.pink,
                        onAnimationCompleted: () => registerAnswer(
                            statementIndex, false,
                            timeOver: true),
                      )
                    ],
                  ),
              ],
            ),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: answerCorrect ? DesignColors.green : DesignColors.red,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      answerCorrect ? "Richtige Antwort" : "Falsche Antwort",
                      style: Theme.of(context).textTheme.headline3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Denn: ",
                    style: Theme.of(context).textTheme.headline4),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    widget
                                .appState
                                .currentEnemy!
                                .openGame!
                                .statements!
                                .statements[statementIndex]
                                .statementCorrectness ==
                            CorrectnessCategory.correct
                        ? "Diese Aussage ist ein Fakt"
                        : "Diese Aussage ist ein Fake",
                    style: Theme.of(context).textTheme.headline4),
              ),
            ],
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

    // // restart timer
    // if (widget.appState.currentEnemy!.openGame!.withTimer) {
    //   timerController.restart();
    // }
    Navigator.of(context).pop();
    setState(() {
      animationLength = 40000;
    });
    HapticFeedback.mediumImpact();
  }
}
