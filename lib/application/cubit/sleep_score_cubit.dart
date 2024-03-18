import 'package:flutter_bloc/flutter_bloc.dart';
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
}

class SleepScoreCubit extends Cubit<SleepScoreState> {
  final HealthService healthService;
  SleepScoreCubit(
    this.healthService,
  ) : super(SleepScoreState(
          scores: [],
          loading: false,
          lastUpdatedAt: DateTime.now(),
        ));

  Future<void> fetchSleepScores() async {
    emit(state.copyWith(loading: true));
    DateTime from;
    DateTime to;
    List<SleepScore> scores = [];
    if (state.scores.isEmpty) {
      from = DateTime.now().subtract(const Duration(days: 7));
      to = DateTime.now();
    } else {
      from = state.scores.first.from.subtract(const Duration(days: 7));
      to = state.scores.first.from;
    }
    List<SleepDataPoint> newScores = await healthService.getSleepData(from, to);
    List<HeartRate> heartRates = await healthService.getHeartRates(from, to);
    for (int i = 0; i < 7; i++) {
      DateTime from = DateTime.now().subtract(Duration(
        days: i,
      ));
      DateTime to = from.add(const Duration(days: 1, hours: 12, minutes: 30));
      List<SleepDataPoint> points = newScores.where((element) {
        return element.from.day == from.day;
      }).toList();
      List<HeartRate> rates = heartRates.where((element) {
        return element.from.day == from.day;
      }).toList();
      scores.add(
        SleepScore(
          from: from,
          to: to,
          heartRatesDataPoints: rates,
          sleepDataPoints: points,
        ),
      );
    }
    emit(state.copyWith(
      scores: scores,
      loading: false,
      lastUpdatedAt: DateTime.now(),
    ));
  }
}
