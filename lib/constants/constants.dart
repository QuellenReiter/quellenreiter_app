import 'package:flutter/material.dart';

/// Contains colors that are needed repeatedly throughout the app.
class DesignColors {
  /// Color for text that sits ontop of Blue backgrounds.
  static const Color lightBlue = Color(0xFFc7ebeb);

  /// Color used for the Appbar and other blue backgrounds.
  static const Color backgroundBlue = Color(0xFF0999bc);

  /// Color used in the logo. Use for strong highlighting.
  static const Color pink = Color(0xFFff3a93);

  /// A lighter pink used for inactive cards.
  static const Color lightPink = Color.fromARGB(255, 255, 200, 225);

  /// Color used in the logo.
  static const Color yellow = Color(0xFFf5df5b);

  /// Color used for Fake News, manipulated news. Checked for colorblindness.
  static const Color red = Color(0xFFd55e00);

  /// Color used for Facts and real news. Checked for colorblindness.
  static const Color green = Color(0xFF009e73);

  /// Color for light grey backgrounds.
  static const Color lightGrey = Color(0xFFEEEEEE);

  /// Color for light grey backgrounds.
  static const Color black = Color.fromARGB(255, 23, 23, 23);

  /// Primary Swatch Pink

  static const MaterialColor pinkSwatch = MaterialColor(0xFFFF3A93, {
    50: Color.fromRGBO(255, 58, 147, 0.1),
    100: Color.fromRGBO(255, 58, 147, .2),
    200: Color.fromARGB(75, 255, 58, 147),
    300: Color.fromRGBO(255, 58, 147, .4),
    400: Color.fromRGBO(255, 58, 147, .5),
    500: Color.fromRGBO(255, 58, 147, .6),
    600: Color.fromRGBO(255, 58, 147, .7),
    700: Color.fromRGBO(255, 58, 147, .8),
    800: Color.fromRGBO(255, 58, 147, .9),
    900: Color.fromRGBO(255, 58, 147, 1),
  });
}

/// Contains the names of DatabaseFields that are needed for querying.
class DbFields {
  static const String statementText = "statement";
  static const String statementPicture = "pictureUrl";
  static const String statementYear = "year";
  static const String statementMonth = "month";
  static const String statementDay = "day";
  static const String statementMediatype = "mediatype";
  static const String statementLanguage = "language";
  static const String statementCorrectness = "correctness";
  static const String statementLink = "link";
  static const String statementRectification = "rectification";
  static const String statementCategory = "category";
  static const String statementPictureCopyright = "samplePictureCopyright";
  static const String statementAuthor = "author";
  static const String statementMedia = "media";
  static const String statementFactcheckIDs = "factcheckIDs";
  static const String statementPictureFile = "PictureFile";

  static const String factText = "fact";
  static const String factYear = "year";
  static const String factMonth = "month";
  static const String factDay = "day";
  static const String factLanguage = "language";
  static const String factLink = "link";
  static const String factArchivedLink = "archivedLink";
  static const String factAuthor = "author";
  static const String factMedia = "media";

  static const String userData = "userData";
  static const String userGamesWon = "numGamesWon";
  static const String userGamesTied = "numGamesTied";
  static const String userEmoji = "emoji";
  static const String userName = "username";
  static const String userPlayedGames = "numPlayedGames";
  static const String userFriendships = "friendships";
  static const String userTrueCorrectAnswers = "trueCorrectAnswers";
  static const String userTrueFakeAnswers = "trueFakeAnswers";
  static const String userFalseCorrectAnswers = "falseCorrectAnswers";
  static const String userFalseFakeAnswers = "falseFakeAnswers";
  static const String userPlayedStatements = "playedStatements";
  static const String userSafedStatements = "safedStatements";
  static const String userDeviceToken = "deviceToken";
  static const String userNumFriends = "numFriends";

  static const String friendshipOpenGame = "openGame";
  static const String friendshipNumGamesPlayed = "numPlayedGames";
  static const String friendshipPlayer1 = "player1";
  static const String friendshipPlayer2 = "player2";
  static const String friendshipWonGamesPlayer1 = "wonGamesPlayer1";
  static const String friendshipWonGamesPlayer2 = "wonGamesPlayer2";
  static const String friendshipPlayer1Id = "player1Id";
  static const String friendshipPlayer2Id = "player2Id";

  static const String friendshipApproved1 = "approvedPlayer1";
  static const String friendshipApproved2 = "approvedPlayer2";

  static const String openGameStatements = "statements";

  static const String gameStatementIds = "statementIds";
  static const String gameWithTimer = "withTimer";
  static const String gameAnswersPlayer1 = "answersPlayer1";
  static const String gameAnswersPlayer2 = "answersPlayer2";
  static const String gamePlayer1 = "player1";
  static const String gamePlayer2 = "player2";
  static const String gameRequestingPlayerIndex = "requestingPlayerIndex";
  static const String gamePointsAccessed = "pointsAccessed";
  static const String gamePlayer1Id = "player1Id";
  static const String gamePlayer2Id = "player2Id";
}

/// Provide all possible Screens a user can navigate to.
enum Routes {
  home,
  settings,
  friends,
  archive,
  login,
  signUp,
  quest,
  gameReadyToStart,
  loading,
  addFriends,
  gameFinishedScreen,
  tutorial,
  readyToStartOnlyLastScreen
}

/// Contains all possible categories a [Statement] can have.
class CorrectnessCategory {
  static String correct = "richtig";
  static String unverified = "unbelegt";
  static String falseContext = "falscher Kontext";
  static String manipulated = "manipuliert";
  static String misleading = "irreführend";
  static String fabricatedContent = "frei erfunden";
  static String falseInformation = "Fehlinformation";
  static String satire = "Satire";

  static int length() {
    return 8;
  }

  static String at(int i) {
    switch (i) {
      case 0:
        return correct;
      case 1:
        return unverified;
      case 2:
        return falseContext;
      case 3:
        return manipulated;
      case 4:
        return misleading;
      case 5:
        return fabricatedContent;
      case 6:
        return falseInformation;
      case 7:
        return satire;
      default:
        return correct;
    }
  }

  static bool isFact(String category) {
    return category == CorrectnessCategory.correct;
  }
}

class CorrectnessCategoryExplanation {
  static String correct = "Die Aussage stimmt.";
  static String unverified =
      "Es gibt keine Belege für die Richtigkeit dieser Aussage.";
  static String falseContext =
      "Die Aussage wird in einem falschen oder fehlenden Kontext dargestellt.";
  static String manipulated =
      "Das Video oder Bild wurde nachträglich bearbeitet.";
  static String misleading =
      "Etwas wird falsch interpretiert oder hat sich nicht so zugetragen, wie behauptet wird.";
  static String fabricatedContent = "Die Inhalte sind erfunden worden.";
  static String falseInformation =
      "Die Aussage wurde versehentlich falsch wiedergegeben. Die Fehler wurden daraufhin vom Medium korrigiert.";
  static String satire =
      " Es handelt sich um Satire, die jedoch nicht als solche zu erkennen ist.";
  static String at(int i) {
    switch (i) {
      case 0:
        return correct;
      case 1:
        return unverified;
      case 2:
        return falseContext;
      case 3:
        return manipulated;
      case 4:
        return misleading;
      case 5:
        return fabricatedContent;
      case 6:
        return falseInformation;
      case 7:
        return satire;
      default:
        return correct;
    }
  }
}

/// Provide public [Uri]s for links within the app.
class PublicURLs {
  static const String _domain = "quellenreiter.app";
  static const String _scheme = "https";

  static final Uri privacyPolicy = Uri(
      scheme: _scheme,
      host: "www.iubenda.com",
      path: "privacy-policy/34563732");

  static final Uri supportUrl =
      Uri(scheme: _scheme, host: "forms.gle", path: "qwf8jg3fWt3tVsQi8");
  static final Uri quellenreiterWebsite = Uri(
    scheme: _scheme,
    host: _domain,
  );
  static final Uri impressum = Uri(
    scheme: _scheme,
    host: _domain,
    path: "Impressum",
  );
}

/// Provide Rules for playing a [Game].
class GameRules {
  /// The number of statements that are shown in a round.
  static const int statementsPerRound = 3;

  /// The number of rounds that are played in a game.
  static const int roundsPerGame = 3;

  /// The number of statements that are shown in a game.
  static const int statementsPerGame = statementsPerRound * roundsPerGame;

  /// The number of Point that are given for a won game.
  static const int pointsPerWonGame = 20;

  /// The number of points a player gets for a tied game.
  static const int pointsPerTiedGame = 5;

  /// The number of points a player gets for answering a statement correctly.
  static const int pointsPerCorrectAnswer = 12;

  /// Returns the upper xp boundary of a given level.
  static int levelUpperBoundary(int level) {
    return (5 * (level + 1) * (9 + (level + 1))) - 50;
  }

  static int currentLevel(int xp) {
    int level = 0;
    while (xp >= levelUpperBoundary(level)) {
      level++;
    }
    return level;
  }

  /// Returns the amount of XP needed to reach the next level.
  static int xpForNextLevel(int xp) {
    int level = 0;
    while (xp >= levelUpperBoundary(level)) {
      level++;
    }
    return levelUpperBoundary(level);
  }

  /// Return the amount of XP needed for current level.
  static int xpForCurrentLevel(int xp) {
    int level = 0;
    while (xp >= levelUpperBoundary(level)) {
      level++;
    }
    return levelUpperBoundary(level - 1);
  }

  /// Returns the amount of XP needed to reach the next next level.
  static int xpForNextNextLevel(int xp) {
    int level = 0;
    while (xp >= levelUpperBoundary(level)) {
      level++;
    }
    return levelUpperBoundary(level + 1);
  }

  static String testStatementId = "uNBPKPaeRt";
}
