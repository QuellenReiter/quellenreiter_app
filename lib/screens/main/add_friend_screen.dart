import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/opponent_card.dart';
import 'package:quellenreiter_app/widgets/stats_app_bar.dart';
import 'package:quellenreiter_app/widgets/title_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utilities/utilities.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  late TextEditingController searchController;

  /// Initialize [searchController] to query value, if it exists. If not,
  /// inittialize with default constructor.
  /// Add listener [widget.onQueryChanged]
  @override
  void initState() {
    searchController = widget.appState.friendsQuery == null
        ? TextEditingController()
        : TextEditingController(text: widget.appState.friendsQuery);
    super.initState();
  }

  @override
  void dispose() {
    widget.appState.resetSearchResults();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: StatsAppBar(appState: widget.appState),
        body: Center(
          child: Stack(
            children: [
              AnimationLimiter(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 700),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      horizontalOffset: 20.0,
                      curve: Curves.elasticOut,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.group_rounded,
                              color: DesignColors.backgroundBlue,
                              size: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .fontSize! +
                                  10,
                            ),
                            Text(
                              "freund:innen suchen",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: TextField(
                                style: Theme.of(context).textTheme.headline6,
                                textInputAction: TextInputAction.search,
                                inputFormatters: [
                                  UsernameTextFormatter(),
                                  FilteringTextInputFormatter.allow(
                                      Utils.regexUsername),
                                ],
                                onSubmitted: (query) {
                                  HapticFeedback.selectionClick();
                                  widget.appState.friendsQuery =
                                      searchController.text.trim();
                                },
                                controller: searchController,
                                decoration: const InputDecoration(
                                  hintText: "Gib den genauen Username ein",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.transparent,
                                  contentPadding: EdgeInsets.all(10),
                                ),
                              ),
                            ),
                            IconButton(
                              color: DesignColors.backgroundBlue,
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                widget.appState.friendsQuery =
                                    searchController.text.trim();
                              },
                              icon: const Icon(
                                Icons.search,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.appState.friendsSearchResult != null &&
                          widget.appState.friendsSearchResult!.opponents
                              .isNotEmpty)
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            keyboardDismissBehavior:
                                ScrollViewKeyboardDismissBehavior.onDrag,
                            itemCount: widget
                                .appState.friendsSearchResult!.opponents.length,
                            itemBuilder: (BuildContext context, int index) {
                              return OpponentCard(
                                appState: widget.appState,
                                opponent: widget.appState.friendsSearchResult!
                                    .opponents[index],
                                onTapped: widget.appState.sendFriendRequest,
                              );
                            },
                          ),
                        )
                      else if (widget.appState.friendsSearchResult != null)
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                                child: Text("Keine Ergebnisse gefunden",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            color: DesignColors.lightBlue)))),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      ClipPath(
                        clipper: DiagonalClipper(),
                        child: Container(
                          color: DesignColors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: FloatingActionButton.extended(
                    onPressed: () => {
                      Share.share(
                          'Quiz-Duell nur mit "Fake News":\nhttps://quellenreiter.app',
                          subject: "Teile die app mit deinen Freund:innen"),
                    },
                    icon: const Icon(Icons.share),
                    label: Text(
                      "Freund:innen einladen",
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
