import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as google_auths;
import 'package:task_groove/constants/constants.dart';

class PushNotificationRepository {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// Request permission for push notifications
  Future<void> requestPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  /// Get and store the FCM token for the user
  Future<String?> getFcmToken() async {
    String? token = await firebaseMessaging.getToken();
    if (token != null) {
      log("FCM Token: $token");
      // Get current user
      User? currentUser = auth.currentUser;

      if (currentUser != null) {
        try {
          // Store token in user firestore document
          await firestore.collection("users").doc(currentUser.uid).update({
            'fcmToken': token,
          });
          log("FCM Token saved to Firestore for user: ${currentUser.uid}");
        } catch (e) {
          log("Error saving FCM Token to Firestore: $e");
        }
      } else {
        log("No authenticated user found");
      }
    } else {
      log("Failed to get FCM Token");
    }
    return token;
  }

  /// Obtain access token using Google Service Account
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": dotenv.env['PROJECT_ID'],
      "private_key_id": dotenv.env['PRIVATE_KEY_ID'],
      "private_key": dotenv.env['PRIVATE_KEY'],
      "client_email": dotenv.env['CLIENT_EMAIL'],
      "client_id": dotenv.env['CLIENT_ID'],
      "auth_uri": dotenv.env['AUTH_URI'],
      "token_uri": dotenv.env['TOKEN_URI'],
      "auth_provider_x509_cert_url": dotenv.env['AUTH_PROVIDER_X509_CERT_URL'],
      "client_x509_cert_url": dotenv.env['CLIENT_X509_CERT_URL'],
      "universe_domain": dotenv.env['UNIVERSE_DOMAIN'],
    };
    List<String> scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    var client = http.Client();
    google_auths.AccessCredentials credentials =
        await google_auths.obtainAccessCredentialsViaServiceAccount(
      google_auths.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    log('Access token: ${credentials.accessToken.data}');

    return credentials.accessToken.data;
  }

  /// Send push notification to specific FCM token
  Future<void> sendPushNotification({
    required String toToken,
    required String title,
    required String body,
  }) async {
    try {
      String serverToken = await getAccessToken();
      var url = Uri.parse(
          'https://fcm.googleapis.com/v1/projects/task-groove/messages:send');

      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverToken',
        },
        body: jsonEncode({
          "message": {
            "token": toToken,
            "notification": {
              "title": title,
              "body": body,
            },
          }
        }),
      );

      if (response.statusCode == 200) {
        log("Push Notification Sent Successfully");
      } else {
        log("Failed to send Push Notification. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error sending Push Notification: $e");
    }
  }
}
