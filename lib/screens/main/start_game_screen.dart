import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../constants/constants.dart';
import '../../widgets/enemy_card.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.appState.player?.friends == null)
      return const CircularProgressIndicator();
    // display button if user has no friends yet.
    List<Enemy> enemiesWithNoGame = widget.appState.player!.friends!.enemies
        .where((e) => e.openGame == null)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neues Spiel"),
      ),
      body: Column(
        children: [
          if (enemiesWithNoGame.isNotEmpty)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView.builder(
                  itemCount: enemiesWithNoGame.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EnemyCard(
                      appState: widget.appState,
                      enemy: enemiesWithNoGame[index],
                      onTapped: (enemy) => {},
                    );
                  },
                ),
              ),
            )
          else
            Center(
              child: ElevatedButton.icon(
                onPressed: () => {widget.appState.route = Routes.addFriends},
                icon: const Icon(Icons.gamepad_outlined),
                label: const Text("Freund:innen einladen"),
              ),
            )
        ],
      ),
    );
  }
}
