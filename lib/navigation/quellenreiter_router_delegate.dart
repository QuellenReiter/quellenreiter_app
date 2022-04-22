import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/game.dart';
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
import '../models/enemy.dart';
import '../models/player.dart';
import '../models/statement.dart';
import '../provider/database_utils.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main/home_screen.dart';

class QuellenreiterRouterDelegate extends RouterDelegate<QuellenreiterRoutePath>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<QuellenreiterRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  ///  Object to be able to access the database.
  final db = DatabaseUtils();

  /// The current [Game]. If [Player] is not playing, [_game] is null.
  Game? _game;
  Game? get game => _game;
  set game(value) {
    _game = value;
    notifyListeners();
  }

  /// The current [Player]. Should be set, if user is logged in.
  Player? _player;
  Player? get player => _player;
  set player(value) {
    _player = value;
    notifyListeners();
  }

  /// The [Games] that are open currently.
  Games? _openGames;
  Games? get openGames => _openGames;
  set openGames(value) {
    _openGames = value;
    notifyListeners();
  }

  /// The [Enemies] (Friends) someone has. Also [Enemies] that requested a
  /// friendship and your open requests will be in here.
  Enemies? _enemies;
  Enemies? get enemies => _enemies;
  set enemies(value) {
    _enemies = value;
    notifyListeners();
  }

  /// The [Enemies] (Friends) search result, if [Player] is searching.
  Enemies? _friendsSearchResult;
  Enemies? get friendsSearchResult => _friendsSearchResult;
  set friendsSearchResult(value) {
    _friendsSearchResult = value;
    notifyListeners();
  }

  /// The [Statements] that the [Player] safed.
  Statements? _safedStatements;
  Statements? get safedStatements => _safedStatements;
  set safedStatements(value) {
    _safedStatements = value;
    notifyListeners();
  }

  /// The searchterm when searching for a friend.
  String? _friendsQuery;
  String? get friendsQuery => _friendsQuery;
  set friendsQuery(value) {
    _friendsQuery = value;
    notifyListeners();
  }

  /// True if user is logged in.
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  /// True if user wants to sign up.
  bool _signUp = false;
  bool get signUp => _signUp;
  set signUp(value) {
    _signUp = value;
    notifyListeners();
  }

  /// True if user wants to see the friends page.
  bool _viewFriends = false;
  bool get viewFriends => _viewFriends;
  set viewFriends(value) {
    _viewFriends = value;
    notifyListeners();
  }

  /// True if user wants to see the settings page.
  bool _viewSettings = false;
  bool get viewSettings => _viewSettings;
  set viewSettings(value) {
    _viewSettings = value;
    notifyListeners();
  }

  /// True if user wants to see the open Games page.
  bool _viewOpenGames = false;
  bool get viewOpenGames => _viewOpenGames;
  set viewOpenGames(value) {
    _viewOpenGames = value;
    notifyListeners();
  }

  /// True if user wants to see the archive page.
  bool _viewArchive = false;
  bool get viewArchive => _viewArchive;
  set viewArchive(value) {
    _viewArchive = value;
    notifyListeners();
  }

  /// True if user wants to see the startNewGame page.
  bool _startGame = false;
  bool get startGame => _startGame;
  set startGame(value) {
    _startGame = value;
    notifyListeners();
  }

  QuellenreiterRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  @override
  QuellenreiterRoutePath get currentConfiguration {
    // auth routes
    if (!_isLoggedIn) {
      return _signUp
          ? QuellenreiterRoutePath.signUp()
          : QuellenreiterRoutePath.login();
    }
    // main routes
    else if (_game == null) {
      // friends
      if (_viewFriends) {
        return QuellenreiterRoutePath.friends(friendsQuery);
      }
      // settings
      else if (_viewSettings) {
        return QuellenreiterRoutePath.settings();
      }
      // openGames
      else if (_viewOpenGames) {
        return QuellenreiterRoutePath.openGames();
      }
      // archive
      else if (_viewArchive) {
        return QuellenreiterRoutePath.archive();
      }
      // start game
      else if (_startGame) {
        return QuellenreiterRoutePath.startGame();
      }
    }
    // game routes
    else if (_game != null) {
      // If player answered 3 quests: show results and factchecks.
      if (_game!.statementIndex == 4) {
        // implement such that factcheckts are on same page to scroll down or button!
        return QuellenreiterRoutePath.gameResults(_game);
      }
      // Show the start the game screen.
      else if (_game!.statementIndex == 0) {
        return QuellenreiterRoutePath.gameReadyToStart(_game);
      }
      // [_game.statementIndex] is between 1 and 3.
      else {
        return QuellenreiterRoutePath.questScreen(_game);
      }
    }
    // Else return homescreen.
    return QuellenreiterRoutePath.home();
  }

  /// Function that handles taps on statement cards and sets [_statement].
  // void _onSelectStatement(Statement statement) {
  //   _statement = statement;
  //   notifyListeners();
  // }

  /// Function that handles the search queries.
  void _onQueryChanged(String? query) async {
    // If query is null, make it empty
    query ?? "";
    _friendsQuery = query;
    _friendsSearchResult = await db.searchFriends(_friendsQuery);
    notifyListeners();
  }

  /// Function that handles taps on the login/logout button.
  ///
  /// The user is logged out, when already logged in. If User is logged out,
  /// a login with an existing stored token is attempted and if this fails,
  /// the login page is shown.
  void _onLogin() async {
    final db = DatabaseUtils();
    // logout if user is logged in
    if (_isLoggedIn) {
      await db.logout();
      _isLoggedIn = false;
      notifyListeners();
      return;
    } else {
      // Check if user can be logged in with an existing token.
      _isLoggedIn = await db.checkToken();
    }
    // If still not, show the login page.
    _isLoggedIn = false;

    notifyListeners();
  }

  /// Callback that is passed to the Login page and called with the result of
  /// the login attempt.
  void _loginPageCallback(bool success) async {
    if (success) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        // auth pages
        if (!_isLoggedIn)
          if (_signUp)
            MaterialPage(
              key: const ValueKey('SignupPage'),
              child: SignupScreen(),
            )
          else
            MaterialPage(
              key: const ValueKey('LoginPage'),
              child: LoginScreen(),
            )
        // Game pages
        else if (_game != null)
          if (_game!.statementIndex == 0)
            MaterialPage(
              key: const ValueKey('ReadyToStartPage'),
              child: ReadyToStartScreen(), // pass game here
            )
          else if (_game!.statementIndex == 4)
            MaterialPage(
              key: const ValueKey('GameResultPage'),
              child: GameResultsScreen(), // pass game here
            )
          else
            MaterialPage(
              key: const ValueKey('QuestPage'),
              child: QuestScreen(), // pass game here
            )
        // Main pages
        else if (viewFriends)
          MaterialPage(
            key: const ValueKey('FriendsPage'),
            child: FriendsScreen(),
          )
        else if (viewArchive)
          MaterialPage(
            key: const ValueKey('ArchivePage'),
            child: ArchiveScreen(),
          )
        else if (viewSettings)
          MaterialPage(
            key: const ValueKey('SettingsPage'),
            child: SettingsScreen(),
          )
        else if (viewOpenGames)
          MaterialPage(
            key: const ValueKey('OpenGamesPage'),
            child: OpenGamesScreen(),
          )
        else if (startGame)
          MaterialPage(
            key: const ValueKey('StartGamePage'),
            child: StartGameScreen(),
          )
        else
          MaterialPage(
            key: const ValueKey('HomePage'),
            child: HomeScreen(),
          ),
      ],
      // Define what happens on Navigator.pop() or back button.
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if ((game == null) && isLoggedIn) {
          startGame = false;
          viewArchive = false;
          viewFriends = false;
          viewOpenGames = false;
          viewSettings = false;
        }
        if (game != null && isLoggedIn) {
          // decide the game routes here. HERE WE ARE
          // implement detail result pages here
          // in game mode, no pop should be possible.
        }
        // if on signup page, go back to login.
        else if (signUp) {
          signUp = false;
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(QuellenreiterRoutePath configuration) async {
    var db = DatabaseUtils();
    startGame = false;
    viewArchive = configuration.isArchivePage;
    viewFriends = configuration.isFriendsPage;
    viewOpenGames = configuration.isOpenGames;
    viewSettings = configuration.isSettingsPage;
    startGame = configuration.isStartGame;
    game = configuration.game;

    if (viewOpenGames) {
      // get open games if not existing
      openGames ?? await db.getOpenGames();
    }
    if (viewArchive) {
      // get safed Statements if not exisiting.
      safedStatements ?? await db.getSafedStatements();
    }
    if (viewFriends) {
      // get list of friends, if not existing.
      enemies ?? await db.getFriends();
    }
    if (viewSettings) {
      // get user, if not existing.
      player ?? await db.authenticate();
    }
  }
}
