// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'google_calender_cubit.dart';

class GoogleCalenderState extends Equatable {
  final bool isAuthenticated;
  final bool isLoading;
  final List<calendar.Event> events;
  final CustomError error;

  const GoogleCalenderState(
      {required this.isAuthenticated,
      required this.isLoading,
      required this.events,
      required this.error});

  factory GoogleCalenderState.initial() {
    return const GoogleCalenderState(
      isAuthenticated: false,
      isLoading: false,
      events: [],
      error: CustomError(),
    );
  }

  @override
  List<Object> get props => [isAuthenticated, isLoading, events, error];

  @override
  bool get stringify => true;

  GoogleCalenderState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    List<calendar.Event>? events,
    CustomError? error,
  }) {
    return GoogleCalenderState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      events: events ?? this.events,
      error: error ?? this.error,
    );
  }
}
