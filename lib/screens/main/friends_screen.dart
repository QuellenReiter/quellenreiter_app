import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key, this.enemies}) : super(key: key);

  /// The query used to search for friends.
  final Enemies? enemies;
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
      widget.enemies == null
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
              itemCount: widget.enemies!.enemies.length,
              itemBuilder: (BuildContext context, int index) {
                return EnemyCard(
                  enemy: widget.enemies!.enemies[index],
                  onTapped: (enemy) => {},
                );
              },
            ),
    ]);
  }
}
