import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/start_game_button.dart';

import '../constants/constants.dart';
import '../models/statement.dart';

/// Brief information display of a single [Statement].
class EnemyCard extends StatelessWidget {
  const EnemyCard(
      {Key? key,
      required this.enemy,
      required this.onTapped,
      required this.appState})
      : super(key: key);

  /// The [Enemy] to be displayed.
  final Enemy enemy;
  final QuellenreiterAppState appState;

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
          onTap: () => {},
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
                  Row(
                    children: [
                      // .. and if its the players turn
                      if (enemy.openGame!.isPlayersTurn() &&
                          enemy.openGame!.playerAnswers.isNotEmpty)
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              appState.currentEnemy = enemy;
                              appState.route = Routes.gameReadyToStart;
                            },
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text("weiterspielen"),
                          ),
                        )
                      else if (enemy.openGame!.isPlayersTurn() &&
                          enemy.openGame!.playerAnswers.isEmpty)
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              appState.currentEnemy = enemy;
                              appState.route = Routes.gameReadyToStart;
                            },
                            icon: const Icon(Icons.play_circle_outline_rounded),
                            label: const Text("Spielen"),
                          ),
                        )
                      else
                        // if player has to wait for the enemy to play.
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              appState.currentEnemy = enemy;
                              appState.route = Routes.gameReadyToStart;
                            },
                            icon:
                                const Icon(Icons.pause_circle_outline_rounded),
                            label: const Text("Du bist nicht dran."),
                          ),
                        ),
                      if (enemy.openGame!.withTimer)
                        const Icon(Icons.timer)
                      else
                        const Icon(Icons.timer_off),
                      Text(
                          "${enemy.openGame!.playerAnswers.length.toString()} von 9")
                    ],
                  )
                else if (enemy.acceptedByPlayer && enemy.acceptedByOther)
                  // if there is no open game.
                  StartGameButton(appState: appState, enemy: enemy)
                else if (!enemy.acceptedByOther && !enemy.acceptedByPlayer)
                  // if the enemy has not accepted, we can send a request.
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => onTapped(enemy),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Anfragen"),
                    ),
                  )
                else if (enemy.acceptedByOther && !enemy.acceptedByPlayer)
                  // else it is a request which we can accept.
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => onTapped(enemy),
                      icon: const Icon(Icons.check_circle),
                      label: const Text("Annehmen"),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
