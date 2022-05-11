import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/enemy_card.dart';
import 'package:share_plus/share_plus.dart';

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
    widget.appState.friendsQuery = null;
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Freund:in hinzufügen"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (query) =>
                                {widget.appState.friendsQuery = query.trim()},
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: "Gebe den exakten Namen ein.",
                              border: UnderlineInputBorder(
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
                      ),
                      // IconButton(
                      //   onPressed: () => {
                      //     widget.appState.friendsQuery = searchController.text
                      //   },
                      //   icon: const Icon(Icons.search),
                      // ),
                    ],
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
                                      enemy: widget.appState
                                          .friendsSearchResult!.enemies[index],
                                      onTapped:
                                          widget.appState.sendFriendRequest,
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
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: FloatingActionButton.extended(
                    onPressed: () => {
                      Share.share("https://quellenreiter.app",
                          subject: "Teile die app mit deinen Freund:innen."),
                    },
                    icon: const Icon(Icons.share),
                    label: Text("Teilen"),
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
