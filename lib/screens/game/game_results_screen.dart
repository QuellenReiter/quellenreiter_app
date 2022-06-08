import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../../constants/constants.dart';
import '../../widgets/statement_card.dart';

class GameResultsScreen extends StatefulWidget {
  const GameResultsScreen(
      {Key? key, required this.appState, required this.showAll})
      : super(key: key);
  final bool showAll;
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
      bottomSheet: widget.appState.db.error != null
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(children: [
                Text(widget.appState.db.error!),
                ElevatedButton(
                    onPressed: widget.appState.db.error = null,
                    child: Text("ok"))
              ]),
            )
          : null,
      body: widget.appState.currentEnemy!.openGame!.statements == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: widget.showAll
                  ? widget.appState.currentEnemy!.openGame!.playerAnswers.length
                  : 3,
              itemBuilder: (BuildContext context, int index) {
                if (!widget.showAll) {
                  // if not all shown, show last three in correct order
                  index = widget.appState.currentEnemy!.openGame!.playerAnswers
                          .length -
                      3 +
                      index;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Runde 1",
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    if (index == 3)
                      Text(
                        "Runde 2",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    if (index == 6)
                      Text(
                        "Runde 3",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    StatementCard(
                      statement: widget.appState.currentEnemy!.openGame!
                          .statements!.statements[index],
                      appState: widget.appState,
                    ),
                  ],
                );
              },
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("weiter"),
        icon: const Icon(Icons.forward),
        onPressed: () => widget.appState.route = Routes.gameReadyToStart,
      ),
    );
  }
}
