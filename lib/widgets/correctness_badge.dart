import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CorrectnessBadge extends StatelessWidget {
  const CorrectnessBadge({Key? key, required this.correctnessValue})
      : super(key: key);
  final String correctnessValue;
  @override
  Widget build(BuildContext context) {
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
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SelectableText(
                        "Unsere Bewertungsskala",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: DesignColors.green),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.green,
                              ),
                              child: SelectableText("Richtig",
                                  style: Theme.of(context).textTheme.headline4),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Die Behauptung oder Aussage ist richtig.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Unbelegt",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Es gibt keine Belege f??r die Richtigkeit dieser Behauptung oder Aussage.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Falscher Kontext",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Die Aussage wird in einem falschen Kontext dargestellt.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Manipuliert",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Das Video oder Bild wurde manipuliert, z.B. durch Fotoshop.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Irref??hrend",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Etwas wird falsch interpretiert oder ein Ereignis hat sich nicht so zugetragen, wie behauptet wird - dadurch werden Menschen in die Irre gef??hrt.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Frei erfunden",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Zitate, Behauptungen, Zahlen, Geschehnisse oder Personen sind erfunden.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Fehlinformation",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Die Aussage beinhaltet Informationen, die versehentlich falsch wiedergegeben wurden. Die Fehler wurden daraufhin vom Medium korrigiert.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 10,
                        thickness: 2,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: DesignColors.red,
                              ),
                              child: SelectableText(
                                "Satire",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SelectableText(
                              "Es handelt sich um Satire, die jedoch nicht als solche zu erkennen ist.",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
