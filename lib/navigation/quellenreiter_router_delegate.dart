import 'package:flutter/material.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/navigation/quellenreiter_routes.dart';
import '../models/statement.dart';
import '../provider/database_utils.dart';
import '../screens/edit_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

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

  /// The [Games] that are open currently.
  Games? _openGames;
  Games? get openGames => _openGames;
  set openGames(value) {
    _openGames = value;
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
        return QuellenreiterRoutePath.friends();
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
  void _onSelectStatement(Statement statement) {
    _statement = statement;
    notifyListeners();
  }

  /// Function that handles the search queries.
  void _onQueryChanged(String? query) async {
    // If query is null, make it empty
    query ?? "";
    _query = query;
    _statements = await db.searchStatements(query);
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
        MaterialPage(
          key: const ValueKey('SearchPage'),
          child: HomeScreen(
            title: "Search",
            onSelectStatement: _onSelectStatement,
            onQueryChanged: _onQueryChanged,
            onLogin: _onLogin,
            query: null,
            statements: _statements,
            isLoggedIn: loggedIn,
            createStatement: _createStatement,
          ),
        ),
        // If user wants to login, show login page.
        if (_showLogIn)
          MaterialPage(
            key: const ValueKey('LoginPage'),
            child: LoginScreen(
              loginCallback: _loginPageCallback,
            ),
          )
        // If given link is unknown, show the search/home screen.
        else if (_show404)
          MaterialPage(
            key: const ValueKey('Unknown Page'),
            child: HomeScreen(
              title: "Unbekannter Link",
              onSelectStatement: _onSelectStatement,
              onQueryChanged: _onQueryChanged,
              query: _query,
              statements: _statements,
              onLogin: _onLogin,
              isLoggedIn: loggedIn,
              createStatement: _createStatement,
            ),
          )
        // If user is not logged in, but a statement is selected, show the
        // detail page.
        else if (_statement != null && !loggedIn)
          MaterialPage(
            key: const ValueKey('DetailPage'),
            child: DetailScreen(
              title: "Detailansicht. Zum bearbeiten einloggen.",
              onLogin: _onLogin,
              statement: _statement!,
              isLoggedIn: _isLoggedIn,
            ),
          )
        // If user is logged in and a statement is selected, show edit page.
        else if (_statement != null && loggedIn)
          MaterialPage(
            key: const ValueKey('EditPage'),
            child: EditScreen(
              title: "Eingeloggt. Bearbeitungsmodus.",
              onLogin: _onLogin,
              statement: _statement!,
              isLoggedIn: _isLoggedIn,
            ),
          )
        // If user is logged in and an empty statement is selected, show the
        // edit page.
        else if (_emptyStatement != null && loggedIn)
          MaterialPage(
            key: const ValueKey('CreatePage'),
            child: EditScreen(
              title: "Neues Statement erstellen.",
              onLogin: _onLogin,
              statement: _emptyStatement!,
              isLoggedIn: _isLoggedIn,
            ),
          ),
      ],
      // Define what happens on Navigator.pop() or back button.
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _statement = null;
        _emptyStatement = null;
        _showLogIn = false;
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(FactBrowserRoutePath configuration) async {
    var db = DatabaseUtils();
    if (configuration.isUnknown) {
      _statement = null;
      _show404 = true;
      return;
    }
    // Download the statement before opening the detail page.
    Statement? statement = await db.getStatement(configuration.statementID);
    if (configuration.isDetailsPage) {
      // check if statement exists here
      if (statement == null) {
        _show404 = true;
        return;
      }
      // fetch statement from DB here
      _statement = statement;
    } else {
      _statement = null;
    }

    _show404 = false;
  }
}
