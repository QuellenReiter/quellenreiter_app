import 'package:flutter/material.dart';
import 'package:quellenreiter_app/utilities/utilities.dart';

import '../constants/constants.dart';

class CorrectnessBadge extends StatelessWidget {
  const CorrectnessBadge({Key? key, required this.correctnessValue})
      : super(key: key);
  final String correctnessValue;
  @override
  Widget build(BuildContext context) {
    Widget makeSheetDismissable({required Widget child}) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: GestureDetector(onTap: () {}, child: child),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: correctnessValue != CorrectnessCategory.correct
            ? DesignColors.red
            : DesignColors.green,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          hoverColor: correctnessValue != CorrectnessCategory.correct
              ? const Color.fromARGB(255, 176, 77, 1)
              : const Color.fromARGB(255, 0, 121, 89),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Text(
              correctnessValue,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            isDismissible: true,
            builder: (BuildContext context) {
              return makeSheetDismissable(
                child: DraggableScrollableSheet(
                  minChildSize: 0.4,
                  maxChildSize: 1,
                  initialChildSize: 0.6,
                  builder: (_, controller) => Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: controller,
                      children: [
                        SelectableText(
                          "Unsere Bewertungsskala",
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: DesignColors.green),
                        ),
                        Flexible(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: CorrectnessCategory.length(),
                              itemBuilder: (context, index) {
                                return getBadgeAndText(
                                    CorrectnessCategory.at(index),
                                    CorrectnessCategoryExplanation.at(index),
                                    context);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget getBadgeAndText(
      String badgeText, String mainText, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        alignment: Alignment.topLeft,
        clipBehavior: Clip.none,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: DesignColors.lightGrey,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: badgeText == CorrectnessCategory.correct
                      ? DesignColors.green
                      : DesignColors.red,
                ),
                child: SelectableText(
                  badgeText,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SelectableText(
                  mainText,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
