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
    final HttpLink httpLink = HttpLink(kUrl, defaultHeaders: {
      'X-Parse-Application-Id': kParseApplicationId,
      'X-Parse-Client-Key': kParseClientKey,
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
      loginCallback(false, "Login fehlgeschlagen.");
      return;
    }
    // Safe the new token.
    safeStorage.write(
        key: "token",
        value: loginResult.data?["logIn"]["viewer"]["sessionToken"]);
    loginCallback(true, null);
  }

  /// Logsout a user by deleting the session token.
  Future<void> logout() async {
    const safeStorage = FlutterSecureStorage();
    await safeStorage.delete(key: "token");
  }

  /// Checks if token is valid.
  Future<bool> checkToken() async {
    // The session token.
    String? token = await safeStorage.read(key: "token");
    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to the database.
      final HttpLink httpLink = HttpLink(kUrl, defaultHeaders: {
        'X-Parse-Application-Id': kParseApplicationId,
        'X-Parse-Client-Key': kParseClientKey,
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
      if (queryResult.hasException) {
        return false;
      } else {
        return true;
      }
    }
    // no token, return false
    return false;
  }

  /// Get a single [Statement] from the Database by [Statement.objectId].
  Future<Statement?> getStatement(String? statementID) async {
    final HttpLink httpLink = HttpLink(kUrl, defaultHeaders: {
      'X-Parse-Application-Id': kParseApplicationId,
      'X-Parse-Client-Key': kParseClientKey,
    });
    // create the data provider
    GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );
    var queryResult = await client.query(
      QueryOptions(
        document: gql(Queries.getStatement(statementID)),
      ),
    );
    if (queryResult.hasException) {
      return null;
    }
    return Statement.fromMap(queryResult.data?["statement"]);
  }

  /// Search for [Statements] from the Database by [String].
  ///
  /// If [query] is empty or null, return the newest [Statements].
  Future<Statements?> searchStatements(String? query) async {
    final HttpLink httpLink = HttpLink(kUrl, defaultHeaders: {
      'X-Parse-Application-Id': kParseApplicationId,
      'X-Parse-Client-Key': kParseClientKey,
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
  Future<Statements?> getSafedStatements() async {}

  /// Fetch all Friends ([Enemies]) of a [Player].
  Future<Enemies?> getFriends() async {}

  /// Authenticate a [Player] to get its emoji etc.
  Future<Player?> authenticate() async {}

  /// Search all Users to get new [Enemies].
  Future<Enemies?> searchFriends(String? friendsQuery) async {}
}
