import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_tools.dart';

class SignUpRobot {
  const SignUpRobot(this._tester, this._newPlayerEmoji, this._newPlayerName,
      this._newPlayerPassword);

  final WidgetTester _tester;
  final String _newPlayerEmoji;
  final String _newPlayerName;
  final String _newPlayerPassword;

  /// Switches if we are on [LogInScreen]
  Future<void> switchIfOnSignInScreen() async {
    await _tester.pumpAndSettle();
    // If we are on the login screen go to the register screen
    if (TestTools.findLoginScreen.evaluate().isNotEmpty) {
      await _tester.tap(TestTools.findLoginToSignUpButton, warnIfMissed: true);
      await _tester.pumpAndSettle();
    }
  }

  /// Inserts [_newPlayerEmoji] into the [TextField]
  Future<void> insertEmoji() async {
    expect(TestTools.findSignUpScreen, findsOneWidget);
    await _tester.enterText(find.byType(TextField), _newPlayerEmoji);
    await _tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_forward_ios), findsOneWidget);

    await _tester.tap(find.byIcon(Icons.arrow_forward_ios), warnIfMissed: true);
    await _tester.pumpAndSettle();
  }

  /// Inserts [_newPlayerName] and [_newPlayerPassword] into the [TextField]
  Future<void> insertNameAndPassword() async {
    expect(find.text("Wähle Username und Passwort"), findsOneWidget);
    await _tester.enterText(
        find.widgetWithText(TextField, "Username"), _newPlayerName);
    await _tester.pumpAndSettle();

    await _tester.enterText(
        find.widgetWithText(TextField, "Passwort"), _newPlayerPassword);
    await _tester.pumpAndSettle();

    await _tester.enterText(
        find.widgetWithText(TextField, "Passwort wiederholen"),
        _newPlayerPassword);
    await _tester.pumpAndSettle();
  }

  /// Check Privacy policy
  Future<void> checkPrivacyPolicy() async {
    // tap o the appbarLogo to hide keyboard
    await _tester.tap(TestTools.findAppBar, warnIfMissed: true);
    await _tester.pumpAndSettle();
    // check Privacy policy checker
    await _tester.tap(TestTools.findTermsAndConditionsSwitch,
        warnIfMissed: true);
    await _tester.pumpAndSettle();
  }

  /// Tap on the Sign up button
  Future<void> tapSignUp() async {
    await _tester.tap(find.widgetWithText(ElevatedButton, "Registrieren"),
        warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 3);

    expect(find.text("Hast du dir dein Passwort gemerkt?"), findsOneWidget);

    await _tester.tap(find.widgetWithText(ElevatedButton, "Ja, weiter"),
        warnIfMissed: true);
    await _tester.pumpAndSettle();
  }

  /// Checks that homescreen with correct user is displayed
  Future<void> verifySuccess() async {
    await _tester.pumpAndSettle();

    expect(TestTools.findStartScreen, findsOneWidget);
    expect(find.text(_newPlayerName), findsWidgets);
  }
}
