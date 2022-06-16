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
    dynamic onClickFunk;
    Widget label;
    if (enemy.openGame!.isPlayersTurn() &&
        enemy.openGame!.playerAnswers.isNotEmpty) {
      onClickFunk = () {
        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = Text("Du bist dran");
    } else if (enemy.openGame!.isPlayersTurn() &&
        enemy.openGame!.playerAnswers.isEmpty) {
      onClickFunk = () {
        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = Text("Du bist dran");
    } else if (enemy.openGame!.gameFinished() &&
        enemy.openGame!.requestingPlayerIndex != enemy.openGame!.playerIndex) {
      onClickFunk = () {
        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = Text("Punkte abholen");
    } else if (enemy.openGame!.gameFinished() &&
        enemy.openGame!.requestingPlayerIndex == enemy.openGame!.playerIndex) {
      onClickFunk = () {
        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = Text("Ergebnisse ansehen.");
    }
    // if enemy has to access its points

    else {
      onClickFunk = () {
        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = Text("${enemy.name} spielt...");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: DesignColors.pink,
        // Make it clickable.
        child: InkWell(
          hoverColor: DesignColors.lightBlue,
          highlightColor: DesignColors.lightBlue,
          splashColor: DesignColors.backgroundBlue,
          onTap: onClickFunk,
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
                          style: Theme.of(context).textTheme.headline4,
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
                              icon:
                                  const Icon(Icons.play_circle_outline_rounded),
                              label: label,
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
