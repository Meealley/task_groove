import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarRepository {
  final _storage = const FlutterSecureStorage();
  final String _clientId = dotenv.env['OAUTH_CLIENT_ID']!;
  final List<String> _scopes = [calendar.CalendarApi.calendarScope];
  calendar.CalendarApi? _calendarApi;

  /// Authenticate the user and initialize the Google Calendar API
  Future<calendar.CalendarApi?> authenticateUser() async {
    try {
      final client = await _getAuthenticatedClient();

      if (client != null) {
        _calendarApi = calendar.CalendarApi(client);
        return _calendarApi;
      } else {
        throw Exception("Failed to authenticate user.");
      }
    } catch (e) {
      print("Authentication error: $e");
      return null;
    }
  }

  /// Sync tasks to Google Calendar
  Future<void> syncTasksToCalendar(List<Map<String, dynamic>> tasks) async {
    if (_calendarApi == null) {
      throw Exception("Google Calendar API not initialized");
    }

    for (var task in tasks) {
      await createEvent(
        title: task['title'],
        startTime: DateTime.parse(task['startTime']),
        endTime: DateTime.parse(task['endTime']),
      );
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

  /// Fetch events from Google Calendar
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

  /// Clear stored tokens
  Future<void> clearTokens() async {
    await _storage.deleteAll();
    print("All tokens cleared.");
  }

  /// Get authenticated client
  Future<AuthClient?> _getAuthenticatedClient() async {
    try {
      final storedAccessToken = await _storage.read(key: 'accessToken');
      final storedRefreshToken = await _storage.read(key: 'refreshToken');

      if (storedAccessToken != null && storedRefreshToken != null) {
        final accessToken =
            AccessToken('Bearer', storedAccessToken, DateTime.now());
        final credentials = AccessCredentials(
          accessToken,
          storedRefreshToken,
          _scopes,
        );

        return authenticatedClient(http.Client(), credentials);
      }

      return await _authenticateWithConsent();
    } catch (e) {
      print("Error in client authentication: $e");
      return null;
    }
  }

  /// Authenticate user via user consent flow
  Future<AutoRefreshingAuthClient> _authenticateWithConsent() async {
    final client = await clientViaUserConsent(
      ClientId(_clientId, null),
      _scopes,
      (url) async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw Exception("Could not launch $url");
        }
      },
    );

    // Store tokens securely
    final credentials = client.credentials;
    await _storage.write(
        key: 'accessToken', value: credentials.accessToken.data);
    await _storage.write(key: 'refreshToken', value: credentials.refreshToken);

    return client;
  }
}
