import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';
import 'package:quellenreiter_app/screens/auth/signup_screen.dart';
import 'package:quellenreiter_app/screens/game/game_results_screen.dart';
import 'package:quellenreiter_app/screens/game/quest_screen.dart';
import 'package:quellenreiter_app/screens/game/ready_to_start_screen.dart';
import 'package:quellenreiter_app/screens/loading_screen.dart';
import 'package:quellenreiter_app/screens/main/add_friend_screen.dart';
import 'package:quellenreiter_app/screens/main/archive_screen.dart';
import 'package:quellenreiter_app/screens/main/friends_screen.dart';
import 'package:quellenreiter_app/screens/main/open_games_screen.dart';
import 'package:quellenreiter_app/screens/main/settings_screen.dart';
import 'package:quellenreiter_app/screens/main/start_game_screen.dart';
import 'package:quellenreiter_app/screens/main/start_screen.dart';
import '../constants/constants.dart';
import '../provider/database_utils.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main/home_screen.dart';

class QuellenreiterRouterDelegate extends RouterDelegate<QuellenreiterRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<QuellenreiterRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  QuellenreiterAppState appState = QuellenreiterAppState();

  QuellenreiterRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
    print(appState.route);
    print('appState.addListener(notifyListeners) called');
  }
  @override
  QuellenreiterRoutePath get currentConfiguration {
    return QuellenreiterRoutePath(appState.route);
  }

  @override
  Widget build(BuildContext context) {
    print(appState.route.toString());
    return Navigator(
      pages: buildPages(),
      // Define what happens on Navigator.pop() or back button.
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (appState.route == Routes.signUp) {
          appState.route = Routes.login;
        } else if (appState.route != Routes.home) {
          appState.route = Routes.home;
        }
        notifyListeners();
        return true;
      },
    );
  }

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
            key: ValueKey('SignupPage'),
            child: LoadingScreen(),
          ),
        ];
      case Routes.login:
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
        return [home];
      case Routes.openGames:
        return [
          home,
          MaterialPage(
            key: const ValueKey('OpenGamesPage'),
            child: OpenGamesScreen(
              appState: appState,
            ),
          ),
        ];

      case Routes.addFriends:
        return [
          home,
          MaterialPage(
            key: const ValueKey('addFriends'),
            child: AddFriendScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.startGame:
        return [
          home,
          MaterialPage(
            key: const ValueKey('StartGameScreen'),
            child: StartGameScreen(
              appState: appState,
            ),
          ),
        ];
      case Routes.gameReadyToStart:
        return [
          MaterialPage(
            key: const ValueKey('ReadyToStartScreen'),
            child: ReadyToStartScreen(),
          ),
        ];
      case Routes.gameResults:
        return [
          MaterialPage(
            key: const ValueKey('GameResultsScreen'),
            child: GameResultsScreen(),
          ),
        ];
      case Routes.quest:
        return [
          MaterialPage(
            key: const ValueKey('QuestScreen'),
            child: QuestScreen(),
          ),
        ];
      default:
        return [home];
    }
  }

  @override
  Future<void> setNewRoutePath(QuellenreiterRoutePath configuration) async {
    var db = DatabaseUtils();
    // appState = configuration.appState;

    if (configuration.route == Routes.openGames) {
      // get open games if not existing
      appState.openGames ?? await db.getOpenGames();
    }
    // if (configuration.route == Routes.archive) {
    //   // get safed Statements if not exisiting.
    //   appState.safedStatements ?? await db.getSafedStatements();
    // }
    // if (configuration.route == Routes.friends) {
    //   // get list of friends, if not existing.
    //   appState.player?.friends ?? await db.getFriends(appState.player!);
    // }
    if (configuration.route == Routes.settings) {
      // get user, if not existing.
      appState.player ?? await db.authenticate();
    }
  }
}
