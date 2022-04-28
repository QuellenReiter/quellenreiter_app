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
    return Column(children: [
      Flexible(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              onPressed: () => {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
      (widget.appState.player?.friends == null ||
              widget.appState.player!.friends!.enemies.isEmpty)
          ? Flexible(
              child: Center(
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
              )),
            )
          : Flexible(
              child: ListView.builder(
                itemCount: widget.appState.player!.friends!.enemies.length,
                itemBuilder: (BuildContext context, int index) {
                  return EnemyCard(
                    enemy: widget.appState.player!.friends!.enemies[index],
                    onTapped: (enemy) => {},
                  );
                },
              ),
            ),
      (widget.appState.enemyRequests != null &&
              widget.appState.enemyRequests!.enemies.isNotEmpty)
          ? Flexible(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text("Offene Anfragen:"),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemCount: widget.appState.enemyRequests!.enemies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EnemyCard(
                          enemy: widget.appState.enemyRequests!.enemies[index],
                          onTapped: (enemy) =>
                              widget.appState.acceptRequest(enemy),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          : Flexible(child: SizedBox.shrink()),
    ]);
  }
}
