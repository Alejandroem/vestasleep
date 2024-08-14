import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:vestasleep/application/heart_algo/sleep_Session/sleep_session_bloc.dart';

class SleepSessionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Sessions with Average Heart Rates'),
      ),
      body: BlocProvider(
        create: (context) => SleepSessionCubit(Health())..loadSleepSessions(),
        child: BlocBuilder<SleepSessionCubit, SleepSessionState>(
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
                  return ListTile(
                    title:
                        Text('Session from ${session.from} to ${session.to}'),
                    subtitle: Text(
                        'Average Heart Rate: ${session.averageHeartRate.toStringAsFixed(1)} bpm\nSleep Score: ${_calculateHeartRateScore(session.averageHeartRate)}'),
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
