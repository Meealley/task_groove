import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_groove/cubits/google_calendar/google_calender_cubit.dart'; // Adjust the import path
import 'package:task_groove/repository/google_calendar_repository.dart';

class CalendarIntegrationScreen extends StatefulWidget {
  const CalendarIntegrationScreen({super.key});

  @override
  State<CalendarIntegrationScreen> createState() =>
      _CalendarIntegrationScreenState();
}

class _CalendarIntegrationScreenState extends State<CalendarIntegrationScreen> {
  late GoogleCalenderCubit _calendarCubit;

  @override
  void initState() {
    super.initState();
    // Initialize the cubit with the repository
    _calendarCubit = GoogleCalenderCubit(
      googleCalendarRepository: GoogleCalendarRepository(),
    );
  }

  @override
  void dispose() {
    _calendarCubit.close(); // Dispose the cubit when the widget is destroyed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _calendarCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Calendar Integration"),
        ),
        body: BlocBuilder<GoogleCalenderCubit, GoogleCalenderState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.error.message.isNotEmpty) {
              return Center(
                child: Text(
                  state.error.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<GoogleCalenderCubit>().authenticateUser();
                  },
                  child: const Text("Authenticate with Google Calendar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GoogleCalenderCubit>().fetchEvents();
                  },
                  child: const Text("Fetch Events"),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<GoogleCalenderCubit>().logout();
                  },
                  child: const Text("Logout"),
                ),
                const SizedBox(height: 20),
                if (state.events.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        return ListTile(
                          title: Text(event.summary ?? "No Title"),
                          subtitle: Text(
                            event.start?.dateTime?.toString() ??
                                "No Start Time",
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Center(child: Text("No events available")),
              ],
            );
          },
        ),
      ),
    );
  }
}
