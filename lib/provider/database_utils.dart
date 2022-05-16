import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quellenreiter_app/models/enemy.dart';
import 'package:quellenreiter_app/models/game.dart';
import 'package:quellenreiter_app/models/player.dart';
import '../consonents.dart';
import '../constants/constants.dart';
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

  /// Signup a user.
  ///
  // Emoji can not be safed while not authenticated.
  // 1. signup with username and password,
  // 2. create userdata with emoji and so on!
  // 3. turn on class protection on back4app.
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
    await safeStorage.write(
        key: "token",
        value: signUpResult.data?["signUp"]["viewer"]["sessionToken"]);

    // parse player.
    var player = Player.fromMap(signUpResult.data?["signUp"]["viewer"]["user"]);
    player.emoji = emoji;

    // upload emoji
    await createUserData(player, (p) => {player = p});

    signUpCallback(player);
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
        friendRequestCallback(Enemies.fromFriendshipMap(
            queryResult.data?["friendships"], player));
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

  /// Update a [Player] in the Database by [String]. Only for username!
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
          "user": player.toUserMap(),
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

  /// Update a [Player]s userdata in the Database by [String].
  ///
  /// Can be anything except username and auth stuff.
  Future<void> updateUserData(
      dynamic player, Function updateUserCallback) async {
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
        document: gql(Queries.updateUserData()),
        variables: {
          "user": player.toUserDataMap(),
        },
      ),
    );

    print(mutationResult);
    if (mutationResult.hasException) {
      updateUserCallback(null);
      return;
    } else {
      updateUserCallback(player
        ..updateDataWithMap(
            mutationResult.data?["updateUserData"]["userData"]));
      return;
    }
  }

  /// Create a [Player]s userdata in the Database by [String].
  ///
  /// Can be anything except username and auth stuff.
  Future<void> createUserData(
      Player player, Function createUserDataCallback) async {
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
          "user": player.toUserMapWithNewUserData(),
        },
      ),
    );

    print(mutationResult);
    if (mutationResult.hasException) {
      createUserDataCallback(null);
      return;
    } else {
      createUserDataCallback(
          Player.fromMap(mutationResult.data?["updateUser"]["user"]));
      return;
    }
  }

  /// Update a [Friendship] in the Database by [String].

  Future<bool> updateFriendship(Enemy enemy) async {
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
        document: gql(Queries.updateFriendship()),
        variables: {
          "friendship": enemy.toFriendshipMap(),
        },
      ),
    );

    print(mutationResult);
    if (mutationResult.hasException) {
      return false;
    } else {
      return true;
    }
  }

  /// Update a [Game] in the Database by [String].
  ///
  /// Can be a new name or emoji.
  Future<bool> updateGame(Enemy enemy) async {
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
        document: gql(Queries.updateGame()),
        variables: {
          "openGame": enemy.openGame!.toMap(),
        },
      ),
    );

    print(mutationResult);
    if (mutationResult.hasException) {
      return false;
    } else {
      return true;
    }
  }

  /// Upload a [Game] into the Database by [String].
  ///
  /// Can be a new name or emoji.
  Future<Game?> uploadGame(Enemy enemy) async {
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
    var temp = enemy.openGame!.toMap();
    temp.remove("id");

    // ERROR HERE !!!!
    var mutationResult = await client.mutate(
      MutationOptions(
        document: gql(Queries.uploadGame()),
        variables: {
          "openGame": temp,
        },
      ),
    );
    print(mutationResult);

    print(mutationResult);
    if (mutationResult.hasException) {
      return null;
    } else {
      return Game(
        //object Id
        mutationResult.data?["createOpenGame"][DbFields.friendshipOpenGame]
            ["objectId"],
        // enemyAnswers
        mutationResult.data?["createOpenGame"][DbFields.friendshipOpenGame][
                enemy.playerIndex == 0
                    ? DbFields.gameAnswersPlayer2
                    : DbFields.gameAnswersPlayer1]
            .map((x) => x["value"])
            .toList()
            .cast<bool>(),
        // player answers
        mutationResult.data?["createOpenGame"][DbFields.friendshipOpenGame][
                enemy.playerIndex == 0
                    ? DbFields.gameAnswersPlayer1
                    : DbFields.gameAnswersPlayer2]
            .map((x) => x["value"])
            .toList()
            .cast<bool>(),
        enemy.playerIndex,
        mutationResult.data?["createOpenGame"][DbFields.friendshipOpenGame]
                [DbFields.gameStatementIds]
            .map((x) => x["value"])
            .toList()
            .cast<String>(),
        mutationResult.data?["createOpenGame"][DbFields.friendshipOpenGame]
            [DbFields.gameWithTimer],
      );
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

  /// Function to find and load nine statements that have not been played by neither user.
  Future<List<String>?> getPlayableStatements(Enemy e, Player p) async {
    // setup statement db connection
    final HttpLink httpLinkStatementDB =
        HttpLink(statementDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': statementDatabaseApplicationID,
      'X-Parse-Client-Key': statementDatabaseClientKey,
    });
    // create the data provider
    GraphQLClient clientStatementDB = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLinkStatementDB,
    );
    // setup gameDB connection
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token == null) {
      return null;
    }
    // Link to the database.
    final HttpLink httpLinkUserDB = HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
      'X-Parse-Session-Token': token,
    });

    // The client that provides the connection.
    GraphQLClient clientUserDB = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLinkUserDB,
    );
    // combine played statements
    List<String> playedStatemntsCombined = e.playedStatementIds
      ..addAll(p.playedStatements!);
    // get 50 possible ids
    var playableStatements = await clientStatementDB.query(
      QueryOptions(
        document: gql(Queries.getStatements()),
        variables: {
          "ids": {
            "objectId": {"notIn": playedStatemntsCombined}
          }
        },
      ),
    );
    // if exception in query, return null.
    if (playableStatements.hasException) {
      return null;
    }
    // if not enough statements are accessible.
    if (playableStatements.data?["statements"]["edges"].length < 9) {
      return null;
    }
    // choose 9 random statements
    //     playableStatements.data?["statements"]["edges"];
    List<String> ids = playableStatements.data?["statements"]["edges"]
        .map((el) => el!["node"]["objectId"].toString())
        .toList()
        .cast<String>();
    // random shufflung
    ids.shuffle();
    // add to played statements of p and e
    e.playedStatementIds.addAll(ids.take(9));
    p.playedStatements!.addAll(ids.take(9));
    //upload game game
    e.openGame!.statementIds = ids.take(9).toList();
    e.openGame = await uploadGame(e);
    if (e.openGame == null) {
      return null;
    }
    //update p and e in database
    await updateUserData(p, (Player? player) {});

    await updateUserData(e, (Enemy? player) {});
    // update friendship
    await updateFriendship(e);
    // updateUser(player, updateUserCallback)
    return ids.take(9).toList();
  }
}
