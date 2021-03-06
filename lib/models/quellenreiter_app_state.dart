import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:plain_notification_token/plain_notification_token.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/provider/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consonents.dart';
import '../provider/database_utils.dart';
import 'enemy.dart';
import 'game.dart';
import 'player.dart';
import 'statement.dart';

class QuellenreiterAppState extends ChangeNotifier {
  ///  Object to be able to access the database.
  late DatabaseUtils db;
  late SharedPreferences prefs;

  bool errorBannerActive = false;
  bool msgBannerActive = false;

  Routes _route = Routes.login;
  Routes get route => _route;
  set route(value) {
    // reset the errors if
    // current route is not loading and pushed route is not loading
    if ((_route != Routes.loading && value != Routes.loading ||
            value == Routes.home && _route == Routes.loading) &&
        value != Routes.gameResults) {
      msg = null;
    }
    if (value == Routes.gameReadyToStart) {
      gameStarted = false;
    }
    _route = value;
    notifyListeners();
  }

  /// Holds any error message that might occur.
  String? _error;
  String? get msg => _error;
  set msg(value) {
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

  /// enemies that have an open game where its the [Player] turn.
  Enemies? _playableEnemies;
  Enemies? get playableEnemies => _playableEnemies;
  set playableEnemies(value) {
    _playableEnemies = value;
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

  /// True if user wants notifications.
  bool _notificationsAllowed = false;
  bool get notificationsAllowed {
    bool value = prefs.getBool('notificationsAllowed') ?? false;
    if (value) {
      getDeviceToken();
    }
    return value;
  }

  set notificationsAllowed(value) {
    prefs.setBool('notificationsAllowed', value);
    _notificationsAllowed = value;
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
    // if is logged and wasn't logged in before.
    if (!_isLoggedIn && value) {
      route = Routes.home;
      getFriends();
      getArchivedStatements();
      // start live query for friends.
      startLiveQueryForFriends();
    } else if (!value) {
      route = Routes.login;
    }
    _isLoggedIn = value;
    notifyListeners();
  }

  QuellenreiterAppState() {
    db = DatabaseUtils();

    route = Routes.loading;
    game = null;
    _friendsQuery = null;
    db.checkToken(_checkTokenCallback);
  }

  /// Callback for checking if user is logged in.
  /// Called every time the app is started.
  void _checkTokenCallback(Player? p) async {
    if (p == null) {
      isLoggedIn = false;
    } else {
      player = p;
      isLoggedIn = true;
    }
    // initialize stuff that needs to be initialized after login.
    prefs = await SharedPreferences.getInstance();
  }

  void _loginCallback(Player? p) {
    if (p == null) {
      route = Routes.login;
    } else {
      player = p;
      isLoggedIn = true;
    }
  }

  void _signUpCallback(Player? p) {
    if (p == null) {
      route = Routes.signUp;
    } else {
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
    print("get friends called");
    Enemies? enemies = await db.getFriends(player!);

    _getFriendsCallback(enemies);
    return;
  }

  void sendFriendRequest(Enemy e) {
    route = Routes.loading;
    db.sendFriendRequest(player!.id, e.userId, _sendFriendRequest);
  }

  void _sendFriendRequest(bool success) {
    if (success) {
      //  not needed because of live query in database_utils.dart
      route = Routes.friends;
    } else {}
  }

  Future<void> getUserData() async {
    await db.getUserData(player!);
  }

  bool _getFriendsCallback(Enemies? enemies) {
    // if no friends were returned
    if (enemies == null) {
      // if no friends are currently downloaded
      if (player!.friends == null) {
        player?.friends = Enemies.empty();
      }
      // else, just keep the downloaded friends.
      return false;
    }
    // set friends
    var tempFriends = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => enemy.acceptedByOther && enemy.acceptedByPlayer)
          .toList();
    // set received requests
    var tempRequests = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => enemy.acceptedByOther && !enemy.acceptedByPlayer)
          .toList();
    // set pending requests
    var tempPending = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) => !enemy.acceptedByOther && enemy.acceptedByPlayer)
          .toList();

    var tempPlayableEnemies = Enemies.empty()
      ..enemies = enemies.enemies
          .where((enemy) =>
              (enemy.openGame != null && enemy.openGame!.isPlayersTurn()))
          .toList();

    // notifications for requests.
    if (notificationsAllowed) {
      if (enemyRequests != null &&
          tempRequests.enemies.length > enemyRequests!.enemies.length) {
        Notifications.showNotification("Neue Freundschaftsanfrage",
            "Jemand will mit dir spielen.", "newFriendRequest", 1);
      }
      if (playableEnemies != null &&
          tempPlayableEnemies.enemies.length >
              playableEnemies!.enemies.length) {
        Notifications.showNotification(
            "Du bist dran.", "weiterspielen", "newPlayable", 1);
      }

      if (pendingRequests != null &&
          tempPending.enemies.length < pendingRequests!.enemies.length) {
        Notifications.showNotification("Neue*r Freund*in",
            "jemand hat deine Anfrage angenommen", "newPlayable", 1);
      }
    }

    player?.friends = tempFriends;
    enemyRequests = tempRequests;
    pendingRequests = tempPending;
    playableEnemies = tempPlayableEnemies;
    // redo current enemy
    if (currentEnemy != null) {
      try {
        currentEnemy = player!.friends!.enemies
            .firstWhere((enemy) => enemy.userId == currentEnemy!.userId);
      } catch (e) {
        currentEnemy = null;
      }
    }

    // // becuase in other cases, this clal will happen in the background.
    // if (route == Routes.loading) {
    //   route = Routes.home;
    // }
    return true;
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
      route = Routes.home;
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
      route = Routes.addFriends;
      friendsSearchResult = e;
    } else {
      route = Routes.addFriends;
    }
  }

  void handleNavigationChange(Routes r) {
    route = r;
  }

  /// For updating the username
  void updateUser() {
    // route = Routes.loading;
    db.updateUser(player!, _updateUserCallback);
  }

  /// for updating any other user trait.
  Future<void> updateUserData() async {
    // route = Routes.loading;
    await db.updateUserData(player!, _updateUserCallback);
    return;
  }

  void _updateUserCallback(Player? p) {
    if (p == null) {
      // login again and reset the user.
      db.checkToken(_checkTokenCallback);
      // route = Routes.settings;
    } else if (safedStatements!.statements.length !=
        player!.safedStatementsIds!.length) {
      getArchivedStatements();
      // route = Routes.archive;
    } else {
      // player should still be the same object so we do not set it again.
      // route = Routes.settings;
    }
  }

  void getArchivedStatements() async {
    if (player!.safedStatementsIds != null) {
      // Change this dummy data
      safedStatements = await db.getStatements(player!.safedStatementsIds!);

      if (safedStatements == null) {}
    }
  }

  void _getStatementsCallback(Statements? statements) {
    if (statements == null) {
    } else {
      safedStatements = statements;
    }
  }

  void startNewGame(Enemy e, bool withTimer) async {
    Routes tempRoute = route;
    route = Routes.loading;
    // if an open game exists, delete it
    if (e.openGame != null) {
      db.deleteGame(e.openGame!);
    }
    e.openGame = Game.empty(withTimer, e, player!);
    e.openGame!.statementIds = await db.getPlayableStatements(e, player!);
    if (e.openGame!.statementIds == null) {
      // reset game because not started
      e.openGame = null;
      route = tempRoute;
      db.error ??
          "Spielstarten fehlgeschlagen. ${e.emoji} ${e.name} wurde nicht herausgefordert. Versuche es erneut.";
      return;
    }
    await getFriends();
    // print(e.openGame!.statementIds.toString());
    // if successfully fetched statements
    route = tempRoute;
    msg = "${e.emoji} ${e.name} wurde herausgefordert.";

    return;
  }

  void getCurrentStatements() async {
    if (db.error != null) {
      return;
    }
    currentEnemy!.openGame!.statements =
        await db.getStatements(currentEnemy!.openGame!.statementIds!);
    // if (currentEnemy!.openGame!.statements == null) {
    //   route = Routes.gameReadyToStart;
    //   db.error = "Statements konnten nicht geladen werden.";
    //   return;
    // }
    route = Routes.gameReadyToStart;
    return;
  }

  void playGame() async {
    gameStarted = true;
    if (route != Routes.loading) {
      route = Routes.loading;
    }
    if (currentEnemy!.openGame != null &&
        currentEnemy!.openGame!.isPlayersTurn()) {
      // download statements
      currentEnemy!.openGame!.statements =
          await db.getStatements(currentEnemy!.openGame!.statementIds!);
      // check if error
      if (currentEnemy!.openGame!.statements == null) {
        route = Routes.home;
        return;
      }
      // set new route
      route = Routes.quest;

      return;
    }
    route = Routes.home;
  }

  void showError(BuildContext context) {
    if (db.error != null && !errorBannerActive) {
      errorBannerActive = true;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: DesignColors.red,
              alignment: Alignment.bottomCenter,
              title: const Text("Fehler:"),
              content: Text(db.error!),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    db.error = null;
                    HapticFeedback.mediumImpact();

                    Navigator.of(context).pop();
                  },
                  child: Text("ok"),
                ),
              ],
            );
          }).then(
        (value) {
          db.error = null;
          errorBannerActive = false;
        },
      );
    }
  }

  void showMessage(BuildContext context, {IconData icon = Icons.info_outline}) {
    if (msg != null && !msgBannerActive) {
      msgBannerActive = true;
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: AnimationLimiter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 500),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 20.0,
                        curve: Curves.elasticOut,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        Icon(icon, color: DesignColors.green, size: 50),
                        Text(msg!,
                            style: const TextStyle(
                                color: DesignColors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).then((value) => msgBannerActive = false);
      Future.delayed(const Duration(seconds: 3)).then((value) {
        if (msgBannerActive || msg != null) {
          Navigator.pop(context);
          msgBannerActive = false;
        }
      });
    }
  }

  List<String> getNames() {
    var ret = player!.friends!.getNames();
    ret.add(player!.name);
    ret.addAll(enemyRequests!.getNames());
    ret.addAll(pendingRequests!.getNames());
    return ret;
  }

  void startLiveQueryForFriends() {
    print("startLveQuery called [appstate].");
    db.startLiveQueryForFriends(this);
  }

  void getDeviceToken() async {
    const platform =
        MethodChannel('com.quellenreiter.quellenreiterApp/deviceToken');
    try {
      final String token = await platform.invokeMethod('getDeviceToken');
      print("token: $token");
      player!.deviceToken = token;
      db.updateUser(player!, () {});
    } on PlatformException catch (e) {
      print("error: ${e.message}");
    }
  }
}
