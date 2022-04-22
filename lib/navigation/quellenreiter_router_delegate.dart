import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';
import 'package:quellenreiter_app/screens/auth/signup_screen.dart';
import 'package:quellenreiter_app/screens/game/game_results_screen.dart';
import 'package:quellenreiter_app/screens/game/quest_screen.dart';
import 'package:quellenreiter_app/screens/game/ready_to_start_screen.dart';
import 'package:quellenreiter_app/screens/main/archive_screen.dart';
import 'package:quellenreiter_app/screens/main/friends_screen.dart';
import 'package:quellenreiter_app/screens/main/open_games_screen.dart';
import 'package:quellenreiter_app/screens/main/settings_screen.dart';
import 'package:quellenreiter_app/screens/main/start_game_screen.dart';
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

  QuellenreiterRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  @override
  QuellenreiterRoutePath get currentConfiguration {
    return QuellenreiterRoutePath(appState);
  }

  void _handleNavigationChange(Routes r) {
    appState.route = r;
    notifyListeners();
  }

  void _tryLogin(String username, String password) async {
    appState.tryLogin(username, password, notifyListeners);
  }

  void _trySignUp(String username, String password) async {
    appState.trySignUp(username, password, notifyListeners);
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
      child: HomeScreen(),
    );
    Page login = MaterialPage(
      key: const ValueKey('LoginPage'),
      child: LoginScreen(
        signUpTapped: _handleNavigationChange,
        tryLogin: _tryLogin,
      ),
    );
    switch (appState.route) {
      case Routes.login:
        return [login];
      case Routes.signUp:
        return [
          login,
          MaterialPage(
            key: const ValueKey('SignupPage'),
            child: SignupScreen(
              loginTapped: _handleNavigationChange,
              trySignUp: _trySignUp,
            ),
          ),
        ];
      case Routes.home:
        return [home];
      case Routes.archive:
        return [
          home,
          MaterialPage(
            key: const ValueKey('ArchivePage'),
            child: ArchiveScreen(),
          ),
        ];
      case Routes.friends:
        return [
          home,
          MaterialPage(
            key: const ValueKey('FriendsPage'),
            child: FriendsScreen(),
          ),
        ];
      case Routes.settings:
        return [
          home,
          MaterialPage(
            key: const ValueKey('SettingsPage'),
            child: SettingsScreen(),
          ),
        ];
      case Routes.openGames:
        return [
          home,
          MaterialPage(
            key: const ValueKey('OpenGamesPage'),
            child: OpenGamesScreen(),
          ),
        ];
      case Routes.startGame:
        return [
          home,
          MaterialPage(
            key: const ValueKey('StartGameScreen'),
            child: StartGameScreen(),
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
    appState = configuration.appState;

    if (appState.route == Routes.openGames) {
      // get open games if not existing
      appState.openGames ?? await db.getOpenGames();
    }
    if (appState.route == Routes.archive) {
      // get safed Statements if not exisiting.
      appState.safedStatements ?? await db.getSafedStatements();
    }
    if (appState.route == Routes.friends) {
      // get list of friends, if not existing.
      appState.enemies ?? await db.getFriends();
    }
    if (appState.route == Routes.settings) {
      // get user, if not existing.
      appState.player ?? await db.authenticate();
    }
  }
}
