import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key, required this.navCallback}) : super(key: key);

  /// The query used to search for friends.
  final Function(Routes r) navCallback;
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("StartScreen"),
          ElevatedButton.icon(
            onPressed: () => widget.navCallback(Routes.startGame),
            icon: const Icon(Icons.gamepad_outlined),
            label: const Text("Neues Spiel starten"),
          ),
          ElevatedButton.icon(
            onPressed: () => widget.navCallback(Routes.openGames),
            icon: const Icon(Icons.playlist_play_outlined),
            label: const Text("Offene Spiele"),
          ),
        ],
      ),
    );
  }
}
