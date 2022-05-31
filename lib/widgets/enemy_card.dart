import 'package:countup/countup.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                      Text(
                        enemy.emoji,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          enemy.name,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      const Icon(
                        Icons.monetization_on,
                        color: DesignColors.yellow,
                        size: 16,
                      ),
                      Countup(
                        begin: 0,
                        end: enemy.getXp().toDouble(),
                        duration: const Duration(milliseconds: 500),
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
                // if an open Game exists.

                if (enemy.openGame != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // .. and if its the players turn
                          if (enemy.openGame!.isPlayersTurn() &&
                              enemy.openGame!.playerAnswers.isNotEmpty)
                            Flexible(
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      DesignColors.pink),
                                ),
                                onPressed: () {
                                  appState.currentEnemy = enemy;
                                  appState.route = Routes.gameReadyToStart;
                                },
                                icon: const Icon(
                                    Icons.play_circle_outline_rounded),
                                label: const Text("weiterspielen"),
                              ),
                            )
                          else if (enemy.openGame!.isPlayersTurn() &&
                              enemy.openGame!.playerAnswers.isEmpty)
                            Flexible(
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      DesignColors.pink),
                                ),
                                onPressed: () {
                                  appState.currentEnemy = enemy;
                                  appState.route = Routes.gameReadyToStart;
                                },
                                icon: const Icon(
                                    Icons.play_circle_outline_rounded),
                                label: const Text("Spielen"),
                              ),
                            )
                          else if (enemy.openGame!.gameFinished())
                            // if player has to wait for the enemy to play.
                            Flexible(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  appState.currentEnemy = enemy;
                                  appState.route = Routes.gameReadyToStart;
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      DesignColors.backgroundBlue),
                                ),
                                icon: const Icon(Icons.stop_circle),
                                label: const Text("Ergebnisse anzeigen"),
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
                                icon: const Icon(
                                    Icons.pause_circle_outline_rounded),
                                label: Text("${enemy.name} spielt..."),
                              ),
                            ),
                          if (enemy.openGame!.withTimer)
                            const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.timer))
                          else
                            const Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.timer_off)),
                          Text(
                              "${enemy.openGame!.playerAnswers.length.toString()} von 9 Fragen")
                        ],
                      )
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
