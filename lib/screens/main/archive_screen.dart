import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image/image.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../constants/constants.dart';
import '../../models/statement.dart';
import '../../widgets/correctness_badge.dart';
import '../../widgets/fact_display_container.dart';
import '../../widgets/link_alert.dart';
import '../../widgets/statement_card.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key, required this.appState}) : super(key: key);

  final QuellenreiterAppState appState;
  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  void _showStatementDetail(Statement statement) {
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
                                  padding: const EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  clipBehavior: Clip.none,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
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
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
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
                                                                  .subtitle2
                                                                  ?.copyWith(
                                                                      color: DesignColors
                                                                          .lightGrey),
                                                            ),
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
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            runAlignment: WrapAlignment.center,
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

  @override
  Widget build(BuildContext context) {
    if (widget.appState.safedStatements == null) {
      return const Center(
        child: Text("Keine gespeicherten Fakten oder Fakes."),
      );
    }

    return ListView.builder(
      itemCount: widget.appState.safedStatements!.statements.length,
      itemBuilder: (BuildContext context, int index) {
        return StatementCard(
          statement: widget.appState.safedStatements!.statements[index],
          onTapped: _showStatementDetail,
        );
      },
    );
  }
}
