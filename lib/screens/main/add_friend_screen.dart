import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';
import 'package:quellenreiter_app/widgets/title_app_bar.dart';
import 'package:share_plus/share_plus.dart';

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
    return Scaffold(
      appBar: TitleAppBar(
        title: "Freund:innen finden",
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyText2,
                          textInputAction: TextInputAction.search,
                          inputFormatters: [
                            UsernameTextFormatter(),
                            FilteringTextInputFormatter.allow(
                                Utils.regexUsername),
                          ],
                          onSubmitted: (query) =>
                              {widget.appState.friendsQuery = query.trim()},
                          controller: searchController,
                          decoration: const InputDecoration(
                            hintText: "Username eingeben...",
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
                if (widget.appState.friendsSearchResult != null)
                  Flexible(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: AnimationLimiter(
                        child: ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: widget
                              .appState.friendsSearchResult!.enemies.length,
                          itemBuilder: (BuildContext context, int index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                horizontalOffset: 30,
                                child: FadeInAnimation(
                                  child: EnemyCard(
                                    appState: widget.appState,
                                    enemy: widget.appState.friendsSearchResult!
                                        .enemies[index],
                                    onTapped: widget.appState.sendFriendRequest,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: FloatingActionButton.extended(
                  onPressed: () => {
                    Share.share("https://quellenreiter.app",
                        subject: "Teile die app mit deinen Freund:innen."),
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Freund:innen einladen"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
