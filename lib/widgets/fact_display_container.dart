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
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      // The grey background container.
      child: Container(
        alignment: Alignment.topLeft,
        clipBehavior: Clip.none,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: DesignColors.black,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: DesignColors.green,
                ),
                child: SelectableText(
                  "Fakt",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1.1,
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
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.person),
                            Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: SelectableText(fact.factAuthor)),
                          ],
                        ),
                        // Media.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.newspaper),
                            Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: SelectableText(fact.factMedia)),
                          ],
                        ),
                        if (fact.dateAsString().isNotEmpty)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month),
                              Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: SelectableText(fact.dateAsString())),
                            ],
                          ),
                        // Language.
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language),
                            Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: SelectableText(fact.factLanguage)),
                          ],
                        )
                      ],
                    ),
                  ),
                  const FractionallySizedBox(
                    widthFactor: 0.8,
                    child: Divider(
                        height: 20,
                        thickness: 2,
                        color: DesignColors.lightGrey),
                  ),
                  Wrap(
                    runSpacing: 0,
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    direction: Axis.horizontal,
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
