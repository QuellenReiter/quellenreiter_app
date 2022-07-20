import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    // create init settings

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('assets/logo-pink.png');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // init notifications
    await _notifications.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        print('notification payload: $payload');
      },
    );
  }

  static Future showNotification(
      String title, String body, String? payload, int id) async {
    await _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: "@mipmap/ic_launcher"),
      // iOS: IOSNotificationDetails(),
    );
  }
}
