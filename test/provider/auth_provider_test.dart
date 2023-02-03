import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/models/player_relation.dart';
import 'package:quellenreiter_app/provider/auth_provider.dart';
import 'package:quellenreiter_app/provider/player_provider.dart';
import 'package:quellenreiter_app/provider/safe_storage.dart';

import '../unit_test_tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("Testing AuthProvider", () {
    LocalPlayer? testUserInstance1;
    LocalPlayer? testUserInstance2;

    AuthProvider authProvider = AuthProvider(safeStorage: SafeStorageTesting());
    PlayerProvider playerProvider =
        PlayerProvider(safeStorage: SafeStorageTesting());

    tearDown(() async {
      if (testUserInstance1 != null) {
        await playerProvider.deleteAccount(
            testUserInstance1!, PlayerRelationCollection.empty());
      }
      // null the players
      testUserInstance1 = null;
      testUserInstance2 = null;
      // Delete the token.
      await authProvider.safeStorage.delete(key: "token");

      return Future.value();
    });
    // This test is important so we do it on the testDB.
    // ASSUMPTION: The testUser exists in the testDB.

    test("SignUp and checkToken of a new user.", () async {
      await authProvider.signUp(
          UnitTestTools.testUserSignUpName,
          UnitTestTools.testUserSignUpPassword,
          UnitTestTools.testUserSignUpEmoji, (LocalPlayer p) {
        testUserInstance1 = p;
      });
      expect(testUserInstance1, isNotNull);
      expect(testUserInstance1!.name, UnitTestTools.testUserSignUpName);
      expect(testUserInstance1!.emoji, UnitTestTools.testUserSignUpEmoji);

      await authProvider.checkToken((LocalPlayer p) {
        testUserInstance2 = p;
      });
      expect(testUserInstance2, isNotNull);
      expect(testUserInstance1!.id == testUserInstance2!.id, true);
    });

    test("Login", () async {
      expect(testUserInstance2, isNull);
      expect(await authProvider.safeStorage.read(key: "token"), isNull);

      await authProvider
          .login(UnitTestTools.testUserName, UnitTestTools.testUserPassword,
              (LocalPlayer p) {
        testUserInstance2 = p;
      });
      expect(testUserInstance2, isNotNull);
      expect(testUserInstance2!.name, UnitTestTools.testUserName);
    });

    test("Logout", () async {
      await authProvider
          .login(UnitTestTools.testUserName, UnitTestTools.testUserPassword,
              (LocalPlayer p) {
        testUserInstance2 = p;
      });
      await authProvider.deleteToken(testUserInstance2);
      expect(await authProvider.safeStorage.read(key: "token"), isNull);
    });
  });
}
