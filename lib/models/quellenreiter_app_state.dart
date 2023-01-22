import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/database_utils.dart';
import 'player_relation.dart';
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

  /// Sets the [_error] to the given value.
  ///
  /// @param value The new error message.
  set msg(value) {
    _error = value;
    notifyListeners();
  }

  /// The current [Game]. If [Player] is not playing, [_game] is null.
  Game? _game;
  Game? get game => _game;

  /// Sets the [_game] to the given value.
  ///
  /// @param value The new [Game].
  set game(value) {
    _game = value;
    notifyListeners();
  }

  /// All known relations of the [Player].
  PlayerRelationCollection _playerRelations = PlayerRelationCollection.empty();
  PlayerRelationCollection get playerRelations => _playerRelations;

  set playerRelations(value) {
    _playerRelations = value;
    notifyListeners();
  }

  /// The current [LocalPlayer]. Should be set, if user is logged in.
  LocalPlayer? _player;
  LocalPlayer? get player => _player;

  /// Sets the [_player] to the given value.
  ///
  /// @param value The new [Player].
  set player(value) {
    _player = value;
    notifyListeners();
  }

  /// The [Games] that are open currently.
  Games? _openGames;
  Games? get openGames => _openGames;

  /// Sets the [_openGames] to the given value.
  ///
  /// @param value The new [Games] that are open currently.
  set openGames(value) {
    _openGames = value;
    notifyListeners();
  }

  /// The [PlayerRelation] of the current game. Set when user selects game.
  PlayerRelation? _focusedPlayerRelation;
  PlayerRelation? get focusedPlayerRelation => _focusedPlayerRelation;

  /// Sets the [_focusedPlayerRelation] to the given value.
  ///
  /// @param value The new [PlayerRelation] whose game is currently being viewed by the user.
  set focusedPlayerRelation(value) {
    _focusedPlayerRelation = value;
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

  /// Gets if user wants notifications.
  /// if user has not set the value yet, the default value is true.
  /// The new value is pushed to the database.
  bool get notificationsAllowed {
    bool? value = prefs.getBool('notificationsAllowed');
    if (value == null) {
      value = true;
      prefs.setBool('notificationsAllowed', value);
      updateDeviceTokenForPushNotifications();
    }
    return value;
  }

  /// Sets the _notificationsAllowed to the given value.
  /// The new value is pushed to the database.
  set notificationsAllowed(value) {
    prefs.setBool('notificationsAllowed', value);
    updateDeviceTokenForPushNotifications();
    notifyListeners();
  }

  /// The [PlayerRelationCollection] (Friends) search result, if [Player] is searching.
  PlayerRelationCollection? _friendsSearchResult;
  PlayerRelationCollection? get friendsSearchResult => _friendsSearchResult;
  set friendsSearchResult(value) {
    _friendsSearchResult = value;
    notifyListeners();
  }

  /// Resets the [_friendsSearchResult] and the [_friendsSearchQuery].
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
      getPlayerRelations();
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

  Future<void> getPlayerRelations() async {
    PlayerRelationCollection? dbRelations = await db.getFriends(player!);

    if (dbRelations != null) {
      playerRelations = dbRelations;
      notifyListeners();
      _restoreFocusedPlayerRelation();
    }

    // update number of friends
    int nFriends = playerRelations.friends.length;
    if (player!.numFriends != nFriends) {
      player!.numFriends = nFriends;
      await db.updateUserData(player!, (Player? p) {});
    }
  }

  void sendFriendRequest(PlayerRelation _playerRelation) {
    route = Routes.loading;
    db.sendFriendRequest(this, _playerRelation.opponent.id, _sendFriendRequest);
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

  /// Restore the [focusedPlayerRelation] in the [player]'s friends.
  ///
  /// Used after [PlayerRelation]s are downloaded from the server.
  /// Needed to restore the [focusedPlayerRelation] after a reload.
  /// If User is looking at Game Results or something alike.
  void _restoreFocusedPlayerRelation() {
    // redo current opponent
    if (focusedPlayerRelation != null) {
      try {
        var _tempFocusedPlayerRelation = playerRelations.friends.firstWhere(
            (pr) => pr.opponent.id == focusedPlayerRelation!.opponent.id);
        // Only update [focusedPlayerRelation] if they have played 3 quests so that the
        // game is either finished or it is the player's turn now.
        // This prevents constant updating while the player is browsing the quests.
        if (_tempFocusedPlayerRelation.openGame != null &&
            _tempFocusedPlayerRelation.openGame!.opponent.amountAnswered % 3 ==
                0) {
          focusedPlayerRelation = _tempFocusedPlayerRelation;
        }
      } catch (e) {
        focusedPlayerRelation = null;
      }
    }
  }

  void logout() async {
    route = Routes.loading;
    //remove devie from the users push list.
    prefs.setBool('notificationsAllowed', false);
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

  void acceptRequest(PlayerRelation opp) {
    route = Routes.loading;
    db.acceptFriendRequest(player!, opp, _acceptRequestCallback);
  }

  void _acceptRequestCallback(bool success) async {
    if (!success) {
      route = Routes.home;
    } else {
      await getPlayerRelations();
      route = Routes.home;
    }
  }

  void searchFriends() {
    if (friendsQuery != null) {
      if (playerRelations.friends.isEmpty) {
        db.searchFriends(friendsQuery!, [player!.name], _searchFriendsCallback);
      }
      db.searchFriends(friendsQuery!, getNames(), _searchFriendsCallback);
    }
  }

  void _searchFriendsCallback(PlayerRelationCollection? opp) {
    route = Routes.addFriends;
    if (opp != null) {
      friendsSearchResult = opp;
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

  Future<void> _updateUserCallback(LocalPlayer? p) async {
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

  void startNewGame(PlayerRelation _playerRelation, bool withTimer) async {
    Routes tempRoute = route;
    route = Routes.loading;
    // update player and opponent here, to be up to date with played statements
    await getPlayerRelations();

    // get potentially updated instance of same [_playerRelation]
    _playerRelation = playerRelations.friends.firstWhere((playerRelation) =>
        playerRelation.opponent.id == _playerRelation.opponent.id);

    // if an open game exists, check if its new or delete it
    if (_playerRelation.openGame != null &&
        (!_playerRelation.openGame!.gameFinished() ||
            !_playerRelation.openGame!.pointsAccessed)) {
      // the existing  game is not finished and the points are not accessed
      msg =
          "Ein offenes spiel existiert bereits. Beende es bevor du ein neues startest.";
      return;
    } else if (_playerRelation.openGame != null) {
      // delete the old game, it is finished
      await db.deleteGame(_playerRelation.openGame!);
    }

    // delete old game
    _playerRelation.openGame = Game.empty(withTimer, _playerRelation, player!);
    _playerRelation.openGame!.statementIds =
        await db.getPlayableStatements(_playerRelation, player!);

    if (_playerRelation.openGame!.statementIds == null) {
      // reset game because not started
      _playerRelation.openGame = null;
      route = tempRoute;
      db.error ??
          "Spielstarten fehlgeschlagen. ${_playerRelation.opponent.emoji} ${_playerRelation.opponent.name} wurde nicht herausgefordert. Versuche es erneut.";
      return;
    }
    db.sendPushGameStartet(this, receiverId: _playerRelation.opponent.id);
    await getPlayerRelations();

    // if successfully fetched statements
    route = tempRoute;
    msg =
        "${_playerRelation.opponent.emoji} ${_playerRelation.opponent.name} wurde herausgefordert";

    return;
  }

  void getCurrentStatements() async {
    Game currentGame = focusedPlayerRelation!.openGame!;
    if (db.error != null) {
      return;
    }
    currentGame.statements = await db.getStatements(currentGame.statementIds!);
    notifyListeners();
    return;
  }

  /// Starts the open [Game] with the [focusedPlayerRelation].
  /// Only if it is the [Player]s turn.
  void playGame() async {
    HapticFeedback.mediumImpact();

    gameStarted = true;
    if (route != Routes.loading) {
      route = Routes.loading;
    }

    Game? currentGame = focusedPlayerRelation!.openGame;

    if (currentGame != null && currentGame.isPlayersTurn()) {
      // download statements
      currentGame.statements =
          await db.getStatements(currentGame.statementIds!);
      // check if error
      if (currentGame.statements == null) {
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
                  const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  const SizedBox(
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
                  const SizedBox(
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
    return playerRelations.getNames()..add(player!.name);
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
          debugPrint("token is null, are you on an iOS simulator?");
          return;
        }
        player!.deviceToken = token;
      } on PlatformException catch (e) {
        debugPrint("error: ${e.message}");
      }
    }
    // push new token to db
    await db.updateUser(player!, (LocalPlayer? p) {});
  }
}
