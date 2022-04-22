import '../models/game.dart';

/// Class defining all Routes (Pages) in the Fact Browser app.
class QuellenreiterRoutePath {
  ///  The game currently played. Also containing the questIndex to decide which
  ///  quest to show.
  final Game? game;

  /// Stores if user navigated to home page.
  final bool viewHome;

  /// Stores if user navigated to friends page.
  final bool viewFriends;

  /// Stores if user navigated to settings page.
  final bool viewSettings;

  /// Stores if user navigated to openGames page.
  final bool viewOpenGames;

  /// Stores if user navigated to archive page.
  final bool viewArchive;

  /// Stores if user navigated to startGame page.
  final bool viewStartGame;

  /// Stores wether the user is logged in.
  final bool isLoggedIn;

  /// Stores wether the user wants to sign up.
  final bool showSignUp;

  final String? friendsQuery;

  QuellenreiterRoutePath.login()
      : game = null,
        friendsQuery = null,
        viewHome = false,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = false,
        showSignUp = false;

  QuellenreiterRoutePath.signUp()
      : game = null,
        viewHome = false,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = false,
        showSignUp = true;
  QuellenreiterRoutePath.home()
      : game = null,
        viewHome = true,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.friends(query)
      : game = null,
        friendsQuery = query,
        viewHome = false,
        viewFriends = true,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = false,
        showSignUp = true;
  QuellenreiterRoutePath.settings()
      : game = null,
        viewHome = false,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = true,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.openGames()
      : game = null,
        viewHome = false,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = true,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.archive()
      : game = null,
        viewHome = false,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = true,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.startGame()
      : game = null,
        viewHome = false,
        friendsQuery = null,
        viewFriends = false,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = true,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.gameResults(this.game)
      : viewFriends = false,
        viewHome = false,
        friendsQuery = null,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.gameReadyToStart(this.game)
      : viewFriends = false,
        viewHome = false,
        friendsQuery = null,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;
  QuellenreiterRoutePath.questScreen(this.game)
      : viewFriends = false,
        viewHome = false,
        friendsQuery = null,
        viewSettings = false,
        viewOpenGames = false,
        viewArchive = false,
        viewStartGame = false,
        isLoggedIn = true,
        showSignUp = false;

  /// Currently on Home Page?
  bool get isHomePage => viewHome;

  /// Are we in main navigation but not on home?
  bool get isMainButNotHome => !viewHome && (game == null) && isLoggedIn;

  /// Currently on Friends Page?
  bool get isFriendsPage => viewFriends;

  /// Currently on Settings Page?
  bool get isSettingsPage => viewSettings;

  /// Currently on OpenGames Page?
  bool get isOpenGames => viewOpenGames;

  /// Currently on Archive Page?
  bool get isArchivePage => viewArchive;

  /// Currently on startGame Page?
  bool get isStartGame => viewStartGame;

  /// Currently on gameResults Page?
  bool get isGameResults => game!.statementIndex == 4;

  /// Currently on gameReadyToStart Page?
  bool get isGameReadyToStart => game!.statementIndex == 0;

  /// Currently on quest Page?
  bool get isQuestScreen =>
      0 < game!.statementIndex && game!.statementIndex < 4;

  /// Currently on Login Page?
  bool get isLoginPage => isLoggedIn && !showSignUp;

  /// Currently on signUp Page?
  bool get isSignUpPage => showSignUp;
}
