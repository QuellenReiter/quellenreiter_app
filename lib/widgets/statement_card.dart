import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import '../constants/constants.dart';
import '../models/statement.dart';
import 'correctness_badge.dart';
import 'fact_display_container.dart';
import 'link_alert.dart';

/// Brief information display of a single [Statement].
class StatementCard extends StatelessWidget {
  const StatementCard(
      {Key? key, required this.appState, required this.statement})
      : super(key: key);

  /// The current appstate.
  final QuellenreiterAppState appState;

  /// The [Statement] to be displayed.
  final Statement statement;

  @override
  Widget build(BuildContext context) {
    // List of the Media publishing the [Facts] of this [Statement].
    List<Widget> factcheckMediaList = List.generate(
      statement.statementFactchecks.facts.length,
      (int i) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.fact_check,
            color: DesignColors.lightGrey,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 3),
            child: Text(
              statement.statementFactchecks.facts[i].factMedia,
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
        color: DesignColors.black,
        // Make it clickable.
        child: InkWell(
          hoverColor: Colors.black54,
          highlightColor: Colors.black45,
          splashColor: Colors.black38,
          onTap: () => _showStatementDetail(statement, context),
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
                        Flexible(
                          child: Text(
                            statement.statementText,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        if (appState.player!.safedStatementsIds!
                            .contains(statement.objectId))
                          IconButton(
                            padding: const EdgeInsets.only(
                                top: 0, right: 0, left: 10, bottom: 10),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              appState.player!.safedStatementsIds!
                                  .remove(statement.objectId!);
                              appState.updateUserData();
                            },
                            icon: const Icon(Icons.delete),
                          )
                        else
                          IconButton(
                            padding: const EdgeInsets.only(
                                top: 0, right: 0, left: 10, bottom: 10),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              appState.player!.safedStatementsIds!
                                  .add(statement.objectId!);
                              appState.updateUserData();
                            },
                            icon: const Icon(Icons.archive_outlined),
                          ),
                      ]),
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
                          color: statement.statementCorrectness ==
                                  CorrectnessCategory.correct
                              ? DesignColors.green
                              : DesignColors.red,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          statement.statementCorrectness,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              ?.copyWith(color: DesignColors.lightGrey),
                        ),
                      ),

                      // Display Media and date.
                      Text(
                        statement.statementMedia +
                            ', ' +
                            statement.dateAsString(),
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     TextButton.icon(
                //       onPressed: null,
                //       icon: const Icon(Icons.archive_outlined),
                //       label: const Text("merken"),
                //     ),
                //   ],
                // ),
                Row(children: [
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
                      style: Theme.of(context).textTheme.subtitle1,
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
                ]),
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

  void _showStatementDetail(Statement statement, BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (BuildContext context) {
        // List of widgets displaying all factchecks.
        List<Widget> factContainers = List.generate(
          statement.statementFactchecks.facts.length,
          (int i) => FactDisplayContainer(
            fact: statement.statementFactchecks.facts[i],
          ),
        );
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        iconSize: 20,
                        onPressed: () => Share.share(
                            "https://quellenreiter.github.io/fact-browser-deployment/#/statement/${statement.objectId}"),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(scrollbars: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      // Scrollable container displaying all the information.
                      child: ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context)
                            .copyWith(scrollbars: false),
                        child: ListView(
                          clipBehavior: Clip.hardEdge,
                          shrinkWrap: true,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 400),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                // Grey background box.
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 10, left: 10, right: 10),
                                  alignment: Alignment.topLeft,
                                  clipBehavior: Clip.none,
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: DesignColors.black,
                                  ),
                                  child: FractionallySizedBox(
                                    widthFactor: 1.15,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: FractionallySizedBox(
                                                widthFactor: 0.8,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: [
                                                    // The image with rounded edges and cropped
                                                    // to 4:3 ratio.
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: AspectRatio(
                                                        aspectRatio: 4 / 3,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: FadeInImage
                                                              .memoryNetwork(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        400),
                                                            fadeInCurve: Curves
                                                                .easeInOut,
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                kTransparentImage,
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
                                                    // Display [statement.samplePictureCopyright]
                                                    RotatedBox(
                                                      quarterTurns: 1,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2),
                                                        color:
                                                            Colors.transparent,
                                                        child: SelectableText(
                                                          statement
                                                              .samplePictureCopyright
                                                              .trim(),
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: DesignColors
                                                              .backgroundBlue,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                statement
                                                                    .statementText,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6),
                                                            LinkAlert(
                                                                link: statement
                                                                    .statementLink,
                                                                msg:
                                                                    "Vorsicht! Du verlässt diese Seite und wirst zu einer archivierten vollständigen Version dieser Aussage weitergeleitet. Die Inhalte können möglicherweise verstörend oder diskriminierend sein. Inhalte, die mit dem Label “Unbelegt”, “Falscher Kontext”, “Manipuliert”, “Irreführend” oder “Frei erfunden” gekennzeichnet wurden, enthalten Desinformationen und sind keine verlässliche Quelle. Vollständiger Link:"),
                                                          ],
                                                        ),
                                                      ),
                                                      CorrectnessBadge(
                                                        correctnessValue: statement
                                                            .statementCorrectness,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        // Display more information.
                                        Padding(
                                          padding: const EdgeInsets.all(20),
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
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: Text(statement
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
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: Text(statement
                                                            .statementMedia +
                                                        ' | ' +
                                                        statement
                                                            .statementMediatype),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                      Icons.calendar_month),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: SelectableText(
                                                        statement
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
                                                        const EdgeInsets.only(
                                                            left: 3),
                                                    child: SelectableText(
                                                        statement
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  "Artikel die belegen, dass diese Aussage als \"${statement.statementCorrectness}\" einzuordnen ist:",
                                  style: Theme.of(context).textTheme.headline6,
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
