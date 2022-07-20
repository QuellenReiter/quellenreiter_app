import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
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
  int animationLength = 40000;

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
    }
    // show error if statements not downloaded.
    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      widget.appState.getCurrentStatements();
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
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
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          elevation: 10.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: FadeInImage.memoryNetwork(
                              fadeInDuration: const Duration(milliseconds: 200),
                              fadeInCurve: Curves.easeInOut,
                              // fit: BoxFit.,
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
                    ],
                  ),
                ),
                // text
                AnimationLimiter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 1000),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 100.0,
                        curve: Curves.elasticOut,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 10),
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
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
                                widthFactor:
                                    MediaQuery.of(context).size.aspectRatio >
                                            (9 / 16)
                                        ? 1.06
                                        : 1.1,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 10.0,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Wrap(
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
                                          padding:
                                              const EdgeInsets.only(left: 3),
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
                                          padding:
                                              const EdgeInsets.only(left: 3),
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
                                          padding:
                                              const EdgeInsets.only(left: 3),
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
                                          padding:
                                              const EdgeInsets.only(left: 3),
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
                                ),
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4),
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
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                            ],
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
                                animationType: LinearAnimationType.linear,
                                enableAnimation: true,
                                animationDuration: animationLength,
                                edgeStyle: LinearEdgeStyle.bothCurve,
                                thickness: 20,
                                value: animationLength.toDouble(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void registerAnswer(int statementIndex, bool answer,
      {bool timeOver = false}) async {
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
      useSafeArea: false,
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: answerCorrect ? DesignColors.green : DesignColors.red,
        insetPadding: const EdgeInsets.all(0),
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 1000),
              childAnimationBuilder: (widget) => SlideAnimation(
                horizontalOffset: 100.0,
                verticalOffset: 100,
                curve: Curves.elasticOut,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 70,
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DesignColors.lightBlue,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            answerCorrect
                                ? "Richtige\nAntwort"
                                : "Falsche\nAntwort",
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color: answerCorrect
                                        ? DesignColors.green
                                        : DesignColors.red,
                                    fontSize: 60),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      answerCorrect ? "🎉" : "🙅",
                      style: const TextStyle(fontSize: 100),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: DesignColors.yellow,
                      size: 30,
                    ),
                    Text(
                      answerCorrect ? "+12" : "+0",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: DesignColors.yellow),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );

    // delay 3 seconds
    await Future.delayed(const Duration(seconds: 2), () {});

    // push to DB
    await widget.appState.db.updateGame(widget.appState);

    // if game is finished
    if (widget.appState.currentEnemy!.openGame!.gameFinished()) {
      // show game finished screen
      widget.appState.route = Routes.gameFinishedScreen;
      return;
    } // if game is finished

    widget.appState.route = Routes.loading;
    await HapticFeedback.heavyImpact().then((value) async =>
        await Future.delayed(const Duration(milliseconds: 500), () {}));
    widget.appState.route = Routes.quest;
  }
}
