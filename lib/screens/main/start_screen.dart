import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

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
    widget.appState.getFriends();

    int playableGames = 0;
    if (widget.appState.player!.friends != null) {
      playableGames = widget.appState.player!.friends!.enemies.fold<int>(
          0,
          (p, e) => e.openGame == null
              ? 0
              : p + (e.openGame!.isPlayersTurn() ? 1 : 0));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            widget.appState.player!.emoji,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            "Hallo, " + widget.appState.player!.name,
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: double.infinity,
                            sections: [
                              PieChartSectionData(
                                  title: "nicht geglaubt",
                                  value: widget
                                      .appState.player!.falseCorrectAnswers
                                      .toDouble(),
                                  color: DesignColors.red),
                              PieChartSectionData(
                                  title: "richtig",
                                  value: widget
                                      .appState.player!.trueCorrectAnswers
                                      .toDouble(),
                                  color: DesignColors.green)
                            ],
                          ),
                          swapAnimationDuration:
                              Duration(milliseconds: 400), // Optional
                          swapAnimationCurve: Curves.linear,
                        ),
                      ),
                      Text(
                        "Fakten",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 0,
                ),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: double.infinity,
                            sections: [
                              PieChartSectionData(
                                  title: "Reingefallen",
                                  value: widget
                                      .appState.player!.falseFakeAnswers
                                      .toDouble(),
                                  color: DesignColors.red),
                              PieChartSectionData(
                                  title: "entlarvt",
                                  value: widget.appState.player!.trueFakeAnswers
                                      .toDouble(),
                                  color: DesignColors.green)
                            ],
                          ),
                          swapAnimationDuration:
                              Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear,
                        ),
                      ),
                      Text(
                        "Fakes",
                        style: Theme.of(context).textTheme.headline5,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Text(
        //     "Falsch als Fakt bezeichnet: " +
        //         widget.appState.player!.falseCorrectAnswers.toString(),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Text(
        //     "Falsch als Fake bezeichnet: " +
        //         widget.appState.player!.falseFakeAnswers.toString(),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Text(
        //     "Richtig als Fakt erkannt: " +
        //         widget.appState.player!.trueCorrectAnswers.toString(),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Text(
        //     "Richtig als Fake erkannt: " +
        //         widget.appState.player!.trueFakeAnswers.toString(),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(10),
        //   child: Text(
        //     "Anzahl bewerteter Aussagen: " +
        //         (widget.appState.player!.trueFakeAnswers +
        //                 widget.appState.player!.trueCorrectAnswers +
        //                 widget.appState.player!.falseCorrectAnswers +
        //                 widget.appState.player!.falseFakeAnswers)
        //             .toString(),
        //   ),
        // ),
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
              onPressed: () =>
                  widget.appState.handleNavigationChange(Routes.openGames),
              icon: const Icon(Icons.playlist_play_outlined),
              label: const Text("Offene Spiele"),
            ),
            if (playableGames > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    playableGames.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
