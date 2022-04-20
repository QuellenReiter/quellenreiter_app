import '../constants/constants.dart';
import '../models/fact.dart';

/// Class containg various utilities for the database connection.
class Queries {
  /// Returns the graphQL query to search for [Statements].
  static String searchStatements(String query) {
    String ret = '''
  query searchStatementsByWord{
  statements(
    where:{
      OR:[
        { ${DbFields.statementText}: { matchesRegex: "$query", options: "i"} }
        { ${DbFields.statementMedia}: { matchesRegex: "$query", options: "i"} }
        { ${DbFields.statementFactcheckIDs} : { have:{ ${DbFields.factText}:{ matchesRegex: "$query", options: "i" } } } }
        { ${DbFields.statementFactcheckIDs} : { have:{ ${DbFields.factMedia}:{ matchesRegex: "$query", options: "i" } } } }
      ]
  }){
    edges{
      node{
        objectId
        ${DbFields.statementText}
        ${DbFields.statementPictureFile}{url}
        ${DbFields.statementYear}
        ${DbFields.statementMonth}
        ${DbFields.statementDay}
        ${DbFields.statementCorrectness}
        ${DbFields.statementMedia}
        ${DbFields.statementLanguage}
        ${DbFields.statementCategory}
        ${DbFields.statementMediatype}
        ${DbFields.statementAuthor}
        ${DbFields.statementLink}
        ${DbFields.statementRectification}
        ${DbFields.statementPictureCopyright}
        ${DbFields.statementFactcheckIDs}{
            edges{
              node{
                objectId
                ${DbFields.factText}
                ${DbFields.factAuthor}
                ${DbFields.statementYear}
                ${DbFields.statementMonth}
                ${DbFields.statementDay}
                ${DbFields.factLanguage}
                ${DbFields.factMedia}
                ${DbFields.factLink}
                ${DbFields.factArchivedLink}
              }
            }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL query to get to newest n statements.
  static String getnNewestStatements(int n) {
    String ret = '''
  query getNNewestStatements{
  statements(
      order: [createdAt_DESC],
    	first: $n
  ){
    edges{
      node{
        objectId
        ${DbFields.statementText}
        ${DbFields.statementPictureFile}{url}
        ${DbFields.statementYear}
        ${DbFields.statementMonth}
        ${DbFields.statementDay}
        ${DbFields.statementCorrectness}
        ${DbFields.statementMedia}
        ${DbFields.statementLanguage}
        ${DbFields.statementCategory}
        ${DbFields.statementMediatype}
        ${DbFields.statementAuthor}
        ${DbFields.statementLink}
        ${DbFields.statementRectification}
        ${DbFields.statementPictureCopyright}
        ${DbFields.statementFactcheckIDs}{
          edges{
            node{
              objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.statementYear}
              ${DbFields.statementMonth}
              ${DbFields.statementDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
            }
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to create a [Statement].
  static String createStatement() {
    String ret = '''
  mutation createAStatement(\$input: CreateStatementInput!){
  createStatement(
       input: \$input
    ){
  statement{
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
        edges{
          node{
            objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.factYear}
              ${DbFields.factMonth}
              ${DbFields.factDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to update a [Statement].
  static String updateStatement() {
    String ret = '''
  mutation updateAStatement(\$input: UpdateStatementInput!){
  updateStatement(
       input: \$input
    ){
  statement{
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
        edges{
          node{
            objectId
              ${DbFields.factText}
              ${DbFields.factAuthor}
              ${DbFields.factYear}
              ${DbFields.factMonth}
              ${DbFields.factDay}
              ${DbFields.factLanguage}
              ${DbFields.factMedia}
              ${DbFields.factLink}
              ${DbFields.factArchivedLink}
          }
        }
      }
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to delete a [Fact] by [Fact.objectId].
  static String deleteFact(String factId) {
    // how to ensure that facts are not duplicated but changes
    // are still updated..??

    String ret = '''
  mutation deleteAFact{
  deleteFactcheck(
    input:{
      id: "$factId"
    }
    ){
    factcheck{
      fact
    }
  }
}
  ''';
    return ret;
  }

  /// Returns the graphQL mutation to login.
  static String login(String username, String password) {
    String ret = '''
mutation LogIn{
  logIn(input: {
    username: "$username"
    password: "$password"
  }){
    viewer{
      sessionToken
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to check the current user.
  static String getCurrentUser() {
    String ret = '''
query GetCurrentUser{
  viewer{
    sessionToken
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to get a [Statement] by [Statement.objectId].
  static String getStatement(String? statementID) {
    String ret = '''
query getStatement{
  statement(
    	id: "$statementID"
  ){
    objectId
    ${DbFields.statementText}
    ${DbFields.statementPictureFile}{url}
    ${DbFields.statementYear}
    ${DbFields.statementMonth}
    ${DbFields.statementDay}
    ${DbFields.statementCorrectness}
    ${DbFields.statementMedia}
    ${DbFields.statementLanguage}
    ${DbFields.statementCategory}
    ${DbFields.statementMediatype}
    ${DbFields.statementAuthor}
    ${DbFields.statementLink}
    ${DbFields.statementRectification}
    ${DbFields.statementPictureCopyright}
    ${DbFields.statementFactcheckIDs}{
      edges{
        node{
          objectId
            ${DbFields.factText}
            ${DbFields.factAuthor}
            ${DbFields.factYear}
            ${DbFields.factMonth}
            ${DbFields.factDay}
            ${DbFields.factLanguage}
            ${DbFields.factMedia}
            ${DbFields.factLink}
            ${DbFields.factArchivedLink}
        }
      }
    }
  }
}
''';
    return ret;
  }
}
