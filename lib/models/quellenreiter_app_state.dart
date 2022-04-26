import 'dart:async';

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
    // If query is null, make it empty
    value ?? "";
    friendsQuery = value;
    // This is async. As soon as it completes, app will rebuild.
    db.searchFriends(friendsQuery);
    notifyListeners();
  }

  /// True if user is logged in.
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  QuellenreiterAppState()
      : _game = null,
        _friendsQuery = null,
        _isLoggedIn = false,
        _route = Routes.login;

  void _loginCallback(Player? p) {
    if (p == null) {
      _error = "Login fehlgeschlagen.";
    } else {
      player = p;
      route = Routes.home;
      isLoggedIn = true;
    }
  }

  void _signUpCallback(Player? p) {
    if (p == null) {
      _error = "Anmeldung fehlgeschlagen.";
    } else {
      player = p;
    }
  }

  void tryLogin(String username, String password) async {
    db.login(username, password, _loginCallback);
    // Timer(Duration(seconds: 1), () {
    //   route = Routes.home;
    //   // callback();
    //   notifyListeners();
    // });
  }

  void trySignUp(String username, String password, String emoji) async {
    db.signUp(username, password, emoji, _signUpCallback);
    // Timer(Duration(seconds: 1), () {
    //   route = Routes.home;
    //   // callback();
    //   notifyListeners();
    // });
  }
}
