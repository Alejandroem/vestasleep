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
    List<SleepScore> newScores = [];
    log.info('fetchSleepScores: state.scores.isEmpty: ${state.scores.isEmpty}');
    DateTime today;
    if (state.scores.isEmpty) {
      today = DateTime.now();
    } else {
      today = state.scores.first.from;
    }
    from = DateTime(today.year, today.month, today.day - 7);
    to = DateTime(today.year, today.month, today.day, 23, 59, 59);
    log.info('fetchSleepScores: from: $from, to: $to');
    List<SleepDataPoint> newSleepData =
        await healthService.getSleepData(from, to);
    log.info('fetchSleepScores: sleepData: $newSleepData');
    List<HeartRate> newHeartRates = await healthService.getHeartRates(from, to);
    log.info('fetchSleepScores: heartRates: $newHeartRates');

    log.info('fetchSleepScores: mapping data to scores');
    for (int i = 0; i < 7; i++) {
      DateTime scorefrom =
          DateTime(from.year, from.month, from.day + i, 0, 0, 0, 0, 0);
      DateTime scoreTo =
          DateTime(from.year, from.month, from.day + i, 23, 59, 59, 0, 0);

      log.info(
          'fetchSleepScores: current score from: $scorefrom, to: $scoreTo');
      List<SleepDataPoint> sleepPoints = newSleepData.where((element) {
        return element.from.day == scorefrom.day &&
            element.from.month == scorefrom.month &&
            element.from.year == scorefrom.year;
      }).toList();
      List<HeartRate> heartRatesPoints = newHeartRates.where((element) {
        return element.from.day == scorefrom.day &&
            element.from.month == scorefrom.month &&
            element.from.year == scorefrom.year;
      }).toList();

      //orderSleepPoints by hour minute second
      sleepPoints.sort((a, b) => a.from.compareTo(b.from));
      //orderHeartRates by hour minute second
      heartRatesPoints.sort((a, b) => a.from.compareTo(b.from));

      log.info('fetchSleepScores: sleep: $sleepPoints');
      log.info('fetchSleepScores: heartRates: $heartRatesPoints');
      newScores = [
        SleepScore(
          from: scorefrom,
          to: scoreTo,
          heartRatesDataPoints: heartRatesPoints,
          sleepDataPoints: sleepPoints,
        ),
        ...newScores,
      ];
    }
    log.info('fetchSleepScores: scores: $newScores');

    List<SleepScore> scores = [...state.scores, ...newScores];
    scores.sort((a, b) => a.from.compareTo(b.from));
    emit(state.copyWith(
      scores: scores,
      loading: false,
      lastUpdatedAt: DateTime.now(),
    ));
  }
}
