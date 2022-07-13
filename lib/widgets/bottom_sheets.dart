import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';
import '../models/enemy.dart';

class BottomSheets {
  static Future<void> showStartGameBottomSheet(
      BuildContext context, QuellenreiterAppState appState, Enemy enemy) async {
    return showModalBottomSheet<void>(
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
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => appState.startNewGame(enemy, true),
                            icon: Icon(Icons.alarm),
                            label: Text(
                              "Mit Timer",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () =>
                                appState.startNewGame(enemy, false),
                            icon: Icon(Icons.alarm_off),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
