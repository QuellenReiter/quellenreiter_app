import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../models/enemy.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({Key? key, required this.appState, required this.enemy})
      : super(key: key);
  final QuellenreiterAppState appState;
  final Enemy enemy;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
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
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                        onPressed: () => Navigator.of(context).pop(context),
                      ),
                    ),
                    SelectableText("Wie möchtest du spielen?",
                        style: Theme.of(context).textTheme.subtitle1),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => appState.startNewGame(enemy, true),
                            child: Text(
                              "Mit Timer",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                appState.startNewGame(enemy, false),
                            child: Text(
                              "ohne Timer",
                              style: Theme.of(context).textTheme.subtitle1,
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
      label: const Text("Herausfordern"),
    );
  }
}
