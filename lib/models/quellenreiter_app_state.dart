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
    _route = value;
    notifyListeners();
  }

  /// Holds any error message that might occur.
  String? _error;
  String? get error => _error;
  set error(value) {
    _error = value;
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

  /// The [Enemies] (Friends) search result, if [Player] is searching.
  Enemies? _friendsSearchResult;
  Enemies? get friendsSearchResult => _friendsSearchResult;
  set friendsSearchResult(value) {
    _friendsSearchResult = value;
    notifyListeners();
  }

  void resetSearchResults() {
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
      error = "Login fehlgeschlagen.";
    } else {
      player = p;
      isLoggedIn = true;
    }
  }

  void _signUpCallback(Player? p) {
    if (p == null) {
      error = "Anmeldung fehlgeschlagen.";
      route = Routes.signUp;
    } else {
      player = p;
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
    await db.getFriends(player!, _getFriendsCallback);
  }

  void sendFriendRequest(Enemy e) {
    route = Routes.loading;
    db.sendFriendRequest(player!.id, e.userID, _sendFriendRequest);
  }

  void _sendFriendRequest(bool success) {
    if (success) {
      getFriends();
    } else {
      error = "Ein Fehler ist aufgetreten.";
    }
  }

  void _getFriendsCallback(Enemies? enemies) {
    // set friends
    player?.friends = Enemies.empty()
      ..enemies = enemies!.enemies
          .where((enemy) => enemy.acceptedByOther && enemy.acceptedByPlayer)
          .toList();
    // set received requests
    enemyRequests = Enemies.empty()
      ..enemies = enemies!.enemies
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
      friendsSearchResult = e;
    } else {
      error = "keine Suchergebnisse";
    }
  }

  void handleNavigationChange(Routes r) {
    route = r;
  }

  List<String> getNames() {
    var ret = player!.friends!.getNames();
    ret.add(player!.name);
    ret.addAll(enemyRequests!.getNames());
    ret.addAll(pendingRequests!.getNames());
    return ret;
  }
}
