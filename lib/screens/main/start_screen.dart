import 'package:countup/countup.dart';
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
    int playableGames = 0;
    if (widget.appState.player!.friends != null) {
      playableGames = widget.appState.player!.friends!.enemies.fold<int>(
          0,
          (p, e) => e.openGame == null
              ? p + 0
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
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: MediaQuery.of(context).size.width / 5,
                    sections: [
                      PieChartSectionData(
                          title: "Falsch",
                          value: widget.appState.player!.falseCorrectAnswers +
                              widget.appState.player!.falseFakeAnswers
                                  .toDouble(),
                          color: DesignColors.red),
                      PieChartSectionData(
                          title: "Richtig",
                          value: widget.appState.player!.trueCorrectAnswers +
                              widget.appState.player!.trueFakeAnswers
                                  .toDouble(),
                          color: DesignColors.green)
                    ],
                  ),
                  swapAnimationDuration:
                      const Duration(milliseconds: 400), // Optional
                  swapAnimationCurve: Curves.linear,
                ),
              ),
              Row(
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
              )
            ]),
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
    );
  }
}
