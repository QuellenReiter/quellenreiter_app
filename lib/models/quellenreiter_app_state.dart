import 'package:flutter/material.dart';
import 'package:quellenreiter_app/constants/constants.dart';

import '../provider/database_utils.dart';
import 'enemy.dart';
import 'game.dart';
import 'player.dart';
import 'statement.dart';

class QuellenreiterAppState extends ChangeNotifier {
  ///  Object to be able to access the database.
  final db = DatabaseUtils();

  Routes _route = Routes.login;
  Routes get route => _route;
  set route(value) {
    //refetch friends everytime we go to friends/startGame/openGames.
    if (value == Routes.friends ||
        value == Routes.startGame ||
        value == Routes.openGames) {
      getFriends();
    }
    // // refetch user everytime we got to homescreen.
    // if (route == Routes.home) {
    //   db.checkToken(_checkTokenCallback);
    // }
    _route = value;
    notifyListeners();
  }

  /// Holds any error message that might occur.
  String? _error;
  String? get error => _error;
  set error(value) {
    _error = value;
    if (_error != null) {
      print("ERROR: $_error");
    }
    notifyListeners();
  }

  /// The current [Game]. If [Player] is not playing, [_game] is null.
  Game? _game;
  Game? get game => _game;
  set game(value) {
    _game = value;
    notifyListeners();
  }

  /// Friend requests of the current [Player].
  Enemies? _enemyRequests;
  Enemies? get enemyRequests => _enemyRequests;
  set enemyRequests(value) {
    _enemyRequests = value;
    notifyListeners();
  }

  /// Pending friend requests sent by the current [Player].
  Enemies? _pendingRequests;
  Enemies? get pendingRequests => _pendingRequests;
  set pendingRequests(value) {
    _pendingRequests = value;
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

  /// The [Enemy] of the current game. Set when user selects game.
  Enemy? _currentEnemy;
  Enemy? get currentEnemy => _currentEnemy;
  set currentEnemy(value) {
    _currentEnemy = value;
    notifyListeners();
  }

  /// True if game mode is started.
  bool _gameStarted = false;
  bool get gameStarted => _gameStarted;
  set gameStarted(value) {
    _gameStarted = value;
    notifyListeners();
  }

  /// The [Enemies] (Friends) search result, if [Player] is searching.
  Enemies? _friendsSearchResult;
  Enemies? get friendsSearchResult => _friendsSearchResult;
  set friendsSearchResult(value) {
    _friendsSearchResult = value;
    notifyListeners();
  }

  void resetSearchResults() {
    _friendsQuery = null;
    _friendsSearchResult = null;
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
    route = Routes.loading;
    _friendsQuery = value;
    // This is async. As soon as it completes, app will rebuild.
    if (_friendsQuery != null && _friendsQuery!.isNotEmpty) {
      searchFriends();
      notifyListeners();
    }
  }

  /// True if user is logged in.
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(value) {
    _isLoggedIn = value;
    if (_isLoggedIn) {
      route = Routes.home;
      getFriends();
      getArchivedStatements();
    } else {
      route = Routes.login;
    }
    notifyListeners();
  }

  QuellenreiterAppState() {
    route = Routes.loading;
    game = null;
    _friendsQuery = null;
    db.checkToken(_checkTokenCallback);
  }

  void _checkTokenCallback(Player? p) {
    if (p == null) {
      isLoggedIn = false;
    } else {
      player = p;
      isLoggedIn = true;
    }
  }

  void _loginCallback(Player? p) {
    if (p == null) {
      error = "Login fehlgeschlagen. ";
      route = Routes.login;
    } else {
      error = null;
      player = p;
      isLoggedIn = true;
    }
  }

  void _signUpCallback(Player? p) {
    if (p == null) {
      error = "Username schon vergeben.";
      route = Routes.signUp;
    } else {
      error = null;
      player = p;
      isLoggedIn = true;
    }
  }

  void tryLogin(String username, String password) {
    route = Routes.loading;
    db.login(username, password, _loginCallback);
  }

  void trySignUp(String username, String password, String emoji) {
    route = Routes.loading;
    db.signUp(username, password, emoji, _signUpCallback);
  }

  void _logoutCallback() {
    isLoggedIn = false;
  }

  Future<void> getFriends() async {
    // print("get friends called");
    db.getFriends(player!, _getFriendsCallback);
  }

  void sendFriendRequest(Enemy e) {
    route = Routes.loading;
    db.sendFriendRequest(player!.id, e.userId, _sendFriendRequest);
  }

  void _sendFriendRequest(bool success) {
    if (success) {
      error = null;
      getFriends();
    } else {
      error = "Ein Fehler ist aufgetreten.";
    }
  }

  void _getFriendsCallback(Enemies? enemies) {
    if (enemies == null) {
      player?.friends = Enemies.empty();
      return;
    }
    // set friends
    player?.friends = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => enemy.acceptedByOther && enemy.acceptedByPlayer)
          .toList();
    // set received requests
    enemyRequests = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => enemy.acceptedByOther && !enemy.acceptedByPlayer)
          .toList();
    // set pending requests
    pendingRequests = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => !enemy.acceptedByOther && enemy.acceptedByPlayer)
          .toList();
    if (route == Routes.loading) {
      route = Routes.friends;
    }
  }

  void logout() async {
    route = Routes.loading;
    db.logout(_logoutCallback);
  }

  void acceptRequest(Enemy e) {
    route = Routes.loading;
    db.acceptFriendRequest(player!, e, _acceptRequestCallback);
  }

  void _acceptRequestCallback(bool success) {
    if (!success) {
      route = Routes.friends;
      error = "Das hat nicht funktioniert.";
    } else {
      error = null;
      getFriends();
    }
  }

  void searchFriends() {
    if (friendsQuery != null) {
      if (player!.friends == null) {
        db.searchFriends(friendsQuery!, [player!.name], _searchFriendsCallback);
      }
      db.searchFriends(friendsQuery!, getNames(), _searchFriendsCallback);
    }
  }

  void _searchFriendsCallback(Enemies? e) {
    if (e != null) {
      route = Routes.addFriends;
      error = null;
      friendsSearchResult = e;
    } else {
      route = Routes.addFriends;
      error = "keine Suchergebnisse";
    }
  }

  void handleNavigationChange(Routes r) {
    route = r;
  }

  /// For updating the username
  void updateUser() {
    route = Routes.loading;
    db.updateUser(player!, _updateUserCallback);
  }

  /// for updating any other user trait.
  void updateUserData() {
    route = Routes.loading;
    db.updateUserData(player!, _updateUserCallback);
  }

  void _updateUserCallback(Player? player) {
    if (player == null) {
      // login again and reset the user.
      db.checkToken(_checkTokenCallback);
      error = "Username existiert bereits.";
      route = Routes.settings;
    } else {
      error = null;
      // player should still be the same object so we do not set it again.
      route = Routes.settings;
    }
  }

  void getArchivedStatements() async {
    if (player!.safedStatementsIds != null) {
      // Change this dummy data
      safedStatements = await db.getStatements(player!.safedStatementsIds!);

      if (safedStatements == null) {
        error = "Archiv konnte nicht geladen werden.";
      }
    }
  }

  void _getStatementsCallback(Statements? statements) {
    if (statements == null) {
      error = "Archiv konnte nicht geladen werden.";
    } else {
      safedStatements = statements;
    }
  }

  void startNewGame(Enemy e, bool withTimer) async {
    Routes tempRoute = route;
    route = Routes.loading;
    e.openGame = Game.empty(withTimer, e.playerIndex);
    e.openGame!.statementIds = await db.getPlayableStatements(e, player!);
    if (e.openGame!.statementIds == null) {
      // reset game because not started
      e.openGame = null;
      route = tempRoute;
      error =
          "Spielstarten fehlgeschlagen. ${e.emoji} ${e.name} wurde nicht herausgefordert. Versuche es erneut.";
      return;
    }
    // print(e.openGame!.statementIds.toString());
    // if successfully fetched statements
    route = tempRoute;
    error =
        "${e.emoji} ${e.name} wurde herausgefordert. Warte, bis ${e.emoji} ${e.name} die erste Runde gespielt hat.";
    return;
  }

  void getCurrentStatements() async {
    currentEnemy!.openGame!.statements =
        await db.getStatements(currentEnemy!.openGame!.statementIds!);
    if (currentEnemy!.openGame!.statements == null) {
      route = Routes.gameReadyToStart;
      error = "Statements konnten nicht geladen werden.";
      return;
    }
    route = Routes.gameResults;
    return;
  }

  void playGame() async {
    route = Routes.loading;
    if (currentEnemy!.openGame != null &&
        currentEnemy!.openGame!.isPlayersTurn()) {
      // download statements
      currentEnemy!.openGame!.statements =
          await db.getStatements(currentEnemy!.openGame!.statementIds!);
      // check if error
      if (currentEnemy!.openGame!.statements == null) {
        route = Routes.home;
        error = "Spiel konnte nicht gestarted werden.";
        return;
      }
      // set new route
      route = Routes.quest;
      gameStarted = true;

      return;
    }
    route = Routes.home;
    error = "Spiel konnte nicht gestarted werden.";
  }

  List<String> getNames() {
    var ret = player!.friends!.getNames();
    ret.add(player!.name);
    ret.addAll(enemyRequests!.getNames());
    ret.addAll(pendingRequests!.getNames());
    return ret;
  }
}
