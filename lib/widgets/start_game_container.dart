import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/opponent.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';

/// This widget displays an interface to start a new game and select the mode.
///
/// [appState] is the current state of the app.
/// [opponent] is the opponent to play against.
class StartGameContainer extends StatelessWidget {
  const StartGameContainer(
      {Key? key, required this.appState, required this.opponent})
      : super(key: key);
  final QuellenreiterAppState appState;
  final Opponent opponent;
  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => appState.startNewGame(opponent, true),
                  icon: const Icon(Icons.alarm),
                  label: Text(
                    "Mit Timer",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => appState.startNewGame(opponent, false),
                  icon: const Icon(Icons.alarm_off),
                  label: Text(
                    "ohne Timer",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
