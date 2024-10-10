import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:vestasleep/domain/models/sleep_data_point.dart';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_score.dart';
import '../../domain/models/sleep_session.dart';
import '../../domain/services/health_service.dart';

class SleepScoreState {
  final DateTime lastUpdatedAt;
  final List<SleepScore> scores;
  final bool loading;

  SleepScoreState({
    required this.scores,
    required this.loading,
    required this.lastUpdatedAt,
  });

  //copywith
  SleepScoreState copyWith({
    List<SleepScore>? scores,
    bool? loading,
    DateTime? lastUpdatedAt,
  }) {
    return SleepScoreState(
      scores: scores ?? this.scores,
      loading: loading ?? this.loading,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  String weeklyScore() {
    int score = 0;
    for (SleepScore sleepScore in scores) {
      score += sleepScore.getOverallScoreValue();
    }
    return "${score ~/ scores.length}";
  }

  String averageSessionTime() {
    int minutes = 0;
    int hours = 0;
    for (SleepScore sleepScore in scores) {
      minutes += sleepScore.sessionTotalMins();
    }
    hours = minutes ~/ scores.length ~/ 60;
    return "$hours hr ${minutes ~/ scores.length % 60} min";
  }
}

class SleepScoreCubit extends Cubit<SleepScoreState> {
  final log = Logger('SleepScoreCubit');
  final HealthService healthService;
  SleepScoreCubit(
    this.healthService,
  ) : super(SleepScoreState(
          scores: [],
          loading: false,
          lastUpdatedAt: DateTime.now(),
        ));

  Future<void> fetchSleepScores() async { 
    //Step 1: use your algorithm to get start and end date of session of the last 7 days
    //Create a SleepScore object with that from and to
    //Fetch the heart rates, sleep data points and sleep sessions from the last 7 days
    //Group those data points by from and to
    //You should emit those scores on the new state
    
    //inside of a for
    // for session in sessions of what your algorithm calculated
      newScores = [
        SleepScore(
          from: scorefrom,
          to: scoreTo,
          heartRatesDataPoints: heartRatesPoints,
          sleepDataPoints: sleepPoints,
          sleepSessions: sleepSessions,
        ),
      ];
    emit(state.copyWith(
      scores: scores,
      loading: false,
      lastUpdatedAt: DateTime.now(),
    ));
  }
}
