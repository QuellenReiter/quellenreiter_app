import 'package:flutter/material.dart';

/// Contains colors that are needed repeatedly throughout the app.
class DesignColors {
  /// Color for text that sits ontop of Blue backgrounds.
  static const Color lightBlue = Color(0xFFc7ebeb);

  /// Color used for the Appbar and other blue backgrounds.
  static const Color backgroundBlue = Color(0xFF0999bc);

  /// Color used in the logo. Use for strong highlighting.
  static const Color pink = Color(0xFFff3a93);

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

  static const String friendshipOpenGame = "openGame";
  static const String friendshipNumGamesPlayed = "numPlayedGames";
  static const String friendshipPlayer1 = "player1";
  static const String friendshipPlayer2 = "player2";
  static const String friendshipWonGamesPlayer1 = "wonGamesPlayer1";
  static const String friendshipWonGamesPlayer2 = "wonGamesPlayer2";

  static const String friendshipApproved1 = "approvedPlayer1";
  static const String friendshipApproved2 = "approvedPlayer2";

  static const String openGameStatements = "statements";

  static const String enemyName = "name";

  static const String gameStatementIds = "statementIds";
  static const String gameWithTimer = "withTimer";
  static const String gameAnswersPlayer1 = "answersPlayer1";
  static const String gameAnswersPlayer2 = "answersPlayer2";
  static const String gamePlayer1 = "player1";
  static const String gamePlayer2 = "player2";
}

enum Routes {
  home,
  settings,
  friends,
  startGame,
  archive,
  login,
  signUp,
  openGames,
  quest,
  gameResults,
  gameReadyToStart,
  loading,
  addFriends
}

class CorrectnessCategory {
  static String correct = "richtig";
  static String unverified = "unbelegt";
  static String falseContext = "falscher Kontext";
  static String manipulated = "manipuliert";
  static String misleading = "irreführend";
  static String fabricatedContent = "frei erfunden";
  static String falseInformation = "Fehlinformation";
  static String satire = "Satire";
}
