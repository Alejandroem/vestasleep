import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:vestasleep/application/session_heart_rate/sleep_session_new_cubit.dart';

class SleepSessionByHeartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SleepSessionNewCubit(Health())..loadSleepSessions(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sleep Sessions by Heart Rates'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<SleepSessionNewCubit, SleepSessionState>(
                builder: (context, state) {
                  final cubit = context.read<SleepSessionNewCubit>();
                  return ElevatedButton(
                    onPressed: () {
                      cubit.toggleFiltering();
                      cubit.loadSleepSessions();
                    },
                    child: Text(
                      cubit.isFilteringEnabled
                          ? "Disable Sleep Data Filtering"
                          : "Enable Sleep Data Filtering",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<SleepSessionNewCubit, SleepSessionState>(
                  builder: (context, state) {
                    if (state is SleepSessionInitial) {
                      return Center(child: Text('No data available.'));
                    } else if (state is SleepSessionLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is SleepSessionLoaded) {
                      return ListView.builder(
                        itemCount: state.sleepSessions.length,
                        itemBuilder: (context, index) {
                          final session = state.sleepSessions[index];
                          final sessionDuration =
                              session.to.difference(session.from);
                          final formattedDuration =
                              _formatDuration(sessionDuration);

                          return Card(
                            //margin: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Session start: "),
                                      Expanded(
                                          child: Text(
                                        "${_formatDateTime(session.from)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Session end: "),
                                      Expanded(
                                          child: Text(
                                        "${_formatDateTime(session.to)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))
                                    ],
                                  ),
                                  if (sessionDuration.inMinutes > 0)
                                    Row(
                                      children: [
                                        Text("Session Duration: "),
                                        Expanded(
                                            child: Text(
                                          "${formattedDuration}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ))
                                      ],
                                    ),
                                  Text(
                                      'Asleep Duration: ${_formatDuration(session.asleepDuration)}'),
                                  Text(
                                      'REM Duration: ${_formatDuration(session.remDuration)}'),
                                  Text(
                                      'Awake Duration: ${_formatDuration(session.awakeDuration)}'),
                                  Text(
                                      'In Bed Duration: ${_formatDuration(session.inBedDuration)}'),
                                  Text(
                                      'Average Heart Rate: ${session.averageHeartRate.toStringAsFixed(1)} bpm'),
                                  Text(
                                      'Sleep Score: ${_calculateHeartRateScore(session.averageHeartRate)}'),
                                  if (session.breaks.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Breaks: ${session.breaks.length}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        for (var breakItem in session.breaks)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Break start: "),
                                                    Expanded(
                                                        child: Text(
                                                      "${_formatDateTime(breakItem.start)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Break end: "),
                                                    Expanded(
                                                        child: Text(
                                                      "${_formatDateTime(breakItem.end)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("Break duration:"),
                                                    Expanded(
                                                        child: Text(
                                                      " ${_formatDuration(breakItem.end.difference(breakItem.start))}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is SleepSessionFilteringToggled) {
                      return Center(
                          child: Text(
                              'Filtering ${state.isFilteringEnabled ? "Enabled" : "Disabled"}'));
                    } else if (state is SleepSessionError) {
                      return Center(child: Text('Error: ${state.message}'));
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm a');
    return formatter.format(dateTime);
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  double _calculateHeartRateScore(double averageHeartRate) {
    if (averageHeartRate == 0) return 0;

    if (averageHeartRate <= 60) {
      return 100;
    } else if (averageHeartRate <= 70) {
      return 80 + ((70 - averageHeartRate) / 10) * 20;
    } else if (averageHeartRate <= 80) {
      return 50 + ((80 - averageHeartRate) / 10) * 30;
    } else {
      return 50; // Minimum score for very high heart rates
    }
  }
}
