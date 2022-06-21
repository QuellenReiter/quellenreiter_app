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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    animationDuration: 0.4,
                    enableLoadingAnimation: true,
                    axes: [
                      RadialAxis(
                        startAngle: 180,
                        endAngle: 0,
                        minimum: 0,
                        maximum: 1,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 1,
                            sizeUnit: GaugeSizeUnit.factor,
                            startWidth: 0.1,
                            endWidth: 0.2,
                            gradient: const SweepGradient(
                              colors: [
                                DesignColors.red,
                                DesignColors.yellow,
                                DesignColors.green,
                              ],
                              stops: [0.0, 0.5, 1],
                            ),
                          ),
                        ],
                        showTicks: false,
                        showLabels: false,
                        pointers: [
                          NeedlePointer(
                              enableAnimation: true,
                              value: widget.appState.player!.trueFakeAnswers /
                                  (widget.appState.player!.trueFakeAnswers +
                                      widget.appState.player!.falseFakeAnswers))
                        ],
                        annotations: [
                          GaugeAnnotation(
                              widget: Container(
                                child: Text(
                                  'Fakes entlarven',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: DesignColors.backgroundBlue),
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.5)
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
                        startAngle: 180,
                        endAngle: 0,
                        minimum: 0,
                        maximum: 1,
                        ranges: [
                          GaugeRange(
                            startValue: 0,
                            endValue: 1,
                            sizeUnit: GaugeSizeUnit.factor,
                            startWidth: 0.1,
                            endWidth: 0.2,
                            gradient: const SweepGradient(
                              colors: [
                                DesignColors.red,
                                DesignColors.yellow,
                                DesignColors.green,
                              ],
                              stops: [0.0, 0.5, 1],
                            ),
                          ),
                        ],
                        showTicks: false,
                        showLabels: false,
                        pointers: [
                          NeedlePointer(
                              enableAnimation: true,
                              value: widget
                                      .appState.player!.trueCorrectAnswers /
                                  (widget.appState.player!.trueCorrectAnswers +
                                      widget.appState.player!
                                          .falseCorrectAnswers))
                        ],
                        annotations: [
                          GaugeAnnotation(
                              widget: Container(
                                child: Text(
                                  'Fakten erkennen',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: DesignColors.backgroundBlue),
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.5)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: DesignColors.yellow,
                  size: 40,
                ),
                Countup(
                  begin: 0,
                  end: widget.appState.player!.getXp().toDouble(),
                  duration: const Duration(milliseconds: 500),
                  style: Theme.of(context).textTheme.headline4,
                )
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                widget.appState.handleNavigationChange(Routes.startGame),
            icon: const Icon(Icons.gamepad_outlined),
            label: const Text("Neues Spiel starten"),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              ElevatedButton.icon(
                onPressed: () => widget.appState.route = Routes.openGames,
                icon: const Icon(Icons.playlist_play_outlined),
                label: const Text("Offene Spiele"),
              ),
              if (playableGames > 0)
                Positioned(
                  right: -6,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        playableGames.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
