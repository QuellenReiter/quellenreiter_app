import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quellenreiter_app/provider/error_handler_singleton.dart';
import 'package:quellenreiter_app/provider/safe_storage.dart';

import '../consonents.dart';

/// This class is a super class for all database connections.
/// It provides the database connection and the error handler and the safestorage.
class DatabaseConnection {
  // Errorhandler refernce to singleton.
  ErrorHandlerSingleton errorHandler = ErrorHandlerSingleton();

  /// [GraphQLClient] client for the user database
  /// requires a token.
  GraphQLClient? userDatabaseClient;

  /// [GraphQLClient] for the statement database.
  /// Does not require a token.
  GraphQLClient statementDatabaseClient = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(statementDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': statementDatabaseApplicationID,
      'X-Parse-Client-Key': statementDatabaseClientKey,
    }),
  );

  /// Object to access Secure Storage.
  SafeStorageInterface safeStorage;

  /// Constor decides which implementation of [SafeStorageInterface] to use.
  /// Default is [SafeStoragePlugin].
  DatabaseConnection({this.safeStorage = const SafeStoragePlugin()});

  /// Creates [userDatabaseClient].
  Future<bool> createUserDatabaseClient() async {
    // The session token.
    String? token = await safeStorage.read(key: "token");

    // If token is not null, check if it is valid.
    if (token != null) {
      // Link to user database.
      final HttpLink userDatabaseLink =
          HttpLink(userDatabaseUrl, defaultHeaders: {
        'X-Parse-Application-Id': userDatabaseApplicationID,
        'X-Parse-Client-Key': userDatabaseClientKey,
        'X-Parse-Session-Token': token,
      });

      // Provides data from server and facilitates requests.
      userDatabaseClient = GraphQLClient(
        cache: GraphQLCache(),
        link: userDatabaseLink,
      );
      return true;
    }
    return false;
  }
}
