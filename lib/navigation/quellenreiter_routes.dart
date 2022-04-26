import 'package:quellenreiter_app/models/quellenreiter_app_state.dart';

import '../constants/constants.dart';

/// Class defining all Routes (Pages) in the Fact Browser app.
class QuellenreiterRoutePath {
  /// The [QuellenreiterAppState] to define the routes.
  final Routes route;

  QuellenreiterRoutePath(this.route);

  /// Currently on Home Page?
  bool get isHomePage => route == Routes.home;

  /// Currently on Friends Page?
  bool get isFriendsPage => route == Routes.friends;

  /// Currently on Settings Page?
  bool get isSettingsPage => route == Routes.settings;

  /// Currently on OpenGames Page?
  bool get isOpenGames => route == Routes.openGames;

  /// Currently on Archive Page?
  bool get isArchivePage => route == Routes.archive;

  /// Currently on startGame Page?
  bool get isStartGame => route == Routes.startGame;

  /// Currently on gameResults Page?
  bool get isGameResults => route == Routes.gameResults;

  /// Currently on gameReadyToStart Page?
  bool get isGameReadyToStart => route == Routes.gameReadyToStart;

  /// Currently on quest Page?
  bool get isQuestScreen => route == Routes.quest;

  /// Currently on Login Page?
  bool get isLoginPage => route == Routes.login;

  /// Currently on signUp Page?
  bool get isSignUpPage => route == Routes.signUp;
}
