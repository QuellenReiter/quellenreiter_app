import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/fact.dart';
import 'link_alert.dart';

/// Container to display a single [Fact] in detail.
//ignore: must_be_immutable
class FactDisplayContainer extends StatelessWidget {
  const FactDisplayContainer({
    Key? key,
    required this.fact,
  }) : super(key: key);

  /// The fact to be displayed.
  final Fact fact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
      // The grey background container.
      child: Container(
        alignment: Alignment.topLeft,
        clipBehavior: Clip.none,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: DesignColors.lightGrey,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: DesignColors.green,
                ),
                child: SelectableText(
                  "Fakt",
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.22,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Display [fact.factText] and a label "Fakt".
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.7,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.backgroundBlue,
                              ),
                              child: SelectableText(
                                fact.factText,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    ?.copyWith(color: DesignColors.lightGrey),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Display more information.
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Author.
                            Row(
                              children: [
                                const Icon(Icons.person),
                                Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SelectableText(fact.factAuthor)),
                              ],
                            ),
                            const Divider(
                              height: 20,
                            ),
                            // Media.
                            Row(
                              children: [
                                const Icon(Icons.newspaper),
                                Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SelectableText(fact.factMedia)),
                              ],
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date.
                            Row(
                              children: [
                                const Icon(Icons.calendar_month),
                                Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SelectableText(fact.dateAsString())),
                              ],
                            ),
                            const Divider(
                              height: 20,
                            ),
                            // Language.
                            Row(
                              children: [
                                const Icon(Icons.language),
                                Padding(
                                    padding: const EdgeInsets.only(left: 3),
                                    child: SelectableText(fact.factLanguage)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Divider(
                        height: 20, thickness: 2, color: DesignColors.black),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LinkAlert(
                          label: "Link zum Artikel",
                          link: fact.factLink,
                          color: Colors.grey[600],
                          msg: ""),
                      fact.factArchivedLink != null
                          ? LinkAlert(
                              label: "Archivierter Link zum Artikel",
                              link: fact.factArchivedLink!,
                              color: Colors.grey[600],
                              msg: "",
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
