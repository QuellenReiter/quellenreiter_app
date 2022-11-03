import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/database_utils.dart';
import 'opponent.dart';
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
  Opponents? _opponentRequests;
  Opponents? get opponentRequests => _opponentRequests;

  /// Sets the _opponentRequests to the given value.
  ///
  /// @param value The new [Opponents]. that requested to be friends with the current [Player].
  set opponentRequests(value) {
    _opponentRequests = value;
    notifyListeners();
  }

  /// Pending friend requests sent by the current [Player].
  Opponents? _pendingRequests;
  Opponents? get pendingRequests => _pendingRequests;

  /// Sets the _pendingRequests to the given value.
  ///
  /// @param value The  [Opponents]. that were invited by the current [Player].
  set pendingRequests(value) {
    _pendingRequests = value;
    notifyListeners();
  }

  /// opponents that have an open game where its the [Player] turn.
  Opponents? _playableOpponents;

  /// Sets the _playableOpponents to the given value.
  ///
  /// @param value The [Opponents] that have an open game where its the [Player] turn.
  Opponents? get playableOpponents => _playableOpponents;
  set playableOpponents(value) {
    _playableOpponents = value;
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

  /// The [Opponent] of the current game. Set when user selects game.
  Opponent? _currentOpponent;
  Opponent? get currentOpponent => _currentOpponent;

  /// Sets the _currentOpponent to the given value.
  ///
  /// @param value The new [Opponent] whose game is currently being viewed by the user.
  set currentOpponent(value) {
    _currentOpponent = value;
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
      prefs.setBool('notificationsAllowed', value);
      _notificationsAllowed = value;
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

  /// The [Opponents] (Friends) search result, if [Player] is searching.
  Opponents? _friendsSearchResult;
  Opponents? get friendsSearchResult => _friendsSearchResult;
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
    Opponents? opponents = await db.getFriends(player!);

    await _getFriendsCallback(opponents);
    return;
  }

  void sendFriendRequest(Opponent e) {
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
  /// If successfull, the [Opponents] are safed.
  /// They are split up into friends, requests, pending and playable games.
  /// Also the current opponent is restored and updated.
  ///
  /// @param opponents The [Opponents] returned from the server.
  Future<bool> _getFriendsCallback(Opponents? opponents) async {
    // if no friends were returned
    if (opponents == null) {
      // if no friends are currently downloaded
      if (player!.friends == null) {
        player?.friends = Opponents.empty();
      }
      // else, just keep the downloaded friends.
      return false;
    }
    // set friends
    var tempFriends = Opponents.empty()
      ..opponents = opponents.opponents
          .where((opponent) =>
              opponent.acceptedByOther && opponent.acceptedByPlayer)
          .toList();
    // set received requests
    var tempRequests = Opponents.empty()
      ..opponents = opponents.opponents
          .where((opponent) =>
              opponent.acceptedByOther && !opponent.acceptedByPlayer)
          .toList();
    // set pending requests
    var tempPending = Opponents.empty()
      ..opponents = opponents.opponents
          .where((opponent) =>
              !opponent.acceptedByOther && opponent.acceptedByPlayer)
          .toList();

    var tempPlayableOpponents = Opponents.empty()
      ..opponents = opponents.opponents
          .where((opponent) =>
              (opponent.openGame != null && opponent.openGame!.isPlayersTurn()))
          .toList();

    player?.friends = tempFriends;
    // set new number of friends
    if (player!.numFriends != tempFriends.opponents.length) {
      player!.numFriends = tempFriends.opponents.length;
      await db.updateUserData(player, (Player? p) {});
    }
    player?.numFriends = tempFriends.opponents.length;
    opponentRequests = tempRequests;
    pendingRequests = tempPending;
    playableOpponents = tempPlayableOpponents;
    // redo current opponent
    if (currentOpponent != null) {
      try {
        var tempCurrentOpponent = player!.friends!.opponents.firstWhere(
            (opponent) => opponent.userId == currentOpponent!.userId);
        // Only update current opponent if they have played 3 quests so that the
        // game is either finished or it is the player's turn now.
        // This prevents constant updating while the player is browsing the quests.
        if (tempCurrentOpponent.openGame != null &&
            tempCurrentOpponent.openGame!.opponent.answers.length % 3 == 0) {
          currentOpponent = tempCurrentOpponent;
        }
      } catch (e) {
        currentOpponent = null;
      }
    }
    return true;
  }

  void logout() async {
    route = Routes.loading;
    //remove devie from the users push list.
    prefs.setBool('notificationsAllowed', false);
    _notificationsAllowed = false;
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

  void acceptRequest(Opponent opp) {
    route = Routes.loading;
    db.acceptFriendRequest(player!, opp, _acceptRequestCallback);
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

  void _searchFriendsCallback(Opponents? opp) {
    if (opp != null) {
      route = Routes.addFriends;
      friendsSearchResult = opp;
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

  void startNewGame(Opponent opp, bool withTimer) async {
    Routes tempRoute = route;
    route = Routes.loading;
    // update player and opponent here, to be updtodate with played statements
    await getFriends();
    //update opponent e
    opp = player!.friends!.opponents
        .firstWhere((opponent) => opponent.userId == opp.userId);
    // if an open game exists, check if its new or delete it
    if (opp.openGame != null &&
        (!opp.openGame!.gameFinished() || !opp.openGame!.pointsAccessed)) {
      // the existing  game is not finished and the points are not accessed
      msg =
          "Ein offenes spiel existiert bereits. Beende es bevor du ein neues startest.";
      return;
    } else if (opp.openGame != null) {
      // delete the old game, it is finished
      await db.deleteGame(opp.openGame!);
    }
    // delete old game
    opp.openGame = Game.empty(withTimer, opp, player!);
    opp.openGame!.statementIds = await db.getPlayableStatements(opp, player!);
    if (opp.openGame!.statementIds == null) {
      // reset game because not started
      opp.openGame = null;
      route = tempRoute;
      db.error ??
          "Spielstarten fehlgeschlagen. ${opp.emoji} ${opp.name} wurde nicht herausgefordert. Versuche es erneut.";
      return;
    }
    db.sendPushGameStartet(this, receiverId: opp.userId);
    await getFriends();
    // print(e.openGame!.statementIds.toString());
    // if successfully fetched statements
    route = tempRoute;
    msg = "${opp.emoji} ${opp.name} wurde herausgefordert";

    return;
  }

  void getCurrentStatements() async {
    if (db.error != null) {
      return;
    }
    currentOpponent!.openGame!.statements =
        await db.getStatements(currentOpponent!.openGame!.statementIds!);
    notifyListeners();
    return;
  }

  /// Starts an open game with the current opponent.
  /// Only if it is the [Player]s turn.
  void playGame() async {
    HapticFeedback.mediumImpact();

    gameStarted = true;
    if (route != Routes.loading) {
      route = Routes.loading;
    }
    if (currentOpponent!.openGame != null &&
        currentOpponent!.openGame!.isPlayersTurn()) {
      // download statements
      currentOpponent!.openGame!.statements =
          await db.getStatements(currentOpponent!.openGame!.statementIds!);
      // check if error
      if (currentOpponent!.openGame!.statements == null) {
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
    ret.addAll(opponentRequests!.getNames());
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
