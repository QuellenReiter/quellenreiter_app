import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

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
                      enemy.openGame!.playerAnswers.isNotEmpty)
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
                        icon: const Icon(Icons.pause_circle_outline_rounded),
                        label: const Text("Du bist nicht dran."),
                      ),
                    )
                else if (enemy.acceptedByPlayer && enemy.acceptedByOther)
                  // if there is no open game.
                  Flexible(
                    child: ElevatedButton.icon(
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isDismissible: true,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 20, right: 20),
                                constraints: const BoxConstraints(
                                  maxWidth: 700,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: const Icon(Icons.close),
                                        iconSize: 20,
                                        onPressed: () =>
                                            Navigator.of(context).pop(context),
                                      ),
                                    ),
                                    SelectableText("Wie möchtest du spielen?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => appState
                                                .startNewGame(enemy, true),
                                            child: Text(
                                              "Mit Timer",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () => appState
                                                .startNewGame(enemy, false),
                                            child: Text(
                                              "ohne Timer",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      icon: const Icon(Icons.not_started),
                      label: const Text("neues Spiel starten"),
                    ),
                  )
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
