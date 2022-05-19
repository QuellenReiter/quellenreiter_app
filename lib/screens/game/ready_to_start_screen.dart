import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/start_game_button.dart';

class ReadyToStartScreen extends StatefulWidget {
  const ReadyToStartScreen({Key? key, required this.appState})
      : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<ReadyToStartScreen> createState() => _ReadyToStartScreenState();
}

class _ReadyToStartScreenState extends State<ReadyToStartScreen> {
  var greyCircle = const Padding(
    padding: EdgeInsets.all(10),
    child: CircleAvatar(
      backgroundColor: DesignColors.black,
    ),
  );
  List<Widget> enemyAnswerVisuals = [];
  List<Widget> playerAnswerVisuals = [];
  int commonLength = 0;

  @override
  void initState() {
    commonLength = min(
        widget.appState.currentEnemy!.openGame!.playerAnswers.length,
        widget.appState.currentEnemy!.openGame!.enemyAnswers.length);

    enemyAnswerVisuals.addAll([
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle
    ]);
    playerAnswerVisuals.addAll([
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle,
      greyCircle
    ]);
    for (int i = 0;
        i < widget.appState.currentEnemy!.openGame!.playerAnswers.length;
        i++) {
      playerAnswerVisuals[i] = Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          foregroundColor: DesignColors.pink,
          backgroundColor:
              widget.appState.currentEnemy!.openGame!.playerAnswers[i] == true
                  ? DesignColors.green
                  : DesignColors.red,
        ),
      );

      if (i > commonLength - 1) {
        continue;
      }
      enemyAnswerVisuals[i] = Padding(
        padding: const EdgeInsets.all(10),
        child: CircleAvatar(
          backgroundColor: widget.appState.currentEnemy!.openGame!.enemyAnswers
                      .sublist(0, commonLength)[i] ==
                  true
              ? DesignColors.green
              : DesignColors.red,
        ),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spielen"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // heading
            Text("Spiel"),
            // user and enemy
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.appState.player!.emoji),
                        Text(widget.appState.player!.name),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                children: playerAnswerVisuals),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(widget.appState.currentEnemy!.emoji),
                        Text(widget.appState.currentEnemy!.name),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: enemyAnswerVisuals,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Text("Punktestand:"),
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(widget.appState.currentEnemy!.openGame!.playerAnswers
                      .fold<int>(0, (p, c) => p + (c ? 1 : 0))
                      .toString()),
                  Text(":"),
                  Text(widget.appState.currentEnemy!.openGame!.enemyAnswers
                      .sublist(0, commonLength)
                      .fold<int>(0, (p, c) => p + (c ? 1 : 0))
                      .toString())
                ],
              ),
            ),
            // Bottom button:
            // if error
            if (widget.appState.currentEnemy == null ||
                widget.appState.currentEnemy!.openGame == null)
              const Text("Fehler.")
            //if is players turn
            else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
              // if not played any quests
              if (widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Spielen"),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                )
              // if already played in this game
              else
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Weiter spielen"),
                    onPressed: () => {widget.appState.playGame()},
                  ),
                )
            else if (widget.appState.currentEnemy!.openGame!.gameFinished())
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Das spiel ist beendet."),
                  Flexible(
                    child: StartGameButton(
                      appState: widget.appState,
                      enemy: widget.appState.currentEnemy!,
                    ),
                  )
                ],
              )
            else
              Flexible(
                child: ElevatedButton(
                  child: Text(
                      "Warten, bis ${widget.appState.currentEnemy!.name} gespielt hat."),
                  onPressed: null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
