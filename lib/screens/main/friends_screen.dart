import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/constants.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key, required this.appState}) : super(key: key);

  /// The query used to search for friends.
  final QuellenreiterAppState appState;
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        RefreshIndicator(
          onRefresh: widget.appState.getFriends,
          child: Column(
            children: [
              if (widget.appState.player?.friends == null)
                const Center(child: CircularProgressIndicator())
              // display button if user has no friends yet.
              else if (widget.appState.player!.friends!.enemies.isEmpty)
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => {
                          Share.share("https://quellenreiter.app",
                              subject:
                                  "Teile die app mit deinen Freund:innen."),
                        },
                        icon: const Icon(Icons.send_rounded),
                        label: const Text("Freunde einladen"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () =>
                            {widget.appState.route = Routes.addFriends},
                        icon: const Icon(Icons.search),
                        label: const Text("Freunde finden"),
                      ),
                    ],
                  ),
                )
              else
                // display current friends
                Flexible(
                  child: ListView.builder(
                    itemCount: widget.appState.player!.friends!.enemies.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // Display all open Requests
                        if (widget.appState.enemyRequests != null &&
                            widget.appState.enemyRequests!.enemies.isNotEmpty)
                          return Column(
                            children: [
                              Text(
                                "Neue Anfragen",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              Flexible(
                                child: ListView.builder(
                                  itemCount: widget
                                      .appState.enemyRequests!.enemies.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    return EnemyCard(
                                      appState: widget.appState,
                                      enemy: widget
                                          .appState.enemyRequests!.enemies[i],
                                      onTapped: (enemy) =>
                                          widget.appState.acceptRequest(enemy),
                                    );
                                  },
                                ),
                              ),
                              EnemyCard(
                                appState: widget.appState,
                                enemy: widget
                                    .appState.player!.friends!.enemies[index],
                                onTapped: (enemy) => {},
                              ),
                            ],
                          );
                      }
                      return EnemyCard(
                        appState: widget.appState,
                        enemy: widget.appState.player!.friends!.enemies[index],
                        onTapped: (enemy) => {},
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () =>
                  {widget.appState.handleNavigationChange(Routes.addFriends)},
              child: const Icon(Icons.group_add),
            ),
          ),
        ),
      ],
    );
  }
}
