import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:vestasleep/domain/models/sleep_data_point.dart';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_score.dart';
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
    log.info('fetchSleepScores');
    emit(state.copyWith(loading: true));
    DateTime from;
    DateTime to;
    List<SleepScore> scores = [];
    log.info('fetchSleepScores: state.scores.isEmpty: ${state.scores.isEmpty}');
    if (state.scores.isEmpty) {
      from = DateTime.now().subtract(const Duration(days: 7));
      to = DateTime.now();
    } else {
      from = state.scores.first.from.subtract(const Duration(days: 7));
      to = state.scores.first.from;
    }
    log.info('fetchSleepScores: from: $from, to: $to');
    List<SleepDataPoint> newSleepData =
        await healthService.getSleepData(from, to);
    log.info('fetchSleepScores: sleepData: $newSleepData');
    List<HeartRate> newHeartRates = await healthService.getHeartRates(from, to);
    log.info('fetchSleepScores: heartRates: $newHeartRates');

    log.info('fetchSleepScores: mapping data to scores');
    for (int i = 0; i < 7; i++) {
      DateTime from = DateTime.now().subtract(Duration(
        days: i,
      ));
      DateTime to = from.add(const Duration(days: 1, hours: 12, minutes: 30));

      log.info('fetchSleepScores: current score from: $from, to: $to');
      List<SleepDataPoint> sleepPoints = newSleepData.where((element) {
        return element.from.day == from.day;
      }).toList();
      List<HeartRate> heartRatesPoints = newHeartRates.where((element) {
        return element.from.day == from.day;
      }).toList();
      log.info('fetchSleepScores: sleep: $sleepPoints');
      log.info('fetchSleepScores: heartRates: $heartRatesPoints');
      scores.add(
        SleepScore(
          from: from,
          to: to,
          heartRatesDataPoints: heartRatesPoints,
          sleepDataPoints: sleepPoints,
        ),
      );
    }
    log.info('fetchSleepScores: scores: $scores');
    emit(state.copyWith(
      scores: scores,
      loading: false,
      lastUpdatedAt: DateTime.now(),
    ));
  }
}
