import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int playableGames = 0;
    if (widget.appState.player!.friends != null) {
      playableGames = widget.appState.player!.friends!.enemies.fold<int>(
          0,
          (p, e) => e.openGame == null
              ? p + 0
              : p + (e.openGame!.isPlayersTurn() ? 1 : 0));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: DesignColors.backgroundBlue,
                    size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
                  ),
                  Text(
                    "Deine Skills",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: SfRadialGauge(
                      backgroundColor: Colors.transparent,
                      animationDuration: 0.4,
                      enableLoadingAnimation: true,
                      axes: [
                        RadialAxis(
                          useRangeColorForAxis: false,
                          startAngle: 90,
                          endAngle: 90,
                          minimum: 0,
                          maximum: 1,
                          ranges: [
                            GaugeRange(
                              startValue: 0,
                              endValue: 1,
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 0.1,
                              endWidth: 0.1,
                              color: Colors.transparent,
                              // gradient: const SweepGradient(
                              //   colors: [
                              //     DesignColors.red,
                              //     DesignColors.yellow,
                              //     DesignColors.green,
                              //   ],
                              //   stops: [0.0, 0.5, 1],
                              // ),
                            ),
                          ],
                          showTicks: false,
                          showLabels: false,
                          pointers: [
                            RangePointer(
                              value: widget.appState.player!.trueFakeAnswers /
                                  (widget.appState.player!.trueFakeAnswers +
                                      widget.appState.player!.falseFakeAnswers),
                              enableAnimation: true,
                              width: 20,
                              gradient: const SweepGradient(
                                colors: [
                                  DesignColors.red,
                                  DesignColors.yellow,
                                  Color.fromARGB(255, 219, 245, 91),
                                  DesignColors.green,
                                ],
                                stops: [0.0, 0.3, 0.7, 1],
                              ),
                            ),
                            // NeedlePointer(
                            //     enableAnimation: true,
                            //     value: widget.appState.player!.trueFakeAnswers /
                            //         (widget.appState.player!.trueFakeAnswers +
                            //             widget.appState.player!.falseFakeAnswers))
                          ],
                          annotations: [
                            GaugeAnnotation(
                                widget: Container(
                                  child: Text(
                                    'Fakes \nentlarven',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: DesignColors.backgroundBlue),
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0)
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width / 2) - 15,
                    child: SfRadialGauge(
                      animationDuration: 0.4,
                      enableLoadingAnimation: true,
                      axes: [
                        RadialAxis(
                          startAngle: 90,
                          endAngle: 90,
                          minimum: 0,
                          maximum: 1,
                          ranges: [
                            GaugeRange(
                              startValue: 0,
                              endValue: 1,
                              sizeUnit: GaugeSizeUnit.factor,
                              startWidth: 0.3,
                              endWidth: 0.3,
                              color: DesignColors.lightGrey,
                              // gradient: const SweepGradient(
                              //   colors: [
                              //     DesignColors.red,
                              //     DesignColors.yellow,
                              //     DesignColors.green,
                              //   ],
                              //   stops: [0.0, 0.5, 1],
                              // ),
                            ),
                          ],
                          showTicks: false,
                          showLabels: false,
                          pointers: [
                            RangePointer(
                              value: widget
                                      .appState.player!.trueCorrectAnswers /
                                  (widget.appState.player!.trueCorrectAnswers +
                                      widget.appState.player!
                                          .falseCorrectAnswers),
                              enableAnimation: true,
                              width: 20,
                              gradient: const SweepGradient(
                                colors: [
                                  DesignColors.red,
                                  DesignColors.yellow,
                                  Color.fromARGB(255, 219, 245, 91),
                                  DesignColors.green,
                                ],
                                stops: [0.0, 0.3, 0.7, 1],
                              ),
                            ),
                            // NeedlePointer(
                            //     enableAnimation: true,
                            //     value: widget.appState.player!.trueFakeAnswers /
                            //         (widget.appState.player!.trueFakeAnswers +
                            //             widget.appState.player!.falseFakeAnswers))
                          ],
                          annotations: [
                            GaugeAnnotation(
                                widget: Container(
                                  child: Text(
                                    'Fakten \nerkennen',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: DesignColors.backgroundBlue),
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ElevatedButton(
                onPressed: () =>
                    widget.appState.handleNavigationChange(Routes.startGame),
                child: Text(
                  "Neues Spiel",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
            const Divider(
              color: DesignColors.backgroundBlue,
            )
          ],
        ),
      ),
    );
  }
}
