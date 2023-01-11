import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/widgets/statement_card.dart';

import '../test_tools.dart';

class TutorialRobot {
  const TutorialRobot(this._tester);

  final WidgetTester _tester;

  /// Check if we are logged in and start the tutorial.
  Future<void> startTutorial() async {
    // if we are automaticly logged in..
    if (find.text("%").evaluate().isNotEmpty) {
      await _tester.tap(TestTools.findInactiveSettingsIcon, warnIfMissed: true);
      await _tester.pumpAndSettle();
      await _tester.tap(find.text("Tutorial spielen"), warnIfMissed: true);
      await _tester.pumpAndSettle();
    }
    if (TestTools.findLoginScreen.evaluate().isNotEmpty) {
      await _tester.longPress(find.byKey(const Key("loginScreenLogo")));
      await _tester.pumpAndSettle();
    }
    if (TestTools.findSignUpScreen.evaluate().isNotEmpty) {
      await _tester.tap(TestTools.findSignUpToLoginButton, warnIfMissed: true);
      await _tester.pumpAndSettle();
      await _tester.longPress(find.byKey(const Key("loginScreenLogo")));
      await _tester.pumpAndSettle();
    }
  }

  /// Check if we are on the tutorial screen and start the tutorial.
  Future<void> startTutorialIfOnTutorialScreen() async {
    expect(find.text("tutorial"), findsOneWidget);
    await _tester.tap(find.text("tutorial"));
    await TestTools.pumpFramesForNSeconds(_tester, 3);
  }

  /// Run through the tutorial quest screen
  Future<void> runThroughTutorialQuestScreen() async {
    await _tester.tap(find.text("weiter"), warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
    expect(find.text("weiter"), findsOneWidget);
    expect(find.text("überspringen"), findsOneWidget);
    // tap weiter
    await _tester.tap(find.text("weiter"), warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
    expect(find.text("Facebook | Social Media Post"), findsOneWidget);

    expect(find.text("Fakt"), findsOneWidget);
    expect(find.text("Fake"), findsOneWidget);
    // Do not warnIfMissed because the widget is behind the tutorial ui.
    await _tester.tap(find.text("Fake"), warnIfMissed: false);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
  }

  /// Run through the tutorial result screen
  Future<void> runThroughResultScreen() async {
    expect(find.text("Richtige\nAntwort"), findsOneWidget);

    await _tester.tap(find.text("weiter"), warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
    expect(find.text("Faktencheck zur Aussage"), findsOneWidget);

    // Do not warnIfMissed because the widget is behind the tutorial ui.
    await _tester.tap(find.byType(StatementCard), warnIfMissed: false);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
  }

  /// Open detail view and proceed to app
  Future<void> openDetailAndProceed() async {
    // Do not warnIfMissed because the widget is behind the tutorial ui.
    await _tester.tap(find.byIcon(Icons.archive_outlined), warnIfMissed: false);
    await TestTools.pumpFramesForNSeconds(_tester, 1);
    expect(find.byIcon(Icons.delete), findsOneWidget);

    await _tester.drag(find.byIcon(Icons.share),
        Offset(0.0, _tester.binding.window.physicalSize.height / 2));
    await TestTools.pumpFramesForNSeconds(_tester, 1);

    expect(find.byIcon(Icons.fact_check), findsAtLeastNWidgets(1));

    //finish tutorial
    await _tester.tap(find.text("weiter zur App"), warnIfMissed: true);
    await _tester.pumpAndSettle();
  }

  /// Logout if we are logged in
  Future<void> logoutIfLoggedIn() async {
    if (find.text("%").evaluate().isNotEmpty) {
      await _tester.tap(TestTools.findInactiveSettingsIcon, warnIfMissed: true);
      await _tester.pumpAndSettle();
      await _tester.tap(TestTools.findLogoutButton, warnIfMissed: true);
      await _tester.pumpAndSettle();
    }
  }
}
