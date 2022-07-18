import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

    // list of sent and pending requests
    List<Widget> pendingRequests = [];
    if (widget.appState.pendingRequests != null &&
        widget.appState.pendingRequests!.enemies.isNotEmpty) {
      pendingRequests.add(
        const Divider(
          indent: 15,
          endIndent: 15,
          color: DesignColors.backgroundBlue,
        ),
      );
      // add the heading
      pendingRequests.add(
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.watch_later_outlined,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "Versendete anfragen",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      );
      for (Enemy e in widget.appState.pendingRequests!.enemies) {
        pendingRequests.add(EnemyCard(
          appState: widget.appState,
          enemy: e,
          onTapped: (e) {},
        ));
      }
    }
    // add all current friends
    if (widget.appState.player!.friends != null &&
        widget.appState.player!.friends!.enemies.isNotEmpty) {
      enemyCards.addAll([
        Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.insights_rounded,
                color: DesignColors.backgroundBlue,
                size: Theme.of(context).textTheme.headline2!.fontSize! + 10,
              ),
              Text(
                "Bestenliste",
                style: Theme.of(context).textTheme.headline2,
              ),
            ],
          ),
        ),
      ]);
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

    return AnimationLimiter(
      child: Stack(
        alignment: Alignment.topCenter,
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 400),
          childAnimationBuilder: (widget) => SlideAnimation(
            horizontalOffset: 20.0,
            curve: Curves.elasticOut,
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: [
            RefreshIndicator(
              onRefresh: widget.appState.getFriends,
              child: Column(
                children: [
                  if (widget.appState.player?.friends == null)
                    const Center(child: CircularProgressIndicator())
                  // display button if user has no friends yet.
                  else if (widget.appState.player!.friends!.enemies.isEmpty &&
                      (widget.appState.enemyRequests == null ||
                          widget.appState.enemyRequests!.enemies.isEmpty))
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();

                              Share.share(
                                'Quiz-Duell nur mit "Fake News":\nhttps://quellenreiter.app',
                                subject:
                                    "Teile die app mit deinen Freund:innen.",
                              );
                            },
                            icon: const Icon(Icons.send_rounded),
                            label: Text(
                              "Freund:innen einladen",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              HapticFeedback.mediumImpact();
                              widget.appState.route = Routes.addFriends;
                            },
                            icon: const Icon(Icons.search),
                            label: Text(
                              "Freunde finden",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // display current friends
                    Flexible(
                      child: AnimationLimiter(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 300),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 20.0,
                              curve: Curves.elasticOut,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              ...enemyCards,
                              ...pendingRequests,
                            ],
                          ),
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
                  onPressed: () => {
                    widget.appState.handleNavigationChange(Routes.addFriends)
                  },
                  child: const Icon(Icons.group_add),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
