import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/database_utils.dart';
import 'enemy.dart';
import 'game.dart';
import 'player.dart';
import 'statement.dart';

/// The state of the app.
class QuellenreiterAppState extends ChangeNotifier {
  ///  Object to be able to access the database.
  late DatabaseUtils db;

  /// Object to access the shared preferences.
  late SharedPreferences prefs;

  /// True if an error is shown.
  bool errorBannerActive = false;

  /// True if a message is shown.
  bool msgBannerActive = false;

  /// The curent [Routes]. The screen currently displayed.
  Routes _route = Routes.login;
  Routes get route => _route;

  /// Sets the _route to the given value.
  /// Also resets the errors and messages if displayed.
  /// @param value The new [Routes].
  set route(value) {
    // reset the errors if
    // current route is not loading and pushed route is not loading
    if ((_route != Routes.loading && value != Routes.loading ||
        value == Routes.home && _route == Routes.loading)) {
      msg = null;
    }
    // set gamestarted to false to restart live queries etc
    if (value == Routes.gameReadyToStart ||
        value == Routes.readyToStartOnlyLastScreen) {
      gameStarted = false;
    }
    _route = value;
    notifyListeners();
  }

  /// Holds any error message that might occur.
  String? _error;
  String? get msg => _error;

  /// Sets the _error to the given value.
  ///
  /// @param value The new error message.
  set msg(value) {
    _error = value;
    notifyListeners();
  }

  /// The current [Game]. If [Player] is not playing, [_game] is null.
  Game? _game;
  Game? get game => _game;

  /// Sets the _game to the given value.
  ///
  /// @param value The new [Game].
  set game(value) {
    _game = value;
    notifyListeners();
  }

  /// Friend requests of the current [Player].
  Enemies? _enemyRequests;
  Enemies? get enemyRequests => _enemyRequests;

  /// Sets the _enemyRequests to the given value.
  ///
  /// @param value The new [Enemies]. that requested to be friends with the current [Player].
  set enemyRequests(value) {
    _enemyRequests = value;
    notifyListeners();
  }

  /// Pending friend requests sent by the current [Player].
  Enemies? _pendingRequests;
  Enemies? get pendingRequests => _pendingRequests;

  /// Sets the _pendingRequests to the given value.
  ///
  /// @param value The  [Enemies]. that were invited by the current [Player].
  set pendingRequests(value) {
    _pendingRequests = value;
    notifyListeners();
  }

  /// enemies that have an open game where its the [Player] turn.
  Enemies? _playableEnemies;

  /// Sets the _playableEnemies to the given value.
  ///
  /// @param value The [Enemies] that have an open game where its the [Player] turn.
  Enemies? get playableEnemies => _playableEnemies;
  set playableEnemies(value) {
    _playableEnemies = value;
    notifyListeners();
  }

  /// The current [Player]. Should be set, if user is logged in.
  Player? _player;
  Player? get player => _player;

  /// Sets the _player to the given value.
  ///
  /// @param value The new [Player].
  set player(value) {
    _player = value;
    notifyListeners();
  }

  /// The [Games] that are open currently.
  Games? _openGames;
  Games? get openGames => _openGames;

  /// Sets the _openGames to the given value.
  ///
  /// @param value The new [Games] that are open currently.
  set openGames(value) {
    _openGames = value;
    notifyListeners();
  }

  /// The [Enemy] of the current game. Set when user selects game.
  Enemy? _currentEnemy;
  Enemy? get currentEnemy => _currentEnemy;

  /// Sets the _currentEnemy to the given value.
  ///
  /// @param value The new [Enemy] whoms game is currently beign viewed by the user.
  set currentEnemy(value) {
    _currentEnemy = value;
    notifyListeners();
  }

  /// True if game mode is started.
  bool _gameStarted = false;
  bool get gameStarted => _gameStarted;

  /// Sets the _gameStarted to the given value.
  ///
  /// @param value The new value.
  set gameStarted(value) {
    _gameStarted = value;
    notifyListeners();
  }

  /// True if user wants notifications.
  bool _notificationsAllowed = true;

  /// Gets if user wants notifications.
  /// if user has not set the value yet, the default value is true.
  /// The new value is pushed to the database.
  bool get notificationsAllowed {
    bool? value = prefs.getBool('notificationsAllowed');
    if (value == null) {
      value = true;
      notificationsAllowed = value;
      updateDeviceTokenForPushNotifications();
    }
    return value;
  }

  /// Sets the _notificationsAllowed to the given value.
  /// The new value is pushed to the database.
  set notificationsAllowed(value) {
    prefs.setBool('notificationsAllowed', value);
    _notificationsAllowed = value;
    updateDeviceTokenForPushNotifications();
    notifyListeners();
  }

  /// The [Enemies] (Friends) search result, if [Player] is searching.
  Enemies? _friendsSearchResult;
  Enemies? get friendsSearchResult => _friendsSearchResult;
  set friendsSearchResult(value) {
    _friendsSearchResult = value;
    notifyListeners();
  }

  /// Resets the _friendsSearchResult and the _friendsSearchQuery.
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

  /// Sets the _friendsQuery to the given value.
  /// The query is searched for in the database using exact matching.
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

  /// Sets the _isLoggedIn to the given value.
  /// If the user is freshly logged in, friends and archive are downloaded.
  /// And the livequery is started;
  ///
  /// @param value The new value.
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
    // set player to null if user is logged out.
    if (!value) {
      player = null;
    }
    _isLoggedIn = value;
    notifyListeners();
  }

  /// The [DatabaseUtils] are initialized, the route is set to loading
  /// and it is checked, if the user is still signed in.
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
    // initialize stuff that needs to be initialized after login.
    prefs = await SharedPreferences.getInstance();

    if (p == null) {
      isLoggedIn = false;
    } else {
      player = p;
      isLoggedIn = true;
    }
  }

  /// Callback for the login process. If successfull, a [Player] is returned and safed.
  /// If not, the route is set to login.
  ///
  /// @param p The [Player] returned from the server.
  void _loginCallback(Player? p) {
    if (p == null) {
      route = Routes.login;
    } else {
      player = p;
      isLoggedIn = true;
      updateDeviceTokenForPushNotifications();
    }
  }

  /// Callback for the signup process. If successfull, a [Player] is returned and safed.
  /// If not, the route is set to signup.
  ///
  /// @param p The [Player] returned from the server.
  void _signUpCallback(Player? p) {
    if (p == null) {
      route = Routes.signUp;
    } else {
      player = p;
      isLoggedIn = true;
      updateDeviceTokenForPushNotifications();
    }
  }

  ///
  void tryLogin(String username, String password) {
    route = Routes.loading;
    db.login(username, password, _loginCallback);
  }

  void trySignUp(String username, String password, String emoji) {
    route = Routes.loading;
    db.signUp(username, password, emoji, _signUpCallback);
  }

  void _logoutCallback() {
    player = null;
    isLoggedIn = false;
  }

  Future<void> getFriends() async {
    print("get friends called");
    Enemies? enemies = await db.getFriends(player!);

    await _getFriendsCallback(enemies);
    return;
  }

  void sendFriendRequest(Enemy e) {
    route = Routes.loading;
    db.sendFriendRequest(this, e.userId, _sendFriendRequest);
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

  /// Callback for the getFriends method.
  /// If successfull, the [Enemies] are safed.
  /// They are split up into friends, requests, pending and playable games.
  /// Also the current enemy is restored and updated.
  ///
  /// @param enemies The [Enemies] returned from the server.
  Future<bool> _getFriendsCallback(Enemies? enemies) async {
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

    player?.friends = tempFriends;
    // set new number of friends
    if (player!.numFriends != tempFriends.enemies.length) {
      player!.numFriends = tempFriends.enemies.length;
      await db.updateUserData(player, (Player? p) {});
    }
    player?.numFriends = tempFriends.enemies.length;
    enemyRequests = tempRequests;
    pendingRequests = tempPending;
    playableEnemies = tempPlayableEnemies;
    // redo current enemy
    if (currentEnemy != null) {
      try {
        var tempCurrentEnemy = player!.friends!.enemies
            .firstWhere((enemy) => enemy.userId == currentEnemy!.userId);
        // only update current enemy if enemy has played 3 quests so that the
        // game is either finished or its the players turn now.
        // this prevent constant updating while the player is browsing the quests.
        if (tempCurrentEnemy.openGame != null &&
            tempCurrentEnemy.openGame!.enemyAnswers.length % 3 == 0) {
          currentEnemy = tempCurrentEnemy;
        }
      } catch (e) {
        currentEnemy = null;
      }
    }
    return true;
  }

  void logout() async {
    route = Routes.loading;
    //remove devie from the users push list.
    notificationsAllowed = false;
    await updateDeviceTokenForPushNotifications();
    // remove device decision so that for next user, default is allowed again.
    await prefs.remove("notificationsAllowed");
    await db.logout(_logoutCallback);
  }

  void deleteAccount() async {
    route = Routes.loading;
    //remove devie from the users push list.
    notificationsAllowed = false;
    await updateDeviceTokenForPushNotifications();
    // remove device decision so that for next user, default is allowed again.
    await prefs.remove("notificationsAllowed");
    await db.deleteAccount(this);

    player = null;
  }

  void acceptRequest(Enemy e) {
    route = Routes.loading;
    db.acceptFriendRequest(player!, e, _acceptRequestCallback);
  }

  void _acceptRequestCallback(bool success) async {
    if (!success) {
      route = Routes.home;
    } else {
      await getFriends();
      route = Routes.home;
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
  Future<void> updateUser() async {
    await db.updateUser(player!, _updateUserCallback);
    return;
  }

  /// for updating any other user trait.
  Future<void> updateUserData() async {
    await db.updateUserData(player!, _updateUserCallback);
    return;
  }

  Future<void> _updateUserCallback(Player? p) async {
    if (p == null) {
      // login again and reset the user.
      await db.checkToken(_checkTokenCallback);
    } else if (safedStatements!.statements.length !=
        player!.safedStatementsIds!.length) {
      getArchivedStatements();
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
    // update player and enemy here, to be updtodate with played statements
    await getFriends();
    //update enemy e
    e = player!.friends!.enemies
        .firstWhere((enemy) => enemy.userId == e.userId);
    // if an open game exists, check if its new or delete it
    if (e.openGame != null &&
        (!e.openGame!.gameFinished() || !e.openGame!.pointsAccessed)) {
      // the existing  game is not finished and the points are not accessed
      msg =
          "Ein offenes spiel existiert bereits. Beende es bevor du ein neues startest.";
      return;
    } else if (e.openGame != null) {
      // delete the old game, it is finished
      await db.deleteGame(e.openGame!);
    }
    // delete old game
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
    db.sendPushGameStartet(this, receiverId: e.userId);
    await getFriends();
    // print(e.openGame!.statementIds.toString());
    // if successfully fetched statements
    route = tempRoute;
    msg = "${e.emoji} ${e.name} wurde herausgefordert";

    return;
  }

  void getCurrentStatements() async {
    if (db.error != null) {
      return;
    }
    currentEnemy!.openGame!.statements =
        await db.getStatements(currentEnemy!.openGame!.statementIds!);
    notifyListeners();
    return;
  }

  /// Starts an open game with the current enemy.
  /// only if its the [Player]s turn.
  void playGame() async {
    HapticFeedback.mediumImpact();

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

  void showError(BuildContext context, {String? errorMsg}) {
    if ((errorMsg != null || db.error != null) && !errorBannerActive) {
      errorBannerActive = true;
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              backgroundColor: DesignColors.red,
              content: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    errorMsg ?? db.error!,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          )
          .closed
          .then((value) {
        errorBannerActive = false;
        db.error = null;
      });
    }
  }

  void showMessage(BuildContext context, {IconData icon = Icons.info_outline}) {
    if (msg != null && !msgBannerActive) {
      msgBannerActive = true;
      var tempmsg = msg ?? "";
      msg = null;
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              backgroundColor: DesignColors.lightBlue,
              content: Row(
                children: [
                  Icon(icon),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    tempmsg,
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                          color: DesignColors.backgroundBlue,
                        ),
                  ),
                ],
              ),
              duration: const Duration(seconds: 3),
            ),
          )
          .closed
          .then((value) {
        msgBannerActive = false;
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
    db.startLiveQueryForFriends(this);
  }

  /// Checks if user allows push notifications. If yes, update user in db with
  /// the device token. If not, delete the device token from the db.
  Future<void> updateDeviceTokenForPushNotifications() async {
    if (!notificationsAllowed) {
      player!.deviceToken = "not allowed";
    } else if (Platform.isIOS || Platform.isAndroid) {
      const platform =
          MethodChannel('com.quellenreiter.quellenreiter_app/deviceToken');
      try {
        final String? token = await platform.invokeMethod('getDeviceToken');
        if (token == null) {
          print("token is null, are you on an iOS simulator?");
          return;
        }
        print("token: $token");
        player!.deviceToken = token;
      } on PlatformException catch (e) {
        print("error: ${e.message}");
      }
    }
    print("deviceToken: ${player!.deviceToken}");
    // push new token to db
    await db.updateUser(player!, (Player? p) {});
  }
}
