import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/models/player_relation.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/start_game_container.dart';

import '../constants/constants.dart';
import '../models/player.dart';
import 'custom_bottom_sheet.dart';

/// Brief information display of a single [Player].
class OpponentCard extends StatelessWidget {
  const OpponentCard(
      {Key? key,
      required this.onTapped,
      required this.appState,
      this.playerRelation,
      this.player})
      : super(key: key);

  /// The [PlayerRelation] to be displayed.
  final PlayerRelation? playerRelation;
  final QuellenreiterAppState appState;

  /// The [Player] to be displayed.
  final Player? player;

  /// Stores if user tapped on this [OpponentCard] and notifies the navigation.
  final ValueChanged<PlayerRelation> onTapped;
  @override
  Widget build(BuildContext context) {
    dynamic onClickFunk;
    String label = "";

    if (playerRelation == null && player == null) {
      return const SizedBox.shrink();
    }
    // if we got a player or if this is a requested friendship.
    if (player != null ||
        (playerRelation != null &&
            (playerRelation!.relationState == RelationState.sent))) {
      var _emoji =
          player != null ? player!.emoji : playerRelation!.opponent.emoji;
      var _name = player != null ? player!.name : playerRelation!.opponent.name;
      var _level = player != null
          ? player!.getLevel()
          : playerRelation!.opponent.getLevel();
      return Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          elevation: 5,
          color: playerRelation != null
              ? DesignColors.lightPink
              : DesignColors.lightBlue,

          // Make it clickable.
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                  _name,
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
                                  end: _level.toDouble(),
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
                    _emoji,
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

    if (playerRelation!.openGame == null) {
      if (playerRelation!.relationState == RelationState.friend) {
        label = "Spiel starten";
        onClickFunk = () => CustomBottomSheet.showCustomBottomSheet(
              context: context,
              scrollable: false,
              child: StartGameContainer(
                  appState: appState, playerRelation: playerRelation!),
            );
      } else if (playerRelation!.relationState == RelationState.random) {
        onClickFunk = () => onTapped(playerRelation!);
        label = "Anfrage senden";
      } else if (playerRelation!.relationState == RelationState.received) {
        onClickFunk = () {
          HapticFeedback.mediumImpact();

          appState.acceptRequest(playerRelation!);
        };
        label = "Anfrage annehmen";
      }
    }
    // possible to start game and to view old results.
    else if (playerRelation!.openGame!.pointsAccessed) {
      label = "Ergebnisse ansehen oder neues Spiel";
      onClickFunk = () {
        HapticFeedback.mediumImpact();
        appState.focusedPlayerRelation = playerRelation;
        appState.route = Routes.gameReadyToStart;
      };
    }
    // show results and continue playing button
    else if (playerRelation!.openGame!.isPlayersTurn() &&
        playerRelation!.openGame!.player.answers.isNotEmpty) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.focusedPlayerRelation = playerRelation;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Du bist dran";
    }
    // game starts immediately, because there are no results yet
    else if (playerRelation!.openGame!.isPlayersTurn() &&
        playerRelation!.openGame!.player.answers.isEmpty) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.focusedPlayerRelation = playerRelation;
        appState.playGame();
      };
      label = "Du bist dran";
    }
    // player can access points, other player has already accessed them
    else if (playerRelation!.openGame!.gameFinished() &&
        playerRelation!.openGame!.requestingPlayerIndex !=
            playerRelation!.openGame!.playerIndex) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.focusedPlayerRelation = playerRelation;
        appState.route = Routes.gameFinishedScreen;
      };
      label = "Punkte abholen";
    }
    // player has already accessed points and can view results
    else if (playerRelation!.openGame!.gameFinished() &&
        playerRelation!.openGame!.requestingPlayerIndex ==
            playerRelation!.openGame!.playerIndex) {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.focusedPlayerRelation = playerRelation;
        appState.route = Routes.gameReadyToStart;
      };
      label = "Ergebnisse ansehen";
    }
    // if opponent is playing
    else {
      onClickFunk = () {
        HapticFeedback.mediumImpact();

        appState.focusedPlayerRelation = playerRelation;
        appState.route = Routes.gameReadyToStart;
      };
      label = "${playerRelation!.opponent.name} spielt...";
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            hoverColor: DesignColors.lightBlue,
            highlightColor: DesignColors.lightBlue,
            splashColor: DesignColors.backgroundBlue,
            onTap: onClickFunk,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              elevation: 5,
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: DesignColors.pink,
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
                      Flexible(
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
                                    playerRelation!.opponent.name,
                                    style:
                                        Theme.of(context).textTheme.headline4,
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
                                    end: playerRelation!.opponent
                                        .getLevel()
                                        .toDouble(),
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
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 50,
                        color: Colors.white,
                      )
                    ]),
              ),
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
                      "+${playerRelation!.openGame!.getPlayerXp()}",
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
                playerRelation!.opponent.emoji,
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
