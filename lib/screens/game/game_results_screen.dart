import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../constants/constants.dart';
import '../../widgets/statement_card.dart';

class GameResultsScreen extends StatefulWidget {
  const GameResultsScreen({Key? key, required this.appState}) : super(key: key);

  final QuellenreiterAppState appState;
  @override
  State<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen> {
  @override
  Widget build(BuildContext context) {
    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      widget.appState.getCurrentStatements();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faktenchecks"),
      ),
      body: widget.appState.currentEnemy!.openGame!.statements == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ListView.builder(
                itemCount: widget
                    .appState.currentEnemy!.openGame!.playerAnswers.length,
                itemBuilder: (BuildContext context, int index) {
                  return StatementCard(
                    statement: widget.appState.currentEnemy!.openGame!
                        .statements!.statements[index],
                  );
                },
              ),
            ),
      bottomSheet: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 20, right: 20),
            child: TextButton(
              child: const Text("weiter"),
              onPressed: () => widget.appState.route = Routes.gameReadyToStart,
            ),
          ),
        ],
      ),
    );
  }
}
