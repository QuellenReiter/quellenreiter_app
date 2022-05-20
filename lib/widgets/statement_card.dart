import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../models/statement.dart';

/// Brief information display of a single [Statement].
class StatementCard extends StatelessWidget {
  const StatementCard(
      {Key? key, required this.statement, required this.onTapped})
      : super(key: key);

  /// The [Statement] to be displayed.
  final Statement statement;

  /// Stores if user tapped on this [StatementCard] and notifies the navigation.
  final ValueChanged<Statement> onTapped;
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
          onTap: () => onTapped(statement),
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
                  child: Text(
                    statement.statementText,
                    style: Theme.of(context).textTheme.subtitle2,
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
                      )
                    ],
                  ),
                ),
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
                      "Faktenchecks",
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
}
