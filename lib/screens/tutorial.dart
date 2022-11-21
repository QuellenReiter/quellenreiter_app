import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/statement_card.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../constants/constants.dart';
import '../models/statement.dart';

class Tutorial extends StatefulWidget {
  const Tutorial({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  late TutorialCoachMark tutorialCoachMark;

  GlobalKey keyFaktFakeButton = GlobalKey();

  GlobalKey keyStatementText = GlobalKey();

  GlobalKey keyStatementInfo = GlobalKey();

  GlobalKey<StatementCardState> keyStatementCard =
      GlobalKey<StatementCardState>();

  GlobalKey keyStatementSaveAndShare = GlobalKey();

  // global key to call functions of the tutorial
  bool showStatametCardCalled = false;

  Statement? testStatement;

  /// valuelistenable for loading
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // start downloading the testStatement
    getTestStatement();
    return Scaffold(
      // appBar: MainAppBar(),
      body: SafeArea(
        child: AnimationLimiter(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 2000),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 100.0,
                  curve: Curves.elasticOut,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Column(
                    children: [
                      const Center(
                        child: Image(
                          height: 200,
                          image: AssetImage('assets/logo-pink.png'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('das "fake news" quiz',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: DesignColors.backgroundBlue)),
                    ],
                  ),

                  // const SizedBox(height: 100),
                  ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, bool value, child) {
                        if (value) {
                          return const ElevatedButton(
                            onPressed: null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: CircularProgressIndicator()),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              HapticFeedback.heavyImpact();
                              showTestQuest(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text("tutorial",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(fontSize: 40)),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showTestQuest(context) async {
    isLoading.value = true;
    // wait until testStatement is downloaded;
    while (testStatement == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    showGeneralDialog(
      context: context,
      pageBuilder: ((context, animation, secondaryAnimation) {
        return Material(
          child: Center(
            child: SafeArea(
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
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fadeInCurve: Curves.easeInOut,
                                  // fit: BoxFit.,
                                  placeholder: kTransparentImage,
                                  image: testStatement!.statementPictureURL !=
                                          null
                                      ? testStatement!.statementPictureURL!
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
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              alignment: Alignment.topLeft,
                              clipBehavior: Clip.none,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.lightGrey,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FractionallySizedBox(
                                    widthFactor: MediaQuery.of(context)
                                                .size
                                                .aspectRatio >
                                            (9 / 16)
                                        ? 1.06
                                        : 1.1,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            elevation: 10.0,
                                            child: Container(
                                              key: keyStatementText,
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color:
                                                    DesignColors.backgroundBlue,
                                              ),
                                              child: Text(
                                                  testStatement!.statementText,
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
                                      key: keyStatementInfo,
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
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(testStatement!
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
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(testStatement!
                                                      .statementMedia +
                                                  ' | ' +
                                                  testStatement!
                                                      .statementMediatype),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.calendar_month),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(testStatement!
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
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(testStatement!
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
                                key: keyFaktFakeButton,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: DesignColors.red,
                                        minimumSize: const Size(100, 70),
                                      ),
                                      onPressed: () =>
                                          registerAnswer(false, context),
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
                                        backgroundColor: DesignColors.green,
                                        minimumSize: const Size(100, 70),
                                      ),
                                      onPressed: () =>
                                          registerAnswer(true, context),
                                      child: Text(
                                        "Fakt",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
      }),
    );

    var targets = [
      TargetFocus(
        identify: "keyStatementText",
        keyTarget: keyStatementText,
        alignSkip: Alignment.topLeft,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: true,
        radius: 10,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(20),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Schau dir die",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: " Aussage ",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        ),
                        TextSpan(
                          text: "an",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  actionButton(
                      "weiter", (context) => tutorialCoachMark.next(), context,
                      animate: true)
                ],
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "keyStatementInfo",
        keyTarget: keyStatementInfo,
        alignSkip: Alignment.topLeft,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: true,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Hier findest du noch",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: " mehr Infos ",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        ),
                        TextSpan(
                          text: "dazu",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  actionButton(
                      "weiter", (context) => tutorialCoachMark.next(), context,
                      animate: true)
                ],
              );
            },
          ),
        ],
      ),
      TargetFocus(
        identify: "keyFaktFakeButton",
        keyTarget: keyFaktFakeButton,
        alignSkip: Alignment.topLeft,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: true,
        radius: 10,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Ist die Aussage ein",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: " Fakt ",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        ),
                        TextSpan(
                          text: "oder ein",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: " fake ",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        ),
                        TextSpan(
                          text: "?",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ];

    await Future.delayed(const Duration(milliseconds: 1000));
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: DesignColors.pink,
      textSkip: "überspringen",
      paddingFocus: 10,
      opacityShadow: 0.9,
      onFinish: () {},
      onClickTarget: null,
      onClickTargetWithTapPosition: (target, tapDetails) async {
        if (target.keyTarget == keyFaktFakeButton) {
          // wait for animation length
          await Future.delayed(const Duration(milliseconds: 500));
          // if tap is on left half of the screen -> FAKE else FAKT
          if (tapDetails.localPosition.dx <
              MediaQuery.of(context).size.width / 2) {
            registerAnswer(false, context);
          } else {
            registerAnswer(true, context);
          }
        }
      },
      onClickOverlay: null,
      onSkip: () {
        widget.appState.prefs.setBool("tutorialPlayed", true);
        if (widget.appState.player != null) {
          widget.appState.route = Routes.home;
        } else {
          widget.appState.route = Routes.signUp;
        }
      },
    )..show(context: context);
  }

  void registerAnswer(bool answer, BuildContext context) {
    HapticFeedback.mediumImpact();
    bool statementCorrect =
        CorrectnessCategory.isFact(testStatement!.statementCorrectness);
    bool answerCorrect = answer == statementCorrect;

    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton:
                actionButton("weiter", showStatementCard, context),
            body: Dialog(
              backgroundColor:
                  answerCorrect ? DesignColors.green : DesignColors.red,
              insetPadding: const EdgeInsets.all(0),
              child: AnimationLimiter(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
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
                                decoration: const BoxDecoration(
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
            ),
          );
        });

    // wait for 5 seconds and then show the statement card
    Future.delayed(const Duration(seconds: 5), () {
      if (!showStatametCardCalled) {
        showStatementCard(context);
      }
    });
  }

  void showStatementCard(BuildContext context) async {
    showStatametCardCalled = true;
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: actionButton("weiter zur App", (context) {
              widget.appState.prefs.setBool("tutorialPlayed", true);
              if (widget.appState.player != null) {
                widget.appState.route = Routes.home;
              } else {
                widget.appState.route = Routes.signUp;
              }
            }, context, color: DesignColors.pink),
            body: Dialog(
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.all(0),
              child: AnimationLimiter(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 100.0,
                        verticalOffset: 100,
                        curve: Curves.elasticOut,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        // heading with icon
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fact_check,
                                color: DesignColors.backgroundBlue,
                                size: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .fontSize! +
                                    10,
                              ),
                              Text(
                                "Faktencheck zur Aussage",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ],
                          ),
                        ),

                        StatementCard(
                            key: keyStatementCard,
                            appState: null,
                            statement: testStatement!,
                            keyStatementSaveAndShare: keyStatementSaveAndShare),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
    var targets = [
      TargetFocus(
        identify: "keyStatementCard",
        keyTarget: keyStatementCard,
        alignSkip: Alignment.topLeft,
        shape: ShapeLightFocus.RRect,
        enableOverlayTab: false,
        enableTargetTab: true,
        radius: 10,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(20),
            align: ContentAlign.top,
            builder: (context, controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Nach jeder Runde werden dir die",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: " Faktenchecks  ",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.yellow),
                        ),
                        TextSpan(
                          text: "angezeigt",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Text("Klicke auf die Karte, um sie anzusehen",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white)),
                ],
              );
            },
          ),
        ],
      ),
    ];

    await Future.delayed(const Duration(milliseconds: 500));
    tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: DesignColors.pink,
      textSkip: "überspringen",
      paddingFocus: 10,
      opacityShadow: 0.9,
      onFinish: () {},
      onClickTarget: (target) async {
        // wait for animation length
        await Future.delayed(const Duration(milliseconds: 500));
        keyStatementCard.currentState!.showStatementDetail(
            testStatement!, keyStatementCard.currentState!.context);
      },
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onSkip: () {
        widget.appState.prefs.setBool("tutorialPlayed", true);
        if (widget.appState.player != null) {
          widget.appState.route = Routes.home;
        } else {
          widget.appState.route = Routes.signUp;
        }
      },
    )..show(context: context);
  }

  void getTestStatement() async {
    testStatement =
        await widget.appState.db.getStatement(GameRules.testStatementId);
  }
}

Widget actionButton(String label, Function onClick, BuildContext context,
    {Color color = Colors.white, bool animate = false}) {
  return MirrorAnimation(
    duration: const Duration(milliseconds: 1000),
    tween: Tween<double>(
      begin: 1,
      end: animate ? 3 : 1,
    ),
    curve: Curves.elasticIn,
    builder: (context, child, double value) => TextButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onClick(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(color: color, letterSpacing: 1 * value)),
          Icon(Icons.arrow_forward, color: color),
        ],
      ),
    ),
  );
}
