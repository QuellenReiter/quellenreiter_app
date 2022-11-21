import 'package:flutter/material.dart';
import 'package:quellenreiter_app/widgets/custom_bottom_sheet.dart';
import '../constants/constants.dart';

class CorrectnessBadge extends StatelessWidget {
  const CorrectnessBadge({Key? key, required this.correctnessValue})
      : super(key: key);
  final String correctnessValue;
  @override
  Widget build(BuildContext context) {
    bool answerCorrect = CorrectnessCategory.isFact(correctnessValue);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: answerCorrect ? DesignColors.green : DesignColors.red,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          hoverColor: answerCorrect
              ? const Color.fromARGB(255, 0, 121, 89)
              : const Color.fromARGB(255, 176, 77, 1),
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
          onTap: () => CustomBottomSheet.showCustomBottomSheet(
            initialHeight: 0.6,
            context: context,
            scrollable: true,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SelectableText(
                  "Unsere Bewertungsskala",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: DesignColors.green),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: CorrectnessCategory.length(),
                    itemBuilder: (context, index) {
                      return getBadgeAndText(CorrectnessCategory.at(index),
                          CorrectnessCategoryExplanation.at(index), context);
                    })
              ],
            ),
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
                  color: CorrectnessCategory.isFact(badgeText)
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
