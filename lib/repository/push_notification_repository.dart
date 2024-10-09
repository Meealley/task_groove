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
      "project_id": "task-groove",
      "private_key_id": "f507eab865564c29ccfb54cb49d5afcaa2dd7104",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC6Sagi2yTMMB9c\nAOP+jL9vNYVLF3uxvdJ/g14+jY5vQN6G0OyK8qg6DDnWgCsUsFlQ9FSGXjKnFI3r\nd4rDPIVl9U5eYJMcONl490125FKisVcTFz6xBiDtCOlUmMfCY0Xt20em6yHpmQKl\nBOoJyl5bYs3aXDLldBJ4jvU1rhpAQ4E1EOUt92p0YS0tj3LA0GywNHgxWuep+NNj\nmVYTbzPxsPw6gfEzKyvgUzP7PKskShItZVxTyFqVDhICRhJXOZULmZNmjYPUgxQH\nrcyxZs1deFhWQ6OU0FOQ2zkvHwn4UZwEBSOR8CTDZJxTXIYBh4wWVLcswxiTHiIE\nMyJ1NKghAgMBAAECggEAIpdx1sMdsqLO9+0caRSmqZZlIXwDVo56i34P3oq3o7YG\nfD9IZUbI8Tp69PdIyKc0dqFgHrFYM4lQDyTcCgPve27RNho1xvxRebJmWojsRVSr\n6BodZI7QR2OrvC9AjLqVbiUVSYwI+JEWmiDu+pFu8wZGVmFffBcRJPza0LR7IGp3\nRwwij9q6b5R6kA83/8s54N+bz5n/XxzlL4cO7rzIdy11i59niY0v5rnV/9I65E4r\nHhvEkvqNXV1RDcf04EI55X2Lgri56SlcBGHRQ0I8GWl4QuNDvB3UX+teQLQ5Zldd\nKfcvNn0UKT4cxpaMExK5UH6Vl02TIODmzK2DKoQ+PwKBgQDpjV0SZQPDkpPDwpw+\ng50LP74GvbZ+pWNAj7Wt3Rahb0k1kS22EQroyf1c4/13XKQ0Afck7uKIoU3RIxP5\nW3NojsPkXa448uVXw8wv6XeMO3k5exZaynFONa4KXUM0JQVXeOYeAixFYlCRR93N\ne1poUf1wLuQwnIpztTKTvGdeYwKBgQDMMVVmbYBV+xmnjCDyL2VuwMzYcMZaSk2a\nOTndP7Pax7M/y/H0/+KIRvHp3MA722ZPAIIyafRL29GJTtWmlYk6iQbC2wzoHmUB\n7pU/e94k+7hBpyzEMPwA9FCdX7zjiiOVaQDvq3ayuR6aWYsDVjqCtZCsOxJyPC9d\ntO0vu3m0qwKBgCJX1DjRO9V1Z18g7eLPbbdqvyG0ofJLlaW3vCp92UcR2z0SRRuB\ntA35LdWL/QihSdAP/eyjaBJZTd0UAGrphLX6UFnzYJwlM45NT2g4N4kacb//FpFx\nNWofwKDrh+dSDlAHiicdgK8PPvOuErKVkfzHGbJ2Yr23NzC+k1pgGP8rAoGBAKEv\n2HBQxFwbKbc/QMqta26wN4QsEgg4W2YBApKKtNlhhzg3MDrsu9BD4LdxkTYvDWYT\nyrMtPLGdRp0TZEhqBrf0byfmbxvU0nth8OL6TvP22Q7KfuYonOXL9s8kQiGEbG6H\nQzvuqHaQ9310be4mZW3FEf1DbF5M8D8SkaF6ZqqdAoGBANrvLmpWvzZkr4xwLPDZ\n8ruujdfYX08pKy3gvXLKLwva8V3cTx4vuyo/TmOB7M1oe8i+kLXv0lJronQAykaw\nwEgHI77QaYZ+amOlkK15y3z7dXUJVaMGiqsHfuLuK4nTe5fgK7CbwnQf+44671Gi\nAV0vc9bYrIyMdkWn1ZPHUpFP\n-----END PRIVATE KEY-----\n",
      "client_email": "task-groove@appspot.gserviceaccount.com",
      "client_id": "112148141238969690751",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/task-groove%40appspot.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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
