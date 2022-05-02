import '../constants/constants.dart';
import '../models/fact.dart';
import '../models/player.dart';

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
      user{
        objectId
        ${DbFields.userName}
        ${DbFields.userEmoji}
        ${DbFields.userPlayedGames}
        ${DbFields.userTrueCorrectAnswers}
        ${DbFields.userFalseCorrectAnswers}
        ${DbFields.userTrueFakeAnswers}
        ${DbFields.userFalseFakeAnswers}
      }
      sessionToken
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL mutation to login.
  static String signUp(String username, String password) {
    String ret = '''
mutation SignUp{
  signUp(input: {
    username: "$username"
    password: "$password"
  }){
    viewer{
      user{
        objectId
        ${DbFields.userName}
        ${DbFields.userEmoji}
        ${DbFields.userPlayedGames}
        ${DbFields.userTrueCorrectAnswers}
        ${DbFields.userFalseCorrectAnswers}
        ${DbFields.userTrueFakeAnswers}
        ${DbFields.userFalseFakeAnswers}
      }
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
    user{
      objectId
      ${DbFields.userName}
      ${DbFields.userEmoji}
      ${DbFields.userPlayedGames}
      ${DbFields.userTrueCorrectAnswers}
      ${DbFields.userFalseCorrectAnswers}
      ${DbFields.userTrueFakeAnswers}
      ${DbFields.userFalseFakeAnswers}
    }
    sessionToken
  }
}
''';
    return ret;
  }

  static String updateFriendshipStatus(String id) {
    String ret = '''
mutation updateFriendship{
  updateFriendship(
    input:{
      id: "$id"
      fields:{
        ${DbFields.friendshipApproved1}: true
        ${DbFields.friendshipApproved2}: true
      }
    }
  ){
    friendship{
      objectId
    }
  }
}
''';
    return ret;
  }

  /// Returns the graphQL query to check the friend requests.
  static String getFriends(Player player) {
    String ret = '''
query GetOpenFriendRequests{
  friendships(
    where:{
      OR:[
        {${DbFields.friendshipPlayer1}: { have:{objectId : { equalTo: "${player.id}"}}}}
        {${DbFields.friendshipPlayer2}: { have:{objectId : { equalTo: "${player.id}"}}}}
      ]
    }
  ){
    edges{
      node{
        objectId
        ${DbFields.friendshipPlayer1} (where:  { objectId: {notEqualTo: "${player.id}"} }){
          edges{
            node{
              objectId
              ${DbFields.userName}
              ${DbFields.userEmoji}
            }
          }
        }
        ${DbFields.friendshipPlayer2} (where:  { objectId: {notEqualTo: "${player.id}"} }){
          edges{
            node{
              objectId
              ${DbFields.userName}
              ${DbFields.userEmoji}
            }
          }
        }
        ${DbFields.friendshipOpenGame}{
          edges{
            node{
              createdAt
              objectId
            }
          }
        }
        ${DbFields.friendshipWonGamesPlayer1}
        ${DbFields.friendshipWonGamesPlayer2}
        ${DbFields.friendshipNumGamesPlayed}
        ${DbFields.friendshipApproved1}
        ${DbFields.friendshipApproved2}
        ${DbFields.friendshipOpenGame}{
          edges{
            node{
              objectId
              createdAt
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

  static String searchFriends(String query, List<String> friendNames) {
    String friendsString = "[";
    for (String word in friendNames) {
      friendsString += "\"$word\",";
    }
    friendsString += "]";

    String ret = '''
query GetOpenFriendRequests{
  users(
    where:{
      AND:[
        { ${DbFields.userName}: { equalTo: "$query"} }
        { ${DbFields.userName}: { notIn: $friendsString} }
      ]
    }
  ){
    edges{
      node{
        objectId
        ${DbFields.userName}
        ${DbFields.userEmoji}
      }
    }
  }
}
    
''';
    return ret;
  }

  static String sendFriendRequest(String playerId, String enemyId) {
    String ret = '''
mutation sendFriendRequest {
  createFriendship(
    input: {
      fields:{
        ${DbFields.friendshipPlayer1}:{
          add:"$playerId"
        }
        ${DbFields.friendshipPlayer2}:{
          add: "$enemyId"
        }
        ${DbFields.friendshipApproved1}: true
        ${DbFields.friendshipApproved2}: false
      }
    }
  ) {
    friendship{
      objectId
    }
  }
}


''';
    return ret;
  }
//   /// Returns the graphQL query to check the friend requests.
//   static String acceptFriendRequest(Player player, String friendshipId) {
//     String ret = '''
// mutation AcceptFriendRequest{
//   updateUser(
//     input: {
//       id: "${player.id}"
//       fields: {
//         friendships: {
//           add: "$friendshipId"
//         }
//       }
//     }
//   ){
//     user{
//       objectId
//       ${DbFields.userName}
//       ${DbFields.userEmoji}
//       ${DbFields.userPlayedGames}
//       ${DbFields.userTrueCorrectAnswers}
//       ${DbFields.userFalseCorrectAnswers}
//       ${DbFields.userTrueFakeAnswers}
//       ${DbFields.userFalseFakeAnswers}
//     }
//   }
// }
// ''';
//     return ret;
//   }
//   static String getFriends(Player user) {
//     String ret = '''
// query GetFriends{
//   user(id:"${user.id}"){
//     objectId
//     ${DbFields.userName}
//     ${DbFields.userEmoji}
//     ${DbFields.userPlayedGames}
//     ${DbFields.userTrueCorrectAnswers}
//     ${DbFields.userFalseCorrectAnswers}
//     ${DbFields.userTrueFakeAnswers}
//     ${DbFields.userFalseFakeAnswers}
//     ${DbFields.userFriendships}{
//       edges{
//         node{
//           objectId
//           ${DbFields.friendshipPlayer1} (where:  { username: {notEqualTo: "${user.name}}"} }){
//             edges{
//               node{
//                 objectId
//                 ${DbFields.userEmoji}
//                 ${DbFields.userName}
//               }
//             }
//           }
//           ${DbFields.friendshipPlayer2} (where:  { username: {notEqualTo: "${user.name}}"} }){
//             edges{
//               node{
//                 objectId
//                 ${DbFields.userEmoji}
//                 ${DbFields.userName}
//               }
//             }
//           }
//           ${DbFields.friendshipWonGamesPlayer1}
//           ${DbFields.friendshipWonGamesPlayer2}
//           ${DbFields.friendshipApproved2}
//           ${DbFields.friendshipNumGamesPlayed}
//           ${DbFields.friendshipApproved1}
//           ${DbFields.friendshipApproved2}
//           ${DbFields.friendshipOpenGame}{
//             edges{
//               node{
//                 objectId
//                 createdAt
//               }
//             }
//           }
//         }
//       }
//     }
//   }
// }

// ''';
//     return ret;
//   }

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
