import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';
import 'package:quellenreiter_app/screens/auth/signup_screen.dart';
import 'package:quellenreiter_app/screens/game/game_finished_screen.dart';
import 'package:quellenreiter_app/screens/game/game_results_screen.dart';
import 'package:quellenreiter_app/screens/game/quest_screen.dart';
import 'package:quellenreiter_app/screens/game/ready_to_start_screen.dart';
import 'package:quellenreiter_app/screens/loading_screen.dart';
import 'package:quellenreiter_app/screens/main/add_friend_screen.dart';
import 'package:quellenreiter_app/screens/tutorial.dart';
import '../constants/constants.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main/home_screen.dart';

class QuellenreiterRouterDelegate extends RouterDelegate<QuellenreiterRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<QuellenreiterRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  late QuellenreiterAppState appState;

  QuellenreiterRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState = QuellenreiterAppState();
    appState.addListener(notifyListeners);
    // print(appState.route);
    // print('appState.addListener(notifyListeners) called');
  }
  @override
  QuellenreiterRoutePath get currentConfiguration {
    if (appState.route == Routes.addFriends && appState.friendsQuery != null) {
      return QuellenreiterRoutePath(appState.route,
          friendsQuery: appState.friendsQuery);
    }
    return QuellenreiterRoutePath(appState.route);
  }

  @override
  Widget build(BuildContext context) {
    // print(appState.route.toString());
    return Navigator(
      pages: buildPages(),
      // Define what happens on Navigator.pop() or back button.
      onPopPage: (route, result) {
        print('onPopPage called');
        if (!route.didPop(result)) {
          return false;
        }
        appState.friendsQuery = null;
        if (appState.route == Routes.signUp) {
          appState.route = Routes.login;
        } else if (appState.route == Routes.quest ||
            appState.route == Routes.gameFinishedScreen) {
          return false;
        } else {
          appState.route = Routes.home;
        }
        HapticFeedback.mediumImpact();
        notifyListeners();
        return true;
      },
    );
  }

  // @override
  // Future<bool> popRoute() async {
  //   // final NavigatorState? navigator = navigatorKey.currentState;
  //   if (appState.route == Routes.home || appState.route == Routes.login) {
  //     return false;
  //   }
  //   // if (appState.route == Routes.signUp) {
  //   //   appState.route = Routes.login;
  //   // } else if (appState.route == Routes.quest ||
  //   //     appState.route == Routes.gameFinishedScreen) {
  //   //   return true;
  //   // } else {
  //   //   appState.route = Routes.home;
  //   // }
  //   return true;
  // }

  List<Page> buildPages() {
    Page home = MaterialPage(
      key: const ValueKey('HomePage'),
      child: HomeScreen(
        appState: appState,
      ),
    );
    Page login = MaterialPage(
      key: const ValueKey('LoginPage'),
      child: LoginScreen(
        appState: appState,
      ),
    );
    switch (appState.route) {
      case Routes.loading:
        return [
          const MaterialPage(
            key: ValueKey('LoadingPage'),
            child: LoadingScreen(),
          ),
        ];
      case Routes.login:
        if (!appState.prefs.containsKey('tutorialPlayed')) {
          return [
            MaterialPage(
              key: const ValueKey('TutorialPage'),
              child: Turorial(
                appState: appState,
              ),
            ),
          ];
        }
        return [login];
      case Routes.signUp:
        return [
          login,
          MaterialPage(
            key: const ValueKey('SignupPage'),
            child: SignupScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.home:
        if (appState.friendsQuery != null) {
          return [
            home,
            MaterialPage(
              key: const ValueKey('AddFriendsPage'),
              child: AddFriendScreen(
                appState: appState,
              ),
            ),
          ];
        } else {
          return [home];
        }
      case Routes.addFriends:
        return [
          home,
          MaterialPage(
            key: const ValueKey('AddFriendsPage'),
            child: AddFriendScreen(
              appState: appState,
            ),
          ),
        ];

      case Routes.gameReadyToStart:

        // if player is not last one and game is finished, show points.
        if (appState.currentEnemy == null ||
            appState.currentEnemy!.openGame == null) {
          return [
            home,
          ];
        }
        if ((appState.currentEnemy != null &&
                !appState.currentEnemy!.openGame!.pointsAccessed) &&
            (appState.currentEnemy!.openGame!.gameFinished() &&
                appState.currentEnemy!.openGame!.requestingPlayerIndex !=
                    appState.currentEnemy!.openGame!.playerIndex)) {
          return [
            home,
            MaterialPage(
              key: const ValueKey('ReadyToStartScreen'),
              child: ReadyToStartScreen(
                appState: appState,
              ),
            ),
            MaterialPage(
              key: const ValueKey('GameFinishedScreen'),
              child: GameFinishedScreen(
                appState: appState,
              ),
            ),
          ];
        }
        if (appState.currentEnemy!.openGame!.playerAnswers.isEmpty &&
            appState.currentEnemy!.openGame!.isPlayersTurn()) {
          appState.playGame();
          return [
            const MaterialPage(
              key: ValueKey('LoadingScreen'),
              child: LoadingScreen(),
            ),
          ];
        }
        return [
          home,
          MaterialPage(
            key: const ValueKey('ReadyToStartScreen'),
            child: ReadyToStartScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.quest:
        if (appState.currentEnemy != null &&
            !appState.currentEnemy!.openGame!.isPlayersTurn()) {
          appState.db.sendPushOtherPlayersTurn(appState,
              receiverId: appState.currentEnemy!.userId);
          // appState.getFriends();
          return [
            home,
            MaterialPage(
              key: const ValueKey('ReadyToStartScreen'),
              child: ReadyToStartScreen(
                appState: appState,
                showOnlyLast: true,
              ),
            ),
          ];
        }
        return [
          MaterialPage(
            key: const ValueKey('QuestScreen'),
            child: QuestScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.gameFinishedScreen:
        return [
          home,
          MaterialPage(
            key: const ValueKey('GameResultsScreen'),
            child: GameResultsScreen(
              appState: appState,
              showAll: true,
            ),
          ),
          MaterialPage(
            key: const ValueKey('GameFinishedScreen'),
            child: GameFinishedScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.tutorial:
        return [
          MaterialPage(
            key: const ValueKey('TutorialPage'),
            child: Turorial(
              appState: appState,
            ),
          ),
        ];

      default:
        return [home];
    }
  }

  @override
  Future<void> setNewRoutePath(QuellenreiterRoutePath configuration) async {
    if (configuration.route == Routes.settings) {
      // get user, if not existing.
      appState.player ?? await appState.db.authenticate();
    } else if (configuration.isAddFriendsPage &&
        configuration.friendsQuery != null) {
      appState.friendsQuery = configuration.friendsQuery;
    }
  }
}
