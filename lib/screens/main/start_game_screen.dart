import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/widgets/title_app_bar.dart';

import '../../constants/constants.dart';
import '../../widgets/enemy_card.dart';

class StartGameScreen extends StatefulWidget {
  const StartGameScreen({Key? key, required this.appState}) : super(key: key);
  final QuellenreiterAppState appState;
  @override
  State<StartGameScreen> createState() => _StartGameScreenState();
}

class _StartGameScreenState extends State<StartGameScreen> {
  @override
  Widget build(BuildContext context) {
    // Show error is there is one !
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.appState.showError(context);
    });
    if (widget.appState.player?.friends == null)
      return const Center(child: CircularProgressIndicator());
    // display button if user has no friends yet.
    List<Enemy> enemiesWithNoGame = widget.appState.player!.friends!.enemies
        .where((e) => e.openGame == null)
        .toList();
    return Scaffold(
      appBar: TitleAppBar(
        title: "Neues Spiel",
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (enemiesWithNoGame.isNotEmpty)
            Flexible(
              child: ListView.builder(
                itemCount: enemiesWithNoGame.length,
                itemBuilder: (BuildContext context, int index) {
                  return EnemyCard(
                    appState: widget.appState,
                    enemy: enemiesWithNoGame[index],
                    onTapped: (enemy) => {},
                  );
                },
              ),
            )
          else if (widget.appState.player!.friends!.enemies.isEmpty)
            Center(
              child: ElevatedButton.icon(
                onPressed: () => {widget.appState.route = Routes.addFriends},
                icon: const Icon(Icons.sports_esports),
                label: Text(
                  "Freund:innen einladen",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Du spielst aktuell gegen alle deine Freund:innen!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () => {widget.appState.route = Routes.addFriends},
                  icon: const Icon(Icons.person_add),
                  label: Text(
                    "Freund:innen einladen",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
