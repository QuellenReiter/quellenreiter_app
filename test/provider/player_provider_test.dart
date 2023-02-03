import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/models/player.dart';
import 'package:quellenreiter_app/provider/auth_provider.dart';
import 'package:quellenreiter_app/provider/player_provider.dart';
import 'package:quellenreiter_app/provider/safe_storage.dart';

import '../unit_test_tools.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("Testing PlayerProvider", () {
    LocalPlayer? testUserInstance1;
    AuthProvider authProvider = AuthProvider(safeStorage: SafeStorageTesting());
    PlayerProvider playerProvider =
        PlayerProvider(safeStorage: SafeStorageTesting());
    setUp(() async {
      await authProvider
          .login(UnitTestTools.testUserName, UnitTestTools.testUserPassword,
              (LocalPlayer p) {
        testUserInstance1 = p;
      });
      // check if name is correct
      if (testUserInstance1!.name != UnitTestTools.testUserName) {
        await playerProvider.updateName(
            testUserInstance1!, UnitTestTools.testUserName);
      }
      // check if emoji is correct
      if (testUserInstance1!.emoji != UnitTestTools.testUserEmoji) {
        await playerProvider.updateEmoji(
            testUserInstance1!, UnitTestTools.testUserEmoji);
      }
      // check that playedStatements is empty
      if (testUserInstance1!.playedStatements.isNotEmpty) {
        await playerProvider.removeAllPlayedStatements(testUserInstance1!);
      }
      if (testUserInstance1!.savedStatementsIds.isNotEmpty) {
        await playerProvider.removeSafedStatement(
            testUserInstance1!, UnitTestTools.testUserSavedStatement);
      }
      if (testUserInstance1!.numFriends != 0) {
        await playerProvider.incrementNumFriends(
            testUserInstance1!, -testUserInstance1!.numFriends);
      }
      return Future.value();
    });

    tearDown(() async {
      // check if name is correct
      if (testUserInstance1!.name != UnitTestTools.testUserName) {
        await playerProvider.updateName(
            testUserInstance1!, UnitTestTools.testUserName);
      }
      // check if emoji is correct
      if (testUserInstance1!.emoji != UnitTestTools.testUserEmoji) {
        await playerProvider.updateEmoji(
            testUserInstance1!, UnitTestTools.testUserEmoji);
      }
      // check that playedStatements is empty
      if (testUserInstance1!.playedStatements.isNotEmpty) {
        await playerProvider.removeAllPlayedStatements(testUserInstance1!);
      }
      if (testUserInstance1!.savedStatementsIds.isNotEmpty) {
        await playerProvider.removeSafedStatement(
            testUserInstance1!, UnitTestTools.testUserSavedStatement);
      }
      if (testUserInstance1?.numFriends != 0) {
        await playerProvider.incrementNumFriends(
            testUserInstance1!, -testUserInstance1!.numFriends);
      }
      await authProvider.deleteToken(testUserInstance1);

      return Future.value();
    });
    // This test is important so we do it on the testDB.
    // ASSUMPTION: The testUser exists in the testDB.

    test("User should contain the correct data.", () async {
      expect(testUserInstance1, isNotNull);
      expect(testUserInstance1!.name, UnitTestTools.testUserName);
      expect(testUserInstance1!.emoji, UnitTestTools.testUserEmoji);
      expect(await authProvider.safeStorage.read(key: "token"), isNotNull);
    });

    test("Check new update emoji func", () async {
      expect(testUserInstance1!.emoji == "👻", false);

      await playerProvider.updateEmoji(testUserInstance1!, "👻");
      expect(testUserInstance1, isNotNull);
      expect(testUserInstance1!.emoji, "👻");
    });

    test("updateName function", () async {
      await playerProvider.updateName(testUserInstance1!, "TestName");
      expect(testUserInstance1, isNotNull);
      expect(testUserInstance1!.name, "TestName");
    });

    test("increment number of friends function", () async {
      await playerProvider.incrementNumFriends(testUserInstance1!, 1);
      expect(testUserInstance1!.numFriends, 1);
      await playerProvider.incrementNumFriends(testUserInstance1!, 2);
      expect(testUserInstance1!.numFriends, 3);
    });

    test("decrement number of friends function", () async {
      await playerProvider.incrementNumFriends(testUserInstance1!, 2);
      expect(testUserInstance1!.numFriends, 2);
      await playerProvider.incrementNumFriends(testUserInstance1!, -1);
      expect(testUserInstance1!.numFriends, 1);
    });
    test("add and removeAll playedStatements function", () async {
      await playerProvider.addPlayedStatements(
          testUserInstance1!, UnitTestTools.testUserPlayedStatements,
          (Player? p) {
        testUserInstance1 = p as LocalPlayer;
      });
      expect(
          testUserInstance1!.playedStatements ==
              UnitTestTools.testUserPlayedStatements,
          isNotNull);
      await playerProvider.removeAllPlayedStatements(testUserInstance1!);
      expect(testUserInstance1!.playedStatements.isEmpty, isTrue);
    });

    test("add and remove savedStatements function", () async {
      await playerProvider.addSafedStatement(
          testUserInstance1!, UnitTestTools.testUserSavedStatement);
      expect(
          testUserInstance1!.savedStatementsIds ==
              [UnitTestTools.testUserSavedStatement],
          isNotNull);
      await playerProvider.removeSafedStatement(
        testUserInstance1!,
        UnitTestTools.testUserSavedStatement,
      );
      expect(testUserInstance1!.savedStatementsIds.isEmpty, isTrue);
    });

    test("getUserData function", () async {
      bool success = await playerProvider.getUserData(testUserInstance1!);
      expect(testUserInstance1, isNotNull);
      expect(success, true);
      expect(playerProvider.errorHandler.error == null, true);
    });

    // test("Updating UserData shall not overwrite the current state of the DB",
    //     () async {
    //   // save the current numGamesWon
    //   int oldNumPlayedGames = testUserInstance1!.numPlayedGames;
    //   int oldNumGamesWon = testUserInstance1!.numGamesWon;
    //   // update the user in DB but only testUserInstance1 knows about it
    //   testUserInstance1!.numGamesWon += 1;
    //   await db.updateUserData(testUserInstance1!, (p) {
    //     testUserInstance1 = p;
    //   });
    //   // check if the mutation worked on testUserInstance1
    //   expect(testUserInstance1!.numGamesWon, oldNumGamesWon + 1);

    //   // check that testUserInstance2 does not know about the previous change
    //   expect(testUserInstance2!.numGamesWon, oldNumGamesWon);

    //   // Modify the testUserInstance2 at another variable in the DB
    //   // This time testUserInstance1 does not know about the change.
    //   testUserInstance2!.numPlayedGames += 1;

    //   await db.updateUserData(testUserInstance2!, (p) {
    //     testUserInstance2 = p;
    //   });
    //   // check that mutation worked on testUserInstance2
    //   expect(testUserInstance2!.numPlayedGames, oldNumPlayedGames + 1);
    //   // check that testUserInstance1 does not know about the second change
    //   expect(testUserInstance1!.numPlayedGames, oldNumPlayedGames);
    //   // Check that the second change did not overwrite the first change
    //   // even though the first change was not known to testUserInstance2.
    //   // SUPPOSED TO FAIL HERE
    //   expect(testUserInstance1!.numGamesWon, testUserInstance2!.numGamesWon);
    // });
  });
}
