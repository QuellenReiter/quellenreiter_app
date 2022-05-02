import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';

import '../constants/constants.dart';
import '../models/statement.dart';

/// Brief information display of a single [Statement].
class EnemyCard extends StatelessWidget {
  const EnemyCard({Key? key, required this.enemy, required this.onTapped})
      : super(key: key);

  /// The [Enemy] to be displayed.
  final Enemy enemy;

  /// Stores if user tapped on this [EnemyCard] and notifies the navigation.
  final ValueChanged<Enemy> onTapped;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: DesignColors.black,
        // Make it clickable.
        child: InkWell(
          hoverColor: Colors.grey[300],
          highlightColor: Colors.grey[400],
          splashColor: Colors.grey[600],
          onTap: () => onTapped(enemy),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(enemy.emoji),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(enemy.name)),
                    ],
                  ),
                ),
                // if an open Game exists.
                if (enemy.openGame != null)
                  // .. and if its the players turn
                  if (enemy.openGame!.playersTurn)
                    Flexible(
                      child: ElevatedButton.icon(
                        onPressed: () => {},
                        icon: const Icon(Icons.play_circle_outline_rounded),
                        label: const Text("weiterspielen"),
                      ),
                    )
                  else
                    // if player has to wait for the enemy to play.
                    const Text("warten...")
                else
                  // if there is no open game.
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => {},
                      icon: const Icon(Icons.not_started),
                      label: const Text("neues Spiel starten"),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
