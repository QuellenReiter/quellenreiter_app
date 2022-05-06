import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/player.dart';
import '../consonents.dart';
import '../models/statement.dart';
import 'queries.dart';

/// This class facilitates the connection to the database and manages its
/// responses.
class DatabaseUtils {
  /// Object to access [FlutterSecureStorage].
  final safeStorage = const FlutterSecureStorage();

  /// Login a user.
  void login(String username, String password, Function loginCallback) async {
    // Link to server.
    final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
      //'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    // Provides data from server and facilitates requests.
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    // The result returned from the query.
    var loginResult = await client.mutate(
      MutationOptions(
        document: gql(Queries.login(username, password)),
      ),
    );
    // If login result has any exceptions.
    if (loginResult.hasException) {
      print(loginResult.exception.toString());
      loginCallback(null);
      return;
    }
    print(loginResult.data.toString());

    // Safe the new token.
    safeStorage.write(
        key: "token",
        value: loginResult.data?["logIn"]["viewer"]["sessionToken"]);
    loginCallback(Player.fromMap(loginResult.data?["logIn"]["viewer"]["user"]));
    // Safe the User
  }

  /// Login a user.
  void signUp(String username, String password, String emoji,
      Function signUpCallback) async {
    // Link to server.
    final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
      //'X-Parse-REST-API-Key' : kParseRestApiKey,
    });

    // Provides data from server and facilitates requests.
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    // The result returned from the query.
    var signUpResult = await client.mutate(
      MutationOptions(
        document: gql(Queries.signUp(username, password, emoji)),
      ),
    );
    print(signUpResult.toString());
    // If login result has any exceptions.
    if (signUpResult.hasException) {
      signUpCallback(null);
      return;
    }
    // Safe the new token.
    safeStorage.write(
        key: "token",
        value: signUpResult.data?["signUp"]["viewer"]["sessionToken"]);
    signUpCallback(
        Player.fromMap(signUpResult.data?["signUp"]["viewer"]["user"]));
  }

  /// Logsout a user by deleting the session token.
  Future<void> logout(Function logoutCallback) async {
    const safeStorage = FlutterSecureStorage();
    await safeStorage.delete(key: "token");
    logoutCallback();
  }

  /// Checks if token is valid.
  Future<void> checkToken(Function checkTokenCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // The client that provides the connection.
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      // The query result.
      var queryResult = await client.mutate(
        MutationOptions(
          document: gql(Queries.getCurrentUser()),
        ),
      );

      print(queryResult.toString());
      if (queryResult.hasException) {
        checkTokenCallback(null);
        return;
      } else {
        // Safe the new token.
        safeStorage.write(
            key: "token", value: queryResult.data?["viewer"]["sessionToken"]);
        checkTokenCallback(Player.fromMap(queryResult.data?["viewer"]["user"]));
        return;
      }
    }
    // no token, return false
    checkTokenCallback(null);
  }

  /// Get all friend requests.
  Future<void> getFriends(Player player, Function friendRequestCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // The client that provides the connection.
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      // The query result.
      var queryResult = await client.query(
        QueryOptions(
          document: gql(Queries.getFriends(player)),
        ),
      );

      print(queryResult.toString());
      if (queryResult.hasException) {
        friendRequestCallback(null);
        return;
      } else {
        friendRequestCallback(
            Enemies.fromFriendshipMap(queryResult.data?["friendships"]));
        return;
      }
    }
    // no token, return false
    friendRequestCallback(null);
    return;
  }

  /// Accept a friend request
  Future<void> acceptFriendRequest(
      Player p, Enemy e, Function acceptFriendCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // The client that provides the connection.
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      // Update the friendship to be accepted by both players.
      var mutationResult = await client.mutate(
        MutationOptions(
          document: gql(Queries.updateFriendshipStatus(e.friendshipId)),
        ),
      );

      print(mutationResult.toString());
      if (mutationResult.hasException) {
        acceptFriendCallback(false);
        return;
      } else {
        acceptFriendCallback(true);
        return;
      }
    }
    // no token, return false
    acceptFriendCallback(false);
    return;
  }

  /// Get a single [Statement] from the Database by [Statement.objectId].
  Future<Statement?> getStatement(String? statementID) async {
    final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
    });
    // create the data provider
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
    var queryResult = await client.query(
      QueryOptions(document: gql(Queries.getStatements()), variables: {
        "ids": {
          "objectId": {"in": "[\"$statementID\"]"}
        }
      }),
    );
    if (queryResult.hasException) {
      return null;
    }
    return Statement.fromMap(queryResult.data?["statement"]);
  }

  /// Update a [Player] in the Database by [String].
  ///
  /// Can be a new name or emoji.
  Future<void> updateUser(Player player, Function updateUserCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
      'X-Parse-Session-Token': token!,
    });
    // create the data provider
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
    var mutationResult = await client.mutate(
      MutationOptions(
        document: gql(Queries.updateUser()),
        variables: {
          "user": player.toMap(),
        },
      ),
    );

    print(mutationResult);
    if (mutationResult.hasException) {
      updateUserCallback(null);
      return;
    } else {
      updateUserCallback(
          Player.fromMap(mutationResult.data?["updateUser"]["user"]));
      return;
    }
  }

  /// Search for [Statements] from the Database by [String].
  ///
  /// If [query] is empty or null, return the newest [Statements].
  Future<Statements?> searchStatements(String? query) async {
    final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
    });
    // create the data provider
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
    var queryResult = await client.query(
      QueryOptions(
        document: query == null || query.isEmpty
            ? gql(
                Queries.getnNewestStatements(8),
              )
            : gql(
                Queries.searchStatements(query),
              ),
      ),
    );
    if (queryResult.hasException) {
      return null;
    }
    return Statements.fromMap(queryResult.data);
  }

  /// Fetch the open [Games] of a [Player]..
  Future<Games?> getOpenGames() async {}

  /// Fetch all safed/liked [Statements] from a [Player].
  Future<void> getSafedStatements(
      List<String> ids, Function getStatementsCallback) async {
    final HttpLink httpLink = HttpLink(statementDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': statementDatabaseApplicationID,
      'X-Parse-Client-Key': statementDatabaseClientKey,
    });
    // create the data provider
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
    var queryResult = await client.query(
      QueryOptions(
        document: gql(
          Queries.getStatements(),
        ),
        variables: {
          "ids": {
            "objectId": {"in": ids}
          }
        },
      ),
    );
    print(queryResult);
    if (queryResult.hasException) {
      getStatementsCallback(null);
    }
    getStatementsCallback(Statements.fromMap(queryResult.data));
  }

  /// Authenticate a [Player] to get its emoji etc.
  Future<Player?> authenticate() async {}

  Future<void> sendFriendRequest(String playerId, String enemyId,
      Function sendFriendRequestCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // The client that provides the connection.
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      // Update the friendship to be accepted by both players.
      var mutationResult = await client.mutate(
        MutationOptions(
          document: gql(Queries.sendFriendRequest(playerId, enemyId)),
        ),
      );

      print(mutationResult.toString());
      if (mutationResult.hasException) {
        sendFriendRequestCallback(false);
        return;
      } else {
        sendFriendRequestCallback(true);
        return;
      }
    }
    // no token, return false
    sendFriendRequestCallback(false);
    return;
  }

  /// Search all Users to get new [Enemies].
  Future<void> searchFriends(String friendsQuery, List<String> friendNames,
      Function searchFriendsCallback) async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // The client that provides the connection.
      GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      // The query result.
      var queryResult = await client.query(
        QueryOptions(
          document: gql(Queries.searchFriends(friendsQuery, friendNames)),
        ),
      );

      print(queryResult.toString());
      if (queryResult.hasException) {
        searchFriendsCallback(null);
        return;
      } else {
        searchFriendsCallback(Enemies.fromUserMap(queryResult.data?["users"]));
        return;
      }
    }
    // no token, return false
    searchFriendsCallback(null);
    return;
  }
}
