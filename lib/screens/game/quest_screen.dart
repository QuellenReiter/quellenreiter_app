import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/models/statement.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:transparent_image/transparent_image.dart';

class QuestScreen extends StatefulWidget {
  QuestScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  bool answerRegistered = false;
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

    Game currentGame = widget.appState.currentOpponent!.openGame!;

    // set index of statement to be shown
    int statementIndex = currentGame.player.amountAnswered;

    // show loading if statements not downloaded.
    if (currentGame.statements == null) {
      widget.appState.getCurrentStatements();
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // set answer to false, in case user breaks the round.
    // But only if withTimer. Else doing research and closing the app is welcome.
    if (currentGame.withTimer) {
      currentGame.player.answers.add(false);
    }

    Statement currentStatement =
        currentGame.statements!.statements[statementIndex];
    String? pictureURL = currentStatement.statementPictureURL;

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
                              image: pictureURL != null
                                  ? pictureURL.replaceAll(
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
                                              currentStatement.statementText,
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
                                          child: Text(
                                              currentStatement.statementAuthor),
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
                                          child: Text(
                                              currentStatement.statementMedia +
                                                  ' | ' +
                                                  currentStatement
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
                                          child: SelectableText(
                                              currentStatement.dateAsString()),
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
                                          child: SelectableText(currentStatement
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
                        if (currentGame.withTimer)
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
                                onAnimationCompleted: () {
                                  if (!widget.answerRegistered) {
                                    registerAnswer(statementIndex, false,
                                        timeOver: true);
                                  }
                                },
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
    widget.answerRegistered = true;

    Game currentGame = widget.appState.currentOpponent!.openGame!;

    // PROBLEM: This is still not completely safe.
    // some other player could update the players stats between the above call
    // and the below update and will then be lost.
    // add false as a placeHolder if not with timer.
    // if time is over (only if with timer)
    if (timeOver) {
      widget.appState.currentOpponent!.openGame!.player
          .answers[statementIndex] = false;
      // if statemetn and answer are true.
    } else if (widget.appState.currentOpponent!.openGame!.statements!
                .statements[statementIndex].statementCorrectness ==
            CorrectnessCategory.correct &&
        answer) {
      widget.appState.currentOpponent!.openGame!.player
          .answers[statementIndex] = true;
    }
    // if statement and answer are fake.
    else if (widget.appState.currentOpponent!.openGame!.statements!
                .statements[statementIndex].statementCorrectness !=
            CorrectnessCategory.correct &&
        !answer) {
      widget.appState.currentOpponent!.openGame!.player
          .answers[statementIndex] = true;
    }
    // else answer is false.
    else {
      widget.appState.currentOpponent!.openGame!.player
          .answers[statementIndex] = false;
    }
    if (!currentGame.withTimer) {
      currentGame.player.answers.add(false);
    }
    HapticFeedback.heavyImpact();

    var answerCorrect = widget
        .appState.currentOpponent!.openGame!.player.answers[statementIndex];

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
    if (currentGame.gameFinished()) {
      // notify friend that points can be accessed
      widget.appState.db.sendPushOtherGameFinished(widget.appState,
          receiverId: widget.appState.currentOpponent!.userId);
      // show game finished screen
      widget.appState.route = Routes.gameFinishedScreen;
      return;
    } // if game is finished

    //if its not players turn anymore, getFriends.
    if (!currentGame.isPlayersTurn()) {
      await widget.appState.getFriends();
      // send notification to friend.
      widget.appState.db.sendPushOtherPlayersTurn(widget.appState,
          receiverId: widget.appState.currentOpponent!.userId);
      // got toready to start show only last
      widget.appState.route = Routes.readyToStartOnlyLastScreen;
      return;
    } else {
      widget.appState.route = Routes.loading;
      // wait for half asecond
      await Future.delayed(const Duration(milliseconds: 500), () {});
    }

    HapticFeedback.heavyImpact();
    // go to game finished screen or to the next quest
    if (currentGame.gameFinished()) {
      widget.appState.route = Routes.gameFinishedScreen;
    } else {
      widget.appState.route = Routes.quest;
    }
  }
}
