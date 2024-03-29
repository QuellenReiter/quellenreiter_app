import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/player_relation.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/opponent_card.dart';
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
    List<Widget> opponentCards = [];
    // create list of opponent cards
    // if requests exist

    // list of sent and pending requests
    List<Widget> sentRequestsWidgets = [];

    List<PlayerRelation> sentFriendRequests =
        widget.appState.playerRelations.sent;

    if (sentFriendRequests.isNotEmpty) {
      sentRequestsWidgets.add(
        const Divider(
          indent: 15,
          endIndent: 15,
          color: DesignColors.backgroundBlue,
        ),
      );
      // add the heading
      sentRequestsWidgets.add(
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
      for (PlayerRelation opp in sentFriendRequests) {
        sentRequestsWidgets.add(OpponentCard(
          appState: widget.appState,
          playerRelation: opp,
          onTapped: (opponent) {},
        ));
      }
    }

    List<PlayerRelation> friends = widget.appState.playerRelations.friends;
    // add all current friends
    if (friends.isNotEmpty) {
      opponentCards.addAll([
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
      for (PlayerRelation opp in friends
        ..sort((a, b) => b.getXp().compareTo(a.getXp()))) {
        if (!playerAdded && widget.appState.player!.getXp() > opp.getXp()) {
          opponentCards.add(
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("$i.",
                        style: Theme.of(context).textTheme.headline2)),
                Flexible(
                  child: widget.appState.player!.getPlayerCard(widget.appState),
                ),
              ],
            ),
          );
          i++;
          playerAdded = true;
        }
        opponentCards.add(
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(left: 10),
                child:
                    Text("$i.", style: Theme.of(context).textTheme.headline2)),
            Flexible(
              child: OpponentCard(
                appState: widget.appState,
                playerRelation: opp,
                onTapped: (opponent) => {},
              ),
            ),
          ]),
        );
        i++;
      }
      if (!playerAdded) {
        opponentCards.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("$i.",
                      style: Theme.of(context).textTheme.headline2)),
              Flexible(
                child: OpponentCard(
                  appState: widget.appState,
                  player: widget.appState.player!,
                  onTapped: (opponent) => {},
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
              onRefresh: widget.appState.getPlayerRelations,
              child: ListView(
                primary: false,
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: [
                  // display button if user has no friends yet.
                  if (friends.isEmpty)
                    Column(
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
                              subject: "Teile die app mit deinen Freund:innen",
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
                        const SizedBox(
                          height: 50,
                        ),
                        ...sentRequestsWidgets
                      ],
                    )
                  else
                    // display current friends
                    AnimationLimiter(
                      child: Column(
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
                            ...opponentCards,
                            ...sentRequestsWidgets,
                          ],
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
