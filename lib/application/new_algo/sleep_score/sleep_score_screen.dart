import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';

import 'sleep_score_cubit.dart';

class SleepScoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SleepScoreCubit(Health())..fetchSleepData(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sleep Score Calculator'),
        ),
        body: BlocBuilder<SleepScoreCubit, SleepScoreState>(
          builder: (context, state) {
            if (state is SleepScoreLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SleepScoreLoaded) {
              return ListView.builder(
                itemCount: state.dailySleepData.length,
                itemBuilder: (context, index) {
                  final dailyData = state.dailySleepData[index];
                  return ListTile(
                    title: Text(
                      "Date: ${dailyData.date.toLocal().toIso8601String().substring(0, 10)}",
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sleep Score: ${dailyData.sleepScore.toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Grade: ${dailyData.grade}",
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          "Sleep Duration: ${dailyData.sleepDuration.inHours}h ${dailyData.sleepDuration.inMinutes % 60}m",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is SleepScoreError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("Unknown state"));
            }
          },
        ),
      ),
    );
  }
}
