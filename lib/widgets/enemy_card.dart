import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';
import '../models/player.dart';
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
  final dynamic enemy;
  final QuellenreiterAppState appState;

  /// Stores if user tapped on this [EnemyCard] and notifies the navigation.
  final ValueChanged<Enemy> onTapped;
  @override
  Widget build(BuildContext context) {
    dynamic onClickFunk;
    String label = "";

    if (enemy.runtimeType == Player ||
        (enemy.runtimeType == Enemy) &&
            (enemy.acceptedByOther == false &&
                enemy.acceptedByPlayer == true)) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          elevation: 5,
          color: enemy.runtimeType == Enemy
              ? DesignColors.lightPink
              : DesignColors.lightBlue,

          // Make it clickable.
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 50, right: 20),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                  enemy.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.workspace_premium_rounded,
                                    color: DesignColors.yellow,
                                    size: 24,
                                  ),
                                ),
                                Countup(
                                  begin: 0,
                                  end: enemy.getLevel().toDouble(),
                                  duration: const Duration(milliseconds: 500),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: DesignColors.yellow),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
              IgnorePointer(
                child: FractionallySizedBox(
                  widthFactor:
                      MediaQuery.of(context).size.aspectRatio > (9 / 16)
                          ? 1.06
                          : 1.1,
                  child: Text(
                    enemy.emoji,
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 60),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (enemy.openGame == null) {
      if (enemy.acceptedByPlayer && enemy.acceptedByOther) {
        label = "Spiel starten";
        onClickFunk = () => showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              builder: (BuildContext context) {
                HapticFeedback.mediumImpact();
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    constraints: const BoxConstraints(
                      maxWidth: 700,
                    ),
                    child: SafeArea(
                      child: AnimationLimiter(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 500),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 20.0,
                              curve: Curves.elasticOut,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              const Icon(Icons.sports_esports,
                                  size: 100, color: DesignColors.pink),
                              SelectableText("Wie möchtest du spielen?",
                                  style: Theme.of(context).textTheme.headline2),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        appState.startNewGame(enemy, true),
                                    icon: Icon(Icons.alarm),
                                    label: Text(
                                      "Mit Timer",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () =>
                                        appState.startNewGame(enemy, false),
                                    icon: Icon(Icons.alarm_off),
                                    label: Text(
                                      "ohne Timer",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
      } else if (!enemy.acceptedByOther && !enemy.acceptedByPlayer) {
        onClickFunk = () => onTapped(enemy);
        label = "Anfrage senden";
      } else if (enemy.acceptedByOther && !enemy.acceptedByPlayer) {
        onClickFunk = () {
          HapticFeedback.mediumImpact();

          appState.acceptRequest(enemy);
        };
        label = "Anfrage annehmen";
      }
    } else if (enemy.openGame!.isPlayersTurn() &&
        enemy.openGame!.playerAnswers.isNotEmpty) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Du bist dran";
    } else if (enemy.openGame!.isPlayersTurn() &&
        enemy.openGame!.playerAnswers.isEmpty) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Du bist dran";
    } else if (enemy.openGame!.gameFinished() &&
        enemy.openGame!.requestingPlayerIndex != enemy.openGame!.playerIndex) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Punkte abholen";
    } else if (enemy.openGame!.gameFinished() &&
        enemy.openGame!.requestingPlayerIndex == enemy.openGame!.playerIndex) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Ergebnisse ansehen.";
    }
    // if enemy has to access its points

    else {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.currentEnemy = enemy;
        appState.route = Routes.gameReadyToStart;
      };
      label = "${enemy.name} spielt...";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        elevation: 5,
        color: DesignColors.pink,

        // Make it clickable.
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              hoverColor: DesignColors.lightBlue,
              highlightColor: DesignColors.lightBlue,
              splashColor: DesignColors.backgroundBlue,
              onTap: onClickFunk,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    border: Border.all(
                      color: label == "Du bist dran"
                          ? DesignColors.yellow
                          : DesignColors.pink,
                      width: 3,
                      style: BorderStyle.solid,
                    )),
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 50, right: 20),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                                  enemy.name,
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Icon(
                                    Icons.workspace_premium_rounded,
                                    color: DesignColors.yellow,
                                    size: 24,
                                  ),
                                ),
                                Countup(
                                  begin: 0,
                                  end: enemy.getLevel().toDouble(),
                                  duration: const Duration(milliseconds: 500),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: DesignColors.yellow),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                              child: Text(
                            label,
                            style: Theme.of(context).textTheme.subtitle1,
                          ))
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 50,
                        color: Colors.white,
                      )
                    ]),
              ),
            ),
            if (label == "Punkte abholen")
              // show open points badge
              Positioned(
                top: -10,
                right: -5,
                child: Container(
                  clipBehavior: Clip.none,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: DesignColors.yellow,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded,
                          color: DesignColors.pink),
                      Text(
                        "+${enemy.openGame!.getPlayerXp()}",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: DesignColors.pink),
                      ),
                    ],
                  ),
                ),
              ),
            if (label == "Anfrage senden")
              // show open points badge
              Positioned(
                top: -10,
                right: -5,
                child: Container(
                  clipBehavior: Clip.none,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: DesignColors.yellow,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded,
                          color: DesignColors.pink),
                      Text(
                        "+10",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: DesignColors.pink),
                      ),
                    ],
                  ),
                ),
              ),
            if (label == "Anfrage annehmen")
              // show open points badge
              Positioned(
                top: -10,
                right: -5,
                child: Container(
                  clipBehavior: Clip.none,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: DesignColors.yellow,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on_rounded,
                          color: DesignColors.pink),
                      Text(
                        "+10",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: DesignColors.pink),
                      ),
                    ],
                  ),
                ),
              ),
            IgnorePointer(
              child: FractionallySizedBox(
                widthFactor: MediaQuery.of(context).size.aspectRatio > (9 / 16)
                    ? 1.06
                    : 1.1,
                child: Text(
                  enemy.emoji,
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
