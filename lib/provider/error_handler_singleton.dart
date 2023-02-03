import 'package:graphql_flutter/graphql_flutter.dart';

/// Singleton class to handle errors.
class ErrorHandlerSingleton {
  static final ErrorHandlerSingleton _instance =
      ErrorHandlerSingleton._internal();

  /// Holds any error message related to DB activity
  String? error;

  // A factory constructor, that make sure, that there always is only one instance of this class.
  factory ErrorHandlerSingleton() {
    return _instance;
  }

  ErrorHandlerSingleton._internal();

  /// Handle errors from GraphQL server.
  /// Todo: Move this into own class.
  void handleException(OperationException e) {
    // errors in the database are not shown to the user
    if (e.graphqlErrors.isNotEmpty) {
      // handle graphql errors
      // set the error
      if (e.graphqlErrors[0].message == "Invalid username/password.") {
        error = "Falscher Username oder Passwort";
      }
      if (e.graphqlErrors[0].message ==
          "Account already exists for this username.") {
        error = "Der Username ist bereits vergeben";
      }
    } else if (e.linkException is NetworkException) {
      error = "Du bist offline...";
    } else if (e.linkException is ServerException) {
      error = "Du bist offline...";
    } else {
      error = "unbekannter Fehler. Versuche es erneut";
    }
  }
}
