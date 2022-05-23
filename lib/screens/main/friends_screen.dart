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
                const CircularProgressIndicator()
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      itemCount:
                          widget.appState.player!.friends!.enemies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return EnemyCard(
                          appState: widget.appState,
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
        // Display all open Requests
        if (widget.appState.enemyRequests != null &&
            widget.appState.enemyRequests!.enemies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton.extended(
                onPressed: () => {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
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
                                itemBuilder: (BuildContext context, int index) {
                                  return EnemyCard(
                                    appState: widget.appState,
                                    enemy: widget
                                        .appState.enemyRequests!.enemies[index],
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
