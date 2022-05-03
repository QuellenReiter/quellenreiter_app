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
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Hallo, " +
                widget.appState.player!.name +
                " " +
                widget.appState.player!.emoji),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Falsch als Fakt bezeichnet: " +
                  widget.appState.player!.falseCorrectAnswers.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Falsch als Fake bezeichnet: " +
                  widget.appState.player!.falseFakeAnswers.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Richtig als Fakt erkannt: " +
                  widget.appState.player!.trueCorrectAnswers.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Richtig als Fake erkannt: " +
                  widget.appState.player!.trueFakeAnswers.toString(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Anzahl bewerteter Aussagen: " +
                  (widget.appState.player!.trueFakeAnswers +
                          widget.appState.player!.trueCorrectAnswers +
                          widget.appState.player!.falseCorrectAnswers +
                          widget.appState.player!.falseFakeAnswers)
                      .toString(),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                widget.appState.handleNavigationChange(Routes.startGame),
            icon: const Icon(Icons.gamepad_outlined),
            label: const Text("Neues Spiel starten"),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                widget.appState.handleNavigationChange(Routes.openGames),
            icon: const Icon(Icons.playlist_play_outlined),
            label: const Text("Offene Spiele"),
          ),
        ],
      ),
    );
  }
}
