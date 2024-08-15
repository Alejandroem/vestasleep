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
      body: BlocBuilder<SleepSessionNewCubit, SleepSessionState>(
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
                _formatDuration(session.to.difference(session.from));
                return ListTile(
                  title: Text(
                      'Session from ${_formatDateTime(session.from)} to ${_formatDateTime(session.to)}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Session Duration: $sessionDuration'),
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
                    ],
                  ),
                );
              },
            );
          } else if (state is SleepSessionError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
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