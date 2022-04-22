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

  /// The current [Game]. If [Player] is not playing, [_game] is null.
  Game? _game;
  Game? get game => _game;
  set game(value) {
    _game = value;
    notifyListeners();
  }

  // /// True if on home page.
  // bool _viewHome = false;
  // bool get home => _viewHome;
  // set home(value) {
  //   _viewHome = value;
  //   notifyListeners();
  // }

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

  // /// True if user wants to sign up.
  // bool _signUp = false;
  // bool get signUp => _signUp;
  // set signUp(value) {
  //   _signUp = value;
  //   notifyListeners();
  // }

  // /// True if user wants to see the friends page.
  // bool _viewFriends = false;
  // bool get viewFriends => _viewFriends;
  // set viewFriends(value) {
  //   _viewFriends = value;
  //   notifyListeners();
  // }

  // /// True if user wants to see the settings page.
  // bool _viewSettings = false;
  // bool get viewSettings => _viewSettings;
  // set viewSettings(value) {
  //   _viewSettings = value;
  //   notifyListeners();
  // }

  // /// True if user wants to see the open Games page.
  // bool _viewOpenGames = false;
  // bool get viewOpenGames => _viewOpenGames;
  // set viewOpenGames(value) {
  //   _viewOpenGames = value;
  //   notifyListeners();
  // }

  // /// True if user wants to see the archive page.
  // bool _viewArchive = false;
  // bool get viewArchive => _viewArchive;
  // set viewArchive(value) {
  //   _viewArchive = value;
  //   notifyListeners();
  // }

  // /// True if user wants to see the startNewGame page.
  // bool _startGame = false;
  // bool get startGame => _startGame;
  // set startGame(value) {
  //   _startGame = value;
  //   notifyListeners();
  // }

  QuellenreiterAppState()
      : _game = null,
        _friendsQuery = null,
        _isLoggedIn = false,
        _route = Routes.login;
}
