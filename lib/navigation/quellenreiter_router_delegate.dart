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
        // if no opponent, go to home
        if (appState.currentOpponent == null ||
            appState.currentOpponent!.openGame == null) {
          return [
            home,
          ];
        }
        // go to ready to start screen
        return [
          home,
          MaterialPage(
            key: const ValueKey('ReadyToStartPage'),
            child: ReadyToStartScreen(
              appState: appState,
              showOnlyLast: false,
            ),
          ),
        ];
      case Routes.readyToStartOnlyLastScreen:
        // if no opponent, go to home
        if (appState.currentOpponent == null ||
            appState.currentOpponent!.openGame == null) {
          return [
            home,
          ];
        }
        // go to ready to start screen
        return [
          home,
          MaterialPage(
            key: const ValueKey('ReadyToStartPageOnlyLast'),
            child: ReadyToStartScreen(
              appState: appState,
              showOnlyLast: true,
            ),
          ),
        ];
      case Routes.quest:
        // error
        if (appState.currentOpponent == null) {
          return [home];
        }
        //  if it is the players turn
        else if (appState.currentOpponent!.openGame!.isPlayersTurn()) {
          return [
            MaterialPage(
              key: const ValueKey('QuestScreen'),
              child: QuestScreen(
                appState: appState,
              ),
            )
          ];
        } else {
          return [home];
        }
      case Routes.gameFinishedScreen:
        return [
          home,
          MaterialPage(
            key: const ValueKey('GameResultsScreen'),
            child: ReadyToStartScreen(
              appState: appState,
              showOnlyLast: true,
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
