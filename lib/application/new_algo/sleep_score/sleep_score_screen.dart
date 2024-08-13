import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:vestasleep/application/new_algo/model/daily_sleep_data.dart';
import 'package:vestasleep/application/new_algo/sleep_score/sleep_score_cubit.dart';

class SleepScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Score'),
      ),
      body: BlocProvider(
        create: (context) => SleepScoreCubit(Health())..fetchSleepData(),
        child: BlocBuilder<SleepScoreCubit, SleepScoreState>(
          builder: (context, state) {
            if (state is SleepScoreLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SleepScoreLoaded) {
              return _buildSleepScoreList(context, state.dailySleepData);
            } else if (state is SleepSessionScoreLoaded) {
              final DateFormat formatter =
                  DateFormat('MMM d, yyyy h:mm a'); // Format for AM/PM

              return ListView.builder(
                itemCount: state.sessionScores.length,
                itemBuilder: (context, index) {
                  final sessionScore = state.sessionScores[index];
                  final session = sessionScore.session;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        'Session from ${formatter.format(session.from)} to ${formatter.format(session.to)}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Sleep Score: ${sessionScore.sleepScore.toStringAsFixed(1)}'),
                          Text('Grade: ${sessionScore.grade}'),
                          Text(
                              'Total Sleep: ${session.asleepDuration.inHours}h ${session.asleepDuration.inMinutes % 60}m'),
                          Text(
                              'REM Sleep: ${session.remDuration.inHours}h ${session.remDuration.inMinutes % 60}m'),
                          Text(
                              'Time Awake: ${session.awakeDuration.inHours}h ${session.awakeDuration.inMinutes % 60}m'),
                          Text(
                              'Time in Bed: ${session.inBedDuration.inHours}h ${session.inBedDuration.inMinutes % 60}m'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is SleepScoreError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }

  formatDate(DateTime time) {}

  Widget _buildSleepScoreList(BuildContext context, List<DailySleepData> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final dailyData = data[index];
        return Card(
          margin: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              'Date: ${_formatDate(dailyData.date)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sleep Score: ${dailyData.sleepScore.toStringAsFixed(1)}'),
                Text('Grade: ${dailyData.grade}'),
                Text('Time in bed: ${_formatDuration(dailyData.timeInBed)}'),
                Text('Asleep: ${_formatDuration(dailyData.asleepDuration)}'),
                Text('REM: ${_formatDuration(dailyData.remDuration)}'),
                Text(
                    'AWAKE: ${_formatDuration(dailyData.awakeDuration ?? Duration.zero)}'),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }
}
