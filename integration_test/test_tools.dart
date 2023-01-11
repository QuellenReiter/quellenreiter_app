import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/constants/constants.dart';
import 'package:quellenreiter_app/main.dart' as app;

class TestTools {
  /// Helper to pump and wait for [_seconds]
  static Future<void> pumpFramesForNSeconds(
      WidgetTester _tester, int _seconds) async {
    await _tester.pumpFrames(
        const app.QuellenreiterApp(), Duration(seconds: _seconds));
  }

  /// Define some commonly used [Finder]s
  // Screens
  static Finder findLoginScreen = find.byKey(WidgetKeys.loginScreen);
  static Finder findSignUpScreen = find.byKey(WidgetKeys.signUpScreen);
  static Finder findStartScreen = find.byKey(WidgetKeys.startScreen);

  // Buttons
  static Finder findLogoutButton = find.byKey(WidgetKeys.logoutButton);
  static Finder findLoginToSignUpButton = find.byKey(WidgetKeys.loginToSignUp);
  static Finder findLoginButton = find.byKey(WidgetKeys.loginButton);
  static Finder findSignUpToLoginButton = find.byKey(WidgetKeys.signUpToLogin);
  static Finder findInactiveSettingsIcon =
      find.byKey(WidgetKeys.inactiveSettingsIcon);

  // other widgets
  static Finder findAppBar = find.byKey(WidgetKeys.mainAppBarLogo);
  static Finder findTermsAndConditionsSwitch =
      find.byKey(WidgetKeys.termsAndConditionsSwitch);
}
