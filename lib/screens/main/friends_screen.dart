import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';

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
              // Display all open Requests
              if (widget.appState.enemyRequests != null &&
                  widget.appState.enemyRequests!.enemies.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Offene Anfragen:"),
                              ),
                              Flexible(
                                child: ListView.builder(
                                  itemCount: widget
                                      .appState.enemyRequests!.enemies.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return EnemyCard(
                                      enemy: widget.appState.enemyRequests!
                                          .enemies[index],
                                      onTapped: (enemy) =>
                                          widget.appState.acceptRequest(enemy),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text("Offene Anfragen"),
                ),

              // display button if user has no friends yet.
              if (widget.appState.player?.friends == null ||
                  widget.appState.player!.friends!.enemies.isEmpty)
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => {},
                        icon: const Icon(Icons.send_rounded),
                        label: const Text("Freunde einladen"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => {},
                        icon: const Icon(Icons.search),
                        label: const Text("Freunde finden"),
                      ),
                    ],
                  ),
                )
              else
                // display current friends
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount:
                          widget.appState.player!.friends!.enemies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EnemyCard(
                          enemy:
                              widget.appState.player!.friends!.enemies[index],
                          onTapped: (enemy) => {},
                        );
                      },
                    ),
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
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}
