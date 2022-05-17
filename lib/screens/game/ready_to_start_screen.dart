import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

class ReadyToStartScreen extends StatefulWidget {
  const ReadyToStartScreen({Key? key, required this.appState})
      : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<ReadyToStartScreen> createState() => _ReadyToStartScreenState();
}

class _ReadyToStartScreenState extends State<ReadyToStartScreen> {
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Bottom button:
            if (widget.appState.currentEnemy == null ||
                widget.appState.currentEnemy!.openGame == null)
              const Text("Fehler.")
            else if (widget.appState.currentEnemy!.openGame!.isPlayersTurn())
              if (widget.appState.currentEnemy!.openGame!.playerAnswers.isEmpty)
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Spielen"),
                    onPressed: () {},
                  ),
                )
              else
                Flexible(
                  child: ElevatedButton(
                    child: const Text("Weiter spielen"),
                    onPressed: () {},
                  ),
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
