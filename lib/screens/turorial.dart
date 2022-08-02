import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image/image.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/main_app_bar.dart';
import 'package:quellenreiter_app/widgets/statement_card.dart';
import 'package:quellenreiter_app/widgets/title_app_bar.dart';
import 'package:transparent_image/transparent_image.dart';

import '../constants/constants.dart';

class Turorial extends StatelessWidget {
  const Turorial({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: MainAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: IconButton(
        onPressed: () => showTestQuest(context),
        icon: Icon(Icons.arrow_forward),
      ),
      body: Container(
        child: Column(
          children: [
            Text("Tutorial", style: Theme.of(context).textTheme.headline1),
            Text("Willkommen bei Quellenreiter",
                style: Theme.of(context).textTheme.headline4),
            Text("Hier lernst du, wie du Quellen richtig bewertest",
                style: Theme.of(context).textTheme.headline4),
          ],
        ),
      ),
    ));
  }

  void showTestQuest(context) {
    print("showTestQuest");
    showGeneralDialog(
      context: context,
      pageBuilder: ((context, animation, secondaryAnimation) {
        return SafeArea(
          child: Material(
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
                                  fadeInDuration:
                                      const Duration(milliseconds: 200),
                                  fadeInCurve: Curves.easeInOut,
                                  // fit: BoxFit.,
                                  placeholder: kTransparentImage,
                                  image: GameRules.testStatement
                                              .statementPictureURL !=
                                          null
                                      ? GameRules
                                          .testStatement.statementPictureURL!
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
                                              padding: const EdgeInsets.all(10),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                color:
                                                    DesignColors.backgroundBlue,
                                              ),
                                              child: Text(
                                                  GameRules.testStatement
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
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(GameRules
                                                  .testStatement
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
                                              child: Text(GameRules
                                                      .testStatement
                                                      .statementMedia +
                                                  ' | ' +
                                                  GameRules.testStatement
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
                                              child: Text(GameRules
                                                  .testStatement
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
                                              child: Text(GameRules
                                                  .testStatement
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: DesignColors.red,
                                        minimumSize: Size(100, 70),
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
                                        primary: DesignColors.green,
                                        minimumSize: Size(100, 70),
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
  }

  void registerAnswer(bool answer, BuildContext context) {
    bool answerCorrect = false;
    if (answer &&
        GameRules.testStatement.statementCorrectness ==
            CorrectnessCategory.correct) {
      answerCorrect = true;
    }
    if (!answer &&
        GameRules.testStatement.statementCorrectness !=
            CorrectnessCategory.correct) {
      answerCorrect = true;
    }

    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: IconButton(
                onPressed: () => showStatementCard(context),
                icon: Icon(Icons.arrow_forward),
              ),
              body: Dialog(
                backgroundColor:
                    answerCorrect ? DesignColors.green : DesignColors.red,
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
            ),
          );
        });
  }

  void showStatementCard(BuildContext context) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: IconButton(
                onPressed: () {
                  appState.prefs.setBool("tutorialPlayed", true);
                  if (appState.player != null) {
                    appState.route = Routes.home;
                  } else {
                    appState.route = Routes.login;
                  }
                },
                icon: Icon(Icons.arrow_forward),
              ),
              body: Dialog(
                backgroundColor: DesignColors.lightBlue,
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
                        StatementCard(
                            appState: null, statement: GameRules.testStatement),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
