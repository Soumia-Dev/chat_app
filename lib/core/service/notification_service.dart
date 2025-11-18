import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http_;

import '../../data/repositories_impl/notification_service_impl.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    // Create the message channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'messages_channel',
      'Messages',
      description: 'Chat message notifications',
      importance: Importance.high,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showGroupedMessage({
    required String senderId,
    required String senderName,
    required String message,
  }) async {
    // Single message notification
    await localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      senderName,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'messages_channel',
          'Messages',
          channelDescription: 'Message notifications',
          importance: Importance.high,
          priority: Priority.high,
          groupKey: senderId,
          styleInformation: const DefaultStyleInformation(true, true),
        ),
      ),
    );

    // Summary notification
    await localNotifications.show(
      senderId.hashCode,
      senderName,
      'You have new messages',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'messages_channel',
          'Messages',
          channelDescription: 'Message notifications',
          groupKey: senderId,
          setAsGroupSummary: true,
        ),
      ),
    );
  }

  static Future<void> sendNotification({
    required String token,
    required String senderId,
    required String title,
    required String body,
  }) async {
    const String uri =
        "https://fcm.googleapis.com/v1/projects/chatapp-66c4e/messages:send";
    //here in chatapp-66c4e change it to the id of your firebase project
    final accessToken = await NotificationServiceImpl.getAccessToken();

    final payload = {
      "message": {
        "token": token,
        "notification": {"title": title, "body": body},
        "data": {
          "senderId": senderId,
          "senderName": title,
          "type": "chat_message",
        },
      },
    };

    await http_.post(
      Uri.parse(uri),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode(payload),
    );
  }
}
