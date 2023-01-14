import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quellenreiter_app/widgets/opponent_card.dart';

import '../test_tools.dart';

class SendFriendRequestRobot {
  SendFriendRequestRobot(this._tester);

  final WidgetTester _tester;
  String? _friendName;

  set friendName(String name) => _friendName = name;

  /// Go to [addFriendScreen]
  Future<void> goToAddFriendScreen() async {
    await _tester.tap(find.byIcon(Icons.group_outlined), warnIfMissed: true);
    await _tester.pumpAndSettle();

    await _tester.tap(find.byIcon(Icons.group_add), warnIfMissed: true);
    await _tester.pumpAndSettle();

    expect(find.text("freund:innen suchen"), findsOneWidget);
  }

  /// Search for [_friendName]
  Future<void> searchForFriend() async {
    if (_friendName == null) {
      throw Exception("friendName is null");
    }
    await _tester.enterText(find.byType(TextField), _friendName!);
    await _tester.pumpAndSettle();

    await _tester.tap(find.byIcon(Icons.search), warnIfMissed: true);
    await _tester.pumpAndSettle();

    expect(find.byType(OpponentCard), findsOneWidget);
  }

  /// Send friend request
  Future<void> sendFriendRequest() async {
    if (_friendName == null) {
      throw Exception("friendName is null");
    }
    await _tester.tap(find.byType(OpponentCard), warnIfMissed: true);
    await TestTools.pumpFramesForNSeconds(_tester, 3);

    expect(find.text("Versendete anfragen"), findsOneWidget);
    expect(find.text(_friendName!), findsOneWidget);
  }
}
