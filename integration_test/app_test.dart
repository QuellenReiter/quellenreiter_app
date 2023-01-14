import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:quellenreiter_app/main.dart' as app;

import 'robots/delete_account_robot.dart';
import 'robots/send_friend_request_robot.dart';
import 'robots/sign_up_robot.dart';
import 'robots/tutorial_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Test fails, if an element is not found.
  WidgetController.hitTestWarningShouldBeFatal = true;
  group("App walkthrough", () {
    // Variables
    const String _existingPlayerName = "dev0";
    const String _existingPlayerPassword = "12345678";

    const String _newPlayerName = "testplayer";
    const String _newPlayerPassword = "12345678";
    const String _newPlayerEmoji = "👨‍🦰";

    // robots
    SignUpRobot _signUpRobot;
    TutorialRobot _tutorialRobot;
    DeleteAccountRobot _deleteAccountRobot;
    SendFriendRequestRobot _sendFriendRequestRobot;

    testWidgets("Tutorial Test", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      _tutorialRobot = TutorialRobot(tester);

      await _tutorialRobot.startTutorial();
      await _tutorialRobot.startTutorialIfOnTutorialScreen();
      await _tutorialRobot.runThroughTutorialQuestScreen();
      await _tutorialRobot.runThroughResultScreen();
      await _tutorialRobot.openDetailAndProceed();
      await _tutorialRobot.logoutIfLoggedIn();
    });

    testWidgets("SignUp Test", (WidgetTester tester) async {
      app.main();

      _signUpRobot = SignUpRobot(
          tester, _newPlayerEmoji, _newPlayerName, _newPlayerPassword);

      await _signUpRobot.switchIfOnSignInScreen();
      await _signUpRobot.insertEmoji();
      await _signUpRobot.insertNameAndPassword();
      await _signUpRobot.checkPrivacyPolicy();
      await _signUpRobot.tapSignUp();
    });

    // test send friend request
    testWidgets("Send friend request", (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      _sendFriendRequestRobot = SendFriendRequestRobot(tester);

      _sendFriendRequestRobot.friendName = _existingPlayerName;

      await _sendFriendRequestRobot.goToAddFriendScreen();
      await _sendFriendRequestRobot.searchForFriend();
      await _sendFriendRequestRobot.sendFriendRequest();
    });

    /// Delete created user
    testWidgets("delete account test", (WidgetTester tester) async {
      app.main();
      _deleteAccountRobot =
          DeleteAccountRobot(tester, _newPlayerName, _newPlayerPassword);

      await _deleteAccountRobot.loginIfNotAlready();
      await _deleteAccountRobot.deleteAccount();
      await _deleteAccountRobot.verifyOnLogInScreenOrTutorial();
    });
  });
}
