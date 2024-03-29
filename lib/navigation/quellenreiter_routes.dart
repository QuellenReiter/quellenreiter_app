import '../constants/constants.dart';

/// Class defining all Routes (Pages) in the Fact Browser app.
class QuellenreiterRoutePath {
  /// The [QuellenreiterRoutePath] to define the routes.
  final Routes route;

  /// the friends query
  final String? friendsQuery;

  QuellenreiterRoutePath(this.route, {this.friendsQuery});

  /// Currently on Home Page?
  bool get isHomePage => route == Routes.home;

  /// Currently on Friends Page?
  bool get isFriendsPage => route == Routes.friends;

  /// Currently on Friends Page?
  bool get isAddFriendsPage => route == Routes.addFriends;

  /// Currently on Settings Page?
  bool get isSettingsPage => route == Routes.settings;

  /// Currently on Archive Page?
  bool get isArchivePage => route == Routes.archive;

  /// Currently on tutorial Page?
  bool get isGameResults => route == Routes.tutorial;

  /// Currently on gameReadyToStart Page?
  bool get isGameReadyToStart => route == Routes.gameReadyToStart;

  /// Currently on readyToStartOnlyLastScreen Page?
  bool get isGameReadyToStartOnlyLast =>
      route == Routes.readyToStartOnlyLastScreen;

  /// Currently on quest Page?
  bool get isQuestScreen => route == Routes.quest;

  /// Currently on Login Page?
  bool get isLoginPage => route == Routes.login;

  /// Currently on signUp Page?
  bool get isSignUpPage => route == Routes.signUp;
}
