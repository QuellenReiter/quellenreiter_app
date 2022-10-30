import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });

    if (widget.appState.currentEnemy!.openGame!.statements == null) {
      widget.appState.getCurrentStatements();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faktenchecks"),
      ),
      body: widget.appState.currentEnemy!.openGame!.statements == null
          ? const Center(child: CircularProgressIndicator())
          : AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: widget.showAll
                    ? widget
                        .appState.currentEnemy!.openGame!.player.answers.length
                    : 3,
                itemBuilder: (BuildContext context, int index) {
                  if (!widget.showAll) {
                    // if not all shown, show last three in correct order
                    index = widget.appState.currentEnemy!.openGame!
                            .player.answers.length -
                        3 +
                        index;
                  }
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      horizontalOffset: 20.0,
                      curve: Curves.elasticOut,
                      child: FadeInAnimation(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (index == 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  "Runde 1",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            if (index == 3)
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  "Runde 2",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            if (index == 6)
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  "Runde 3",
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                            StatementCard(
                              statement: widget.appState.currentEnemy!.openGame!
                                  .statements!.statements[index],
                              appState: widget.appState,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
