// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

// class GoogleCalendarRepository {
//   final _storage = const FlutterSecureStorage();

//   // OAuth 2.0 Client ID and Secret (replace with your own)
//   final _clientId = ClientId(
//     dotenv.env['OAUTH_CLIENT_ID']!, // Replace with your client ID
//     dotenv.env['OAUTH_CLIENT_SECRET'], // Replace with your client secret
//   );

//   // Scopes required for Google Calendar
//   final List<String> _scopes = [calendar.CalendarApi.calendarScope];

//   calendar.CalendarApi? _calendarApi;

//   /// Authenticate the user and initialize the Google Calendar API
//   Future<calendar.CalendarApi?> authenticateUser() async {
//     try {
//       // Authenticate user via user consent
//       final client = await clientViaUserConsent(_clientId, _scopes, (url) {
//         print("Please visit this URL to authenticate: $url");
//       });

//       // Store access and refresh tokens securely
//       final credentials = client.credentials;
//       await _storage.write(
//           key: 'accessToken', value: credentials.accessToken.data);
//       await _storage.write(
//           key: 'refreshToken', value: credentials.refreshToken);

//       // Initialize Calendar API
//       _calendarApi = calendar.CalendarApi(client);
//       return _calendarApi;
//     } catch (e) {
//       print("Authentication failed: $e");
//       return null;
//     }
//   }

//   /// Fetch upcoming Google Calendar events
//   Future<List<calendar.Event>> fetchEvents({int maxResults = 10}) async {
//     if (_calendarApi == null)
//       throw Exception("Google Calendar API not initialized");

//     try {
//       final events = await _calendarApi!.events.list(
//         'primary',
//         maxResults: maxResults,
//         orderBy: 'startTime',
//         singleEvents: true,
//       );

//       return events.items ?? [];
//     } catch (e) {
//       print("Error fetching events: $e");
//       throw Exception("Failed to fetch events");
//     }
//   }

//   /// Create a new Google Calendar event
//   Future<void> createEvent({
//     required String title,
//     required DateTime startTime,
//     required DateTime endTime,
//   }) async {
//     if (_calendarApi == null)
//       throw Exception("Google Calendar API not initialized");

//     final event = calendar.Event(
//       summary: title,
//       start: calendar.EventDateTime(dateTime: startTime, timeZone: "UTC"),
//       end: calendar.EventDateTime(dateTime: endTime, timeZone: "UTC"),
//     );

//     try {
//       await _calendarApi!.events.insert(event, 'primary');
//       print("Event created successfully");
//     } catch (e) {
//       print("Error creating event: $e");
//       throw Exception("Failed to create event");
//     }
//   }

//   /// Sync a list of tasks to Google Calendar as events
//   Future<void> syncTasksToCalendar(List<Map<String, dynamic>> tasks) async {
//     for (var task in tasks) {
//       await createEvent(
//         title: task['title'],
//         startTime: task['startTime'],
//         endTime: task['endTime'],
//       );
//     }
//     print("All tasks synced to Google Calendar successfully");
//   }

//   /// Reauthenticate using refresh token
//   Future<void> reauthenticate() async {
//     try {
//       final accessToken = await _storage.read(key: 'accessToken');
//       final refreshToken = await _storage.read(key: 'refreshToken');

//       if (accessToken != null && refreshToken != null) {
//         print("Tokens already available. Initializing Calendar API...");
//         // Initialize API client here (future implementation)
//       } else {
//         print("No valid tokens found. Re-authentication required.");
//       }
//     } catch (e) {
//       print("Error during reauthentication: $e");
//     }
//   }

//   /// Clear stored tokens (for logout)
//   Future<void> clearTokens() async {
//     await _storage.deleteAll();
//     print("All tokens cleared");
//   }
// }

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarRepository {
  final _storage = const FlutterSecureStorage();

  // OAuth credentials (Client ID only, no secret)
  final _clientId = ClientId(
    dotenv.env['OAUTH_CLIENT_ID']!,
    null, // No client secret for Android
  );

  // OAuth scopes
  final List<String> _scopes = [calendar.CalendarApi.calendarScope];

  // Redirect URI (custom scheme for mobile)
  final String _redirectUri = 'com.yourapp:/oauth2redirect';

  calendar.CalendarApi? _calendarApi;

  /// Authenticate the user with Google OAuth and initialize the Calendar API
  Future<calendar.CalendarApi?> authenticateUser() async {
    try {
      final client =
          await clientViaUserConsent(_clientId, _scopes, (url) async {
        // Launch the URL in an external browser
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw Exception("Could not launch $url");
        }
      });

      // Store tokens securely
      final credentials = client.credentials;
      await _storage.write(
          key: 'accessToken', value: credentials.accessToken.data);
      await _storage.write(
          key: 'refreshToken', value: credentials.refreshToken);

      // Initialize Calendar API
      _calendarApi = calendar.CalendarApi(client);
      print("Authentication successful. Calendar API initialized.");
      return _calendarApi;
    } catch (e) {
      print("Authentication failed: $e");
      return null;
    }
  }

  /// Fetch a list of events from Google Calendar
  Future<List<calendar.Event>> fetchEvents({int maxResults = 10}) async {
    if (_calendarApi == null) {
      throw Exception("Google Calendar API not initialized");
    }

    try {
      final events = await _calendarApi!.events.list(
        'primary',
        maxResults: maxResults,
        orderBy: 'startTime',
        singleEvents: true,
      );

      return events.items ?? [];
    } catch (e) {
      print("Error fetching events: $e");
      throw Exception("Failed to fetch events");
    }
  }

  /// Create a new Google Calendar event
  Future<void> createEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (_calendarApi == null) {
      throw Exception("Google Calendar API not initialized");
    }

    final event = calendar.Event(
      summary: title,
      start: calendar.EventDateTime(dateTime: startTime, timeZone: "UTC"),
      end: calendar.EventDateTime(dateTime: endTime, timeZone: "UTC"),
    );

    try {
      await _calendarApi!.events.insert(event, 'primary');
      print("Event created successfully");
    } catch (e) {
      print("Error creating event: $e");
      throw Exception("Failed to create event");
    }
  }

  /// Sync a list of tasks to Google Calendar as events
  Future<void> syncTasksToCalendar(List<Map<String, dynamic>> tasks) async {
    for (var task in tasks) {
      await createEvent(
        title: task['title'],
        startTime: task['startTime'],
        endTime: task['endTime'],
      );
    }
    print("All tasks synced to Google Calendar successfully");
  }

  /// Reauthenticate using stored refresh token
  Future<void> reauthenticate() async {
    try {
      final accessToken = await _storage.read(key: 'accessToken');
      final refreshToken = await _storage.read(key: 'refreshToken');

      if (accessToken == null || refreshToken == null) {
        throw Exception("No valid tokens found. Reauthentication required.");
      }

      // Create an AccessCredentials object
      final credentials = AccessCredentials(
        AccessToken(
          "Bearer",
          accessToken,
          DateTime.now()
              .add(const Duration(seconds: 3600)), // Expiration placeholder
        ),
        refreshToken,
        _scopes,
      );

      // Refresh the credentials
      final refreshedCredentials = await refreshCredentials(
        _clientId,
        credentials,
        http.Client(),
      );

      // Save the updated access token
      await _storage.write(
          key: 'accessToken', value: refreshedCredentials.accessToken.data);
      if (refreshedCredentials.refreshToken != null) {
        await _storage.write(
            key: 'refreshToken', value: refreshedCredentials.refreshToken);
      }

      print("Reauthenticated successfully.");
    } catch (e) {
      print("Error during reauthentication: $e");
    }
  }

  /// Clear stored tokens (for logout)
  Future<void> clearTokens() async {
    await _storage.deleteAll();
    print("All tokens cleared");
  }
}
