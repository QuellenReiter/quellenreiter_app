import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
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
    List<Widget> enemyCards = [];
    // create list of enemy cards
    // if requests exist
    if (widget.appState.enemyRequests != null &&
        widget.appState.enemyRequests!.enemies.isNotEmpty) {
      // add the heading
      enemyCards.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_alt_rounded,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "Neue Anfragen",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.enemyRequests!.enemies) {
        enemyCards.add(EnemyCard(
          appState: widget.appState,
          enemy: e,
          onTapped: (enemy) => widget.appState.acceptRequest(enemy),
        ));
      }
      enemyCards.add(
        const Divider(
          indent: 15,
          endIndent: 15,
          color: DesignColors.backgroundBlue,
        ),
      );
    }
    // add all current friends
    if (widget.appState.player!.friends != null &&
        widget.appState.player!.friends!.enemies.isNotEmpty) {
      int i = 1;
      bool playerAdded = false;
      for (Enemy e in widget.appState.player!.friends!.enemies
        ..sort((a, b) => b.getXp().compareTo(a.getXp()))) {
        if (!playerAdded && widget.appState.player!.getXp() > e.getXp()) {
          enemyCards.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("$i.",
                        style: Theme.of(context).textTheme.headline2)),
                Flexible(
                  child: EnemyCard(
                    appState: widget.appState,
                    enemy: widget.appState.player!,
                    onTapped: (enemy) => {},
                  ),
                ),
              ],
            ),
          );
          i++;
          playerAdded = true;
        }
        enemyCards.add(
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child:
                    Text("$i.", style: Theme.of(context).textTheme.headline2)),
            Flexible(
              child: EnemyCard(
                appState: widget.appState,
                enemy: e,
                onTapped: (enemy) => {},
              ),
            ),
          ]),
        );
        i++;
      }
      if (!playerAdded) {
        enemyCards.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("$i.",
                      style: Theme.of(context).textTheme.headline2)),
              Flexible(
                child: EnemyCard(
                  appState: widget.appState,
                  enemy: widget.appState.player!,
                  onTapped: (enemy) => {},
                ),
              ),
            ],
          ),
        );
        playerAdded = true;
      }
    }

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
                  child: ListView(
                    children: enemyCards,
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
