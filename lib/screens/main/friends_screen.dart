import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.topRight,
          child: FloatingActionButton(
            onPressed: () => {},
            child: Icon(Icons.add),
          ),
        ),
      ),
      (widget.appState.player?.friends == null ||
              widget.appState.player!.friends!.enemies.isEmpty)
          ? Center(
              child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: const Icon(Icons.send_rounded),
                  label: const Text("Freunde einladen"),
                ),
                ElevatedButton.icon(
                  onPressed: () => {},
                  icon: const Icon(Icons.search),
                  label: const Text("Freunde finden"),
                ),
              ],
            ))
          : ListView.builder(
              itemCount: widget.appState.player!.friends!.enemies.length,
              itemBuilder: (BuildContext context, int index) {
                return EnemyCard(
                  enemy: widget.appState.player!.friends!.enemies[index],
                  onTapped: (enemy) => {},
                );
              },
            ),
    ]);
  }
}
