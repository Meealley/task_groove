import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      "private_key_id": "383aeced41d564e76448519b6c163bd368584961",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC2ap9Y1Td/w+oK\nJHawSrogDuaIy9FsAfNpeXsOGl7mXBmDPxYCOv/+54Ep8JwHsedXqm6LLZ4fWLGS\naLE8Z/hZ5TyosSjIz/HRUMdTEEH+fhdq6l8laXcd/HKy1AxCNlQMgVWaJmLk5NUw\n1Plrnk1CrOi/3uejNM58I7Sd17Vrh6z2WKwzHZu2Eb/BA7fPGXtsLTNScrAqHmSk\nTo/FSzNlkcKp0ajI1PJPSAFrQ97aOsarCXkHd+Q7fXQMPc73u/4P/GM+tXaVQu1Z\noXUE7pUuFp21uO/CcNFCwVZuYV3UbE2gx/itZRqbfdOzCgk+JqBEG6fKCzYv9E5H\n+lJRMZsNAgMBAAECggEANiEHbb2/PTtuXFobmg5ikpa5U8hfOVSO3TJ+EF5E4Mhd\njbOPnVPSmNorWr2aHzJsOnhJWyVLMXQJJS/Jv+n+KPa7/DatqoEB+aGltAE0BAd4\nfXJUj25vOUeq5WPEy3UBlcBfHWHcoJ1Cob3g0U1lEa7rVdwYEjbeOroBo4DZxbE5\nA9LgNgCKw/sfFMGNvvTqhOWRjcX5AGz/ar4b2pQXq4wETR6+RpabXiqZrVTzxLpC\nAb1twuRpa8l6oSqN3gyiHErBDi+Xp9SxbR2NGeJ3SAaphBLtMTIaKIe4Z2hXrt7D\nvOrzfhAvsN7ITbvepl84F20nRyylJNO6srafUB6XJQKBgQDudC3lhvqmrN2REIat\nVyaQBtTxp7tIOKgmWIlMNVwj3Mr07kj4/VHx3O7mqwwJuEvJmwjLa97t5t0H6Rta\n75gdItDV/VMngm2dOThBbiJ9NdPcBLbdUzhnt2XXNgVAjx2D7h0Y40TC0RBsAvxs\n8ZJQ9eOq+nJrMAchv0V8bqc5dwKBgQDD1to5pfPmI/549lQD61lNfxDm23FMMDOR\n4KX3HCTl6h19j+UNnD3MnCGHORTeILV94qJCbCOZ51PQ0e/MPFeIMGMgI9KFURgk\npgM0QTKStEu9j7lFjHDGmvwSdSeJQ+gPsevVQhgNiC4SINBGRPIps2F1PnBIf7ld\n5KOyFRCwmwKBgQDol56lQtJ/fiLpe0tDDb1pw6A2z7uYqNsr/DSAh5QGzzmRTFUV\nulMSLsVBbxrg6EnUr0sW0XO0bvqu2qx6OTcRRIKcGOvhoBG3yLac7AbsR3MOK/ML\nVD+yu2u1TtY0sOTDaaIsQpMxzKfOE+ORiNmF6zNV9dFhyIlMW7w1seGf5QKBgQCB\n/N4kXY6iN0n1KCtj3pcL5UdmtEljdKsGLMJ8XuXu5ZJlgVlby1UJtqhahPzg430T\n7ZYd2IFY6j6r4Gz2dybycouZDa3yZ31K9hYyXQQgdCPB0t/61dkVOlIOPkzbw4MI\nx+PtTU2Bzd4mkjksKx9BppsNo0AMHxr+w4AT9/93+QKBgEvTE9gJUIslbIcFEOVa\ny96VIX04lM6CDA8zUYsZmEzuaeFx6VTVwlXtwa1PmIlW5gAYvAMNmqFxJkZ4HpG3\nqoibTGyE63HDlM6eylsWgr5esMdc5+9DCKP0KkHVtQpZqx9DqYigOuPsNz+EpGoA\nP14Lm8tRkoGdBU0v+6pKuAYq\n-----END PRIVATE KEY-----\n",
      "client_email": "task-groove-app@task-groove.iam.gserviceaccount.com",
      "client_id": "110415603512824418992",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/task-groove-app%40task-groove.iam.gserviceaccount.com",
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
