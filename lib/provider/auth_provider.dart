import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/provider/database_connection.dart';
import 'package:quellenreiter_app/provider/safe_storage.dart';
import '../consonents.dart';
import 'queries.dart';

/// Provides authentication methods.
class AuthProvider extends DatabaseConnection {
  /// [GraphQLClient] client for the user database without a token
  /// This is used to login a user.
  GraphQLClient unauthorizedUserDatabaseClient = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink(userDatabaseUrl, defaultHeaders: {
      'X-Parse-Application-Id': userDatabaseApplicationID,
      'X-Parse-Client-Key': userDatabaseClientKey,
    }),
  );

  /// Constructor is used to decide which implementation of [SafeStorageInterface] to use.
  /// This is passed to the super class.
  AuthProvider({super.safeStorage = const SafeStoragePlugin()});

  /// Login a user.
  Future<void> login(
      String username, String password, Function loginCallback) async {
    // The result returned from the query.
    var loginResult = await unauthorizedUserDatabaseClient.mutate(
      MutationOptions(
        document: gql(Queries.login(username, password)),
      ),
    );
    // If login result has any exceptions.
    if (loginResult.hasException) {
      errorHandler.handleException(loginResult.exception!);
      loginCallback(null);
      return;
    }

    // Safe the new token.
    safeStorage.write(
        key: "token",
        value: loginResult.data?["logIn"]["viewer"]["sessionToken"]);
    loginCallback(
        LocalPlayer.fromMap(loginResult.data?["logIn"]["viewer"]["user"]));
    // Safe the User
  }

  /// Signup a user.
  Future<void> signUp(String username, String password, String emoji,
      Function signUpCallback) async {
    // The result returned from the query.
    var signUpResult = await unauthorizedUserDatabaseClient.mutate(
      MutationOptions(
        document: gql(Queries.signUp(username, password, emoji)),
      ),
    );
    // If login result has any exceptions.
    if (signUpResult.hasException) {
      errorHandler.handleException(signUpResult.exception!);

      signUpCallback(null);
      return;
    }
    // Safe the new token.
    await safeStorage.write(
        key: "token",
        value: signUpResult.data?["signUp"]["viewer"]["sessionToken"]);

    // set the emoji to new player
    var player =
        LocalPlayer.fromMap(signUpResult.data?["signUp"]["viewer"]["user"]);
    player.emoji = emoji;

    // Link to user database.
    if (!await createUserDatabaseClient()) {
      signUpCallback(player);
      return;
    }
    // upload emoji
    var mutationResult = await userDatabaseClient!.mutate(
      MutationOptions(
        document: gql(Queries.updateUser()),
        variables: {
          "user": player.toUserMapWithNewUserData(),
        },
      ),
    );

    if (mutationResult.hasException) {
      errorHandler.handleException(mutationResult.exception!);
      // WHAT SHOULD WE RETURN? go to main menu anyways??
      signUpCallback(player);
      return;
    } else {
      player = LocalPlayer.fromMap(mutationResult.data?["updateUser"]["user"]);
    }
    signUpCallback(player);
  }

  /// Logsout a user by deleting the session token and nulling the player.
  Future<void> deleteToken(LocalPlayer? p) async {
    await safeStorage.delete(key: "token");
    return;
  }

  /// Checks if token is valid.
  Future<void> checkToken(Function checkTokenCallback) async {
    // If token is not null, check if it is valid.
    if (await createUserDatabaseClient()) {
      // The query result.
      var queryResult = await userDatabaseClient!.query(QueryOptions(
        document: gql(Queries.getCurrentUser()),
      ));

      if (queryResult.hasException) {
        errorHandler.handleException(queryResult.exception!);
        checkTokenCallback(null);
        return;
      } else {
        // Safe the new token.
        await safeStorage.write(
            key: "token", value: queryResult.data?["viewer"]["sessionToken"]);
        checkTokenCallback(
            LocalPlayer.fromMap(queryResult.data?["viewer"]["user"]));
        return;
      }
    }
    // no token, return false
    checkTokenCallback(null);
  }
}
