import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';

/// Class defining all Routes (Pages) in the Fact Browser app.
class QuellenreiterRoutePath {
  /// The [QuellenreiterAppState] to define the routes.
  final QuellenreiterAppState appState;

  QuellenreiterRoutePath(this.appState);

  /// Currently on Home Page?
  bool get isHomePage => appState.route == Routes.home;

  /// Are we in main navigation but not on home?
  bool get isMainButNotHome =>
      !(appState.route == Routes.home) &&
      (appState.game == null) &&
      appState.isLoggedIn;

  /// Currently on Friends Page?
  bool get isFriendsPage => appState.route == Routes.friends;

  /// Currently on Settings Page?
  bool get isSettingsPage => appState.route == Routes.settings;

  /// Currently on OpenGames Page?
  bool get isOpenGames => appState.route == Routes.openGames;

  /// Currently on Archive Page?
  bool get isArchivePage => appState.route == Routes.archive;

  /// Currently on startGame Page?
  bool get isStartGame => appState.route == Routes.startGame;

  /// Currently on gameResults Page?
  bool get isGameResults => appState.route == Routes.gameResults;

  /// Currently on gameReadyToStart Page?
  bool get isGameReadyToStart => appState.route == Routes.gameReadyToStart;

  /// Currently on quest Page?
  bool get isQuestScreen => appState.route == Routes.quest;

  /// Currently on Login Page?
  bool get isLoginPage => appState.route == Routes.login;

  /// Currently on signUp Page?
  bool get isSignUpPage => appState.route == Routes.signUp;
}
