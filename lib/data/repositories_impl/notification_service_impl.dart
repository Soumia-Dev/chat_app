import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationServiceImpl {
  final firebaseMessaging = FirebaseMessaging.instance;
  static const serviceAccountPath = "assets/keyNotification.json";
  static const scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

  static Future<String> getAccessToken() async {
    final serviceAccountJson = await rootBundle.loadString(serviceAccountPath);
    final serviceAccount =
        ServiceAccountCredentials.fromJson(serviceAccountJson);

    final client = await clientViaServiceAccount(serviceAccount, scopes);
    return client.credentials.accessToken.data;
  }
}
