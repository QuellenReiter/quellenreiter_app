import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_tools.dart';

class DeleteAccountRobot {
  const DeleteAccountRobot(
      this._tester, this._newPlayerName, this._newPlayerPassword);

  final WidgetTester _tester;
  final String _newPlayerName;
  final String _newPlayerPassword;

  /// Switches if we are on [LogInScreen]
  Future<void> loginIfNotAlready() async {
    await _tester.pumpAndSettle();
    // logout if username is not [_newPlayerName]
    if (find.byIcon(Icons.home_filled).evaluate().isNotEmpty &&
        find.text(_newPlayerName).evaluate().isEmpty) {
      await _tester.tap(TestTools.findInactiveSettingsIcon, warnIfMissed: true);
      await _tester.pumpAndSettle();
      await _tester.tap(TestTools.findLogoutButton, warnIfMissed: true);
      await _tester.pumpAndSettle();
    }
    // If we are on the  Register screen go to the login screen
    if (TestTools.findSignUpScreen.evaluate().isNotEmpty) {
      await _tester.tap(find.text("Anmelden"), warnIfMissed: true);
      await _tester.pumpAndSettle();
    }
    if (TestTools.findLoginScreen.evaluate().isNotEmpty) {
      await _tester.enterText(
          find.widgetWithText(TextField, "Nutzername"), _newPlayerName);
      await _tester.pumpAndSettle();

      await _tester.enterText(
          find.widgetWithText(TextField, "Passwort"), _newPlayerPassword);
      await _tester.pumpAndSettle();

      await _tester.tap(find.text("Anmelden"), warnIfMissed: false);
      await TestTools.pumpFramesForNSeconds(_tester, 3);
    }

    // verify we are on the start screen
    expect(find.byIcon(Icons.home_filled), findsOneWidget);
  }

  /// Go to [SettingsScreen] and delete account
  Future<void> deleteAccount() async {
    await _tester.tap(TestTools.findInactiveSettingsIcon, warnIfMissed: true);
    await _tester.pumpAndSettle();

    await _tester.tap(find.text("Account löschen"), warnIfMissed: true);
    await _tester.pumpAndSettle();

    await _tester.tap(find.text("Ja"), warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 3);
  }

  /// Verify we are on the [LogInScreen]
  Future<void> verifyOnLogInScreenOrTutorial() async {
    await _tester.pumpAndSettle();
    if (TestTools.findLoginScreen.evaluate().isNotEmpty) {
      expect(TestTools.findLoginScreen, findsOneWidget);
    } else {
      expect(find.text("tutorial"), findsOneWidget);
    }
  }
}
