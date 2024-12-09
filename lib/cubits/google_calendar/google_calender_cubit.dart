import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:task_groove/repository/google_calendar_repository.dart';
import 'package:task_groove/utils/custom_error.dart';

part 'google_calender_state.dart';

class GoogleCalenderCubit extends Cubit<GoogleCalenderState> {
  final GoogleCalendarRepository googleCalendarRepository;

  GoogleCalenderCubit({required this.googleCalendarRepository})
      : super(GoogleCalenderState.initial());

  // Authenticate User
  Future<void> authenticateUser() async {
    emit(state.copyWith(isLoading: true));

    try {
      final api = await googleCalendarRepository.authenticateUser();
      if (api != null) {
        emit(state.copyWith(isAuthenticated: true, isLoading: false));
      } else {
        emit(state.copyWith(
          isLoading: false,
          error: const CustomError(message: "Authentication failed"),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: const CustomError(message: "Authentication failed"),
      ));
    }
  }

  /// Fetch events
  Future<void> fetchEvents({int maxResults = 10}) async {
    emit(state.copyWith(isLoading: true));
    try {
      final events = await googleCalendarRepository.fetchEvents(
        maxResults: maxResults,
      );
      emit(state.copyWith(events: events, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: CustomError(message: "Error fetching events: $e"),
      ));
    }
  }

  /// Create a new event
  Future<void> createEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    emit(state.copyWith(isLoading: true));
    try {
      await googleCalendarRepository.createEvent(
        title: title,
        startTime: startTime,
        endTime: endTime,
      );
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: CustomError(message: "Error creating event: $e"),
      ));
    }
  }

  /// Sync tasks to calendar
  Future<void> syncTasksToCalendar(List<Map<String, dynamic>> tasks) async {
    emit(state.copyWith(isLoading: true));
    try {
      await googleCalendarRepository.syncTasksToCalendar(tasks);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: CustomError(message: "Error syncing tasks: $e"),
      ));
    }
  }

  /// Logout and clear tokens
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    try {
      await googleCalendarRepository.clearTokens();
      emit(GoogleCalenderState.initial());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: CustomError(message: "Error during logout: $e"),
      ));
    }
  }
}
