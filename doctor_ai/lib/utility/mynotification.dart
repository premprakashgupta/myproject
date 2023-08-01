import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Chat Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      "helo hiii kaise",
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void checkForNotification({required BuildContext context}) async {
    NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    print("-----------------------------------checkpoint 1-------------");
    if (details != null) {
      print("-----------------------------------checkpoint 2-------------");
      if (details.didNotificationLaunchApp) {
        print("-----------------------------------checkpoint 3-------------");
        NotificationResponse? response = details.notificationResponse;

        if (response != null) {
          print("-----------------------------------checkpoint 4-------------");
          String? payload = response.payload;
          print("Notification Payload: $payload");

          // Navigate to the NotificationScreen when the notification is clicked.
          if (payload == 'Default_Sound') {
            Navigator.pushNamed(context, '/notification');
          }
        }
      }
    }
  }
}
