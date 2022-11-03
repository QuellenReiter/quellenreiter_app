import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/screens/tutorial.dart';
import 'package:quellenreiter_app/widgets/custom_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../constants/constants.dart';
import '../models/statement.dart';
import 'correctness_badge.dart';
import 'fact_display_container.dart';
import 'link_alert.dart';

/// Brief information display of a single [Statement].
class StatementCard extends StatefulWidget {
  const StatementCard(
      {Key? key,
      required this.appState,
      required this.statement,
      this.keyStatementSaveAndShare})
      : super(key: key);

  /// The current appstate.
  final QuellenreiterAppState? appState;
  final GlobalKey? keyStatementSaveAndShare;

  /// The [Statement] to be displayed.
  final Statement statement;

  @override
  State<StatementCard> createState() => StatementCardState();
}

class StatementCardState extends State<StatementCard> {
  ValueNotifier<bool> archiveIsLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> isArchived = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    // List of the Media publishing the [Facts] of this [Statement].
    List<Widget> factcheckMediaList = List.generate(
      widget.statement.statementFactchecks.facts.length,
      (int i) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fact_check,
            color: DesignColors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 3),
            child: Text(
              widget.statement.statementFactchecks.facts[i].factMedia,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(10),
      // The grey background box.
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: DesignColors.lightGrey,
        elevation: 5,
        // Make it clickable.
        child: InkWell(
          hoverColor: Colors.black54,
          highlightColor: Colors.black45,
          splashColor: Colors.black38,
          onTap: () => showStatementDetail(widget.statement, context),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Statementtext.
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: FadeInImage.memoryNetwork(
                                  fadeInDuration:
                                      const Duration(milliseconds: 400),
                                  fadeInCurve: Curves.easeInOut,
                                  fit: BoxFit.cover,
                                  placeholder: kTransparentImage,
                                  image: widget.statement.statementPictureURL !=
                                          null
                                      ? widget.statement.statementPictureURL!
                                          .replaceAll(
                                              "https%3A%2F%2Fparsefiles.back4app.com%2FFeP6gb7k9R2K9OztjKWA1DgYhubqhW0yJMyrHbxH%2F",
                                              "")
                                      : "https://quellenreiter.app/assets/logo-pink.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.statement.statementText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: DesignColors.black),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: DesignColors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Display correctness.
                      Container(
                        decoration: BoxDecoration(
                          color: CorrectnessCategory.isFact(
                                  widget.statement.statementCorrectness)
                              ? DesignColors.green
                              : DesignColors.red,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          widget.statement.statementCorrectness,
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: DesignColors.lightGrey),
                        ),
                      ),

                      // Display Media and date.
                      Text(
                        widget.statement.statementMedia +
                            ', ' +
                            widget.statement.dateAsString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: DesignColors.black),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          width: 40,
                          margin: const EdgeInsets.only(right: 10),
                          child: const Divider(
                            color: Colors.grey,
                            height: 40,
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Faktenchecks zur Aussage von:",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: DesignColors.black),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Divider(
                            color: Colors.grey,
                            height: 40,
                          )),
                    ),
                  ],
                ),
                // Display list of Factcheck Media.
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  children: factcheckMediaList,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeSheetDismissable({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context).pop();
      },
      child: GestureDetector(onTap: () {}, child: child),
    );
  }

  void showStatementDetail(Statement statement, BuildContext context) async {
    // if we are in tutorial (appstate == null) then just switch the value
    // else we are in the app and need to update the database
    isArchived.value = widget.appState == null
        ? isArchived.value
        : widget.appState!.player!.safedStatementsIds!
            .contains(statement.objectId);

    List<Widget> factContainers = List.generate(
      statement.statementFactchecks.facts.length,
      (int i) => FactDisplayContainer(
        fact: statement.statementFactchecks.facts[i],
      ),
    );

    HapticFeedback.mediumImpact();
    CustomBottomSheet.showCustomBottomSheet(
      context: context,
      scrollable: true,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: const Icon(Icons.share),
                    iconSize: 20,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Share.share(
                          statement.statementCorrectness +
                              ": " +
                              statement.statementText +
                              "\n\n" +
                              "https://fakten.quellenreiter.app/#/statement/${statement.objectId}",
                          subject:
                              "Teile diese Aussage mit deinen Freund:innen!");
                    }),
                ValueListenableBuilder(
                  valueListenable: archiveIsLoading,
                  builder: (context, bool loading, child) {
                    return ValueListenableBuilder(
                        key: widget.keyStatementSaveAndShare,
                        valueListenable: isArchived,
                        builder: (context, bool archived, child) {
                          if (loading) {
                            return const IconButton(
                              onPressed: null,
                              icon: Padding(
                                  padding: EdgeInsets.all(6),
                                  child: CircularProgressIndicator()),
                            );
                          } else if (isArchived.value) {
                            return IconButton(
                              onPressed: () async {
                                archiveIsLoading.value = true;

                                HapticFeedback.mediumImpact();
                                if (widget.appState != null) {
                                  widget.appState!.player!.safedStatementsIds!
                                      .remove(statement.objectId!);

                                  await widget.appState!.updateUserData();
                                } else {
                                  // wait for 1 second to simulate a loading time
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                }

                                archiveIsLoading.value = false;
                                isArchived.value = false;
                              },
                              icon: const Icon(Icons.delete),
                            );
                          } else {
                            return IconButton(
                              onPressed: () async {
                                archiveIsLoading.value = true;
                                HapticFeedback.mediumImpact();
                                if (widget.appState != null) {
                                  widget.appState!.player!.safedStatementsIds!
                                      .add(statement.objectId!);
                                  await widget.appState!.updateUserData();
                                } else {
                                  // wait for 1 second to simulate a loading time
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                }

                                isArchived.value = true;
                                archiveIsLoading.value = false;
                              },
                              icon: const Icon(Icons.archive_outlined),
                            );
                          }
                        });
                  },
                )
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            // Grey background box.
            child: Container(
              padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                        MediaQuery.of(context).size.aspectRatio > (9 / 16)
                            ? 1.08
                            : 1.15,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                // The image with rounded edges and cropped
                                // to 4:3 ratio.
                                Tooltip(
                                  message: "Klicken zum Vergrößern",
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 10.0,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => showImage(context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: AspectRatio(
                                          aspectRatio: 4 / 3,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage.memoryNetwork(
                                              fadeInDuration: const Duration(
                                                  milliseconds: 400),
                                              fadeInCurve: Curves.easeInOut,
                                              fit: BoxFit.cover,
                                              placeholder: kTransparentImage,
                                              image: statement
                                                          .statementPictureURL !=
                                                      null
                                                  ? statement
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
                                  ),
                                ),
                                // Display [statement.samplePictureCopyright]
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    color: Color.fromARGB(138, 0, 0, 0),
                                    child: SelectableText(
                                      statement.samplePictureCopyright.trim(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Display [statement.statementText] and
                        // [statement.statementCorrectness]
                        Align(
                          alignment: Alignment.centerRight,
                          child: FractionallySizedBox(
                            widthFactor: 0.6,
                            child: Align(
                              alignment: Alignment.centerLeft,
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
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: CorrectnessCategory.isFact(
                                                statement.statementCorrectness)
                                            ? DesignColors.green
                                            : DesignColors.red,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(statement.statementText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1),
                                          LinkAlert(
                                              link: statement.statementLink,
                                              msg:
                                                  "Vorsicht! Du verlässt diese Seite. Die Inhalte können möglicherweise verstörend oder diskriminierend sein. Inhalte, die mit einem roten Label gekennzeichnet wurden, enthalten möglicherweise Desinformationen und sind keine verlässliche Quelle.\nVollständiger Link:"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 10.0,
                                    child: CorrectnessBadge(
                                      correctnessValue:
                                          statement.statementCorrectness,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Display more information.
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
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
                              padding: const EdgeInsets.only(left: 3),
                              child: Text(statement.statementAuthor),
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
                              child: Text(statement.statementMedia +
                                  ' | ' +
                                  statement.statementMediatype),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month),
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: SelectableText(statement.dateAsString()),
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
                              child:
                                  SelectableText(statement.statementLanguage),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              "Warum ist diese Aussage \"${statement.statementCorrectness}\"?",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: DesignColors.black),
            ),
          ),
          // Display all [statement.factChecks]
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: factContainers,
            ),
          ),
        ],
      ),
    );
    // show tutorial, if key is not null.
    if (widget.keyStatementSaveAndShare != null) {
      late TutorialCoachMark tutorialCoachMark;
      var targets = [
        TargetFocus(
          identify: "keyStatementSaveAndShare",
          keyTarget: widget.keyStatementSaveAndShare,
          alignSkip: Alignment.topLeft,
          shape: ShapeLightFocus.Circle,
          enableOverlayTab: false,
          enableTargetTab: true,
          radius: 10,
          contents: [
            TargetContent(
              padding: const EdgeInsets.all(20),
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Hier kannst du die Faktenchecks",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: Colors.white),
                            ),
                            TextSpan(
                              text: " Speichern ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(color: DesignColors.yellow),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Gespeicherte Faktenchecks landen im ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white),
                            ),
                            TextSpan(
                              text: " Archiv ",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ];

      await Future.delayed(Duration(seconds: 1));
      tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: DesignColors.pink,
        textSkip: "überspringen",
        paddingFocus: 10,
        opacityShadow: 0.9,
        onFinish: () {
          print("finish");
        },
        onClickTarget: null,
        onClickTargetWithTapPosition: (target, tapDetails) async {
          archiveIsLoading.value = true;
          HapticFeedback.mediumImpact();
          if (widget.appState != null) {
            widget.appState!.player!.safedStatementsIds!
                .add(statement.objectId!);
            await widget.appState!.updateUserData();
          } else {
            // wait for 1 second to simulate a loading time
            await Future.delayed(const Duration(seconds: 1));
          }

          isArchived.value = true;
          archiveIsLoading.value = false;
        },
        onClickOverlay: null,
        onSkip: null,
      )..show(context: context);
    }
  }

  void showImage(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(alignment: Alignment.centerLeft, children: [
            FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 400),
              fadeInCurve: Curves.easeInOut,
              fit: BoxFit.cover,
              placeholder: kTransparentImage,
              image: widget.statement.statementPictureURL != null
                  ? widget.statement.statementPictureURL!.replaceAll(
                      "https%3A%2F%2Fparsefiles.back4app.com%2FFeP6gb7k9R2K9OztjKWA1DgYhubqhW0yJMyrHbxH%2F",
                      "")
                  : "https://quellenreiter.app/assets/logo-pink.png",
            ),
            // Display [statement.samplePictureCopyright]
            RotatedBox(
              quarterTurns: 1,
              child: Container(
                padding: const EdgeInsets.all(2),
                color: Color.fromARGB(138, 0, 0, 0),
                child: SelectableText(
                  widget.statement.samplePictureCopyright.trim(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                iconSize: 50,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop(context);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
