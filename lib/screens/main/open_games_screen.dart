import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../widgets/enemy_card.dart';

class OpenGamesScreen extends StatefulWidget {
  const OpenGamesScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<OpenGamesScreen> createState() => _OpenGamesScreenState();
}

class _OpenGamesScreenState extends State<OpenGamesScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.appState.player?.friends == null)
      return const CircularProgressIndicator();

    List<Enemy> enemiesWithOpenGame = widget.appState.player!.friends!.enemies
        .where((e) => e.openGame != null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offene Spiele"),
      ),
      body: Column(
        children: [
          if (enemiesWithOpenGame.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: enemiesWithOpenGame.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EnemyCard(
                      appState: widget.appState,
                      enemy: enemiesWithOpenGame[index],
                      onTapped: (enemy) => {},
                    );
                  },
                ),
              ),
            )
          else
            Center(
              child: ElevatedButton.icon(
                onPressed: () =>
                    widget.appState.handleNavigationChange(Routes.startGame),
                icon: const Icon(Icons.gamepad_outlined),
                label: const Text("Neues Spiel starten"),
              ),
            )
        ],
      ),
    );
  }
}
