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
    log.info('fetchSleepScores');
    emit(state.copyWith(loading: true));
    DateTime from;
    DateTime to;
    List<SleepScore> newScores = [];
    log.info('fetchSleepScores: state.scores.isEmpty: ${state.scores.isEmpty}');
    /* DateTime today;
    if (state.scores.isEmpty) {
      today = DateTime.now();
    } else {
      today = state.scores.first.from;
    } */
    //from = DateTime(today.year, today.month, today.day - 7);
    //to = DateTime(today.year, today.month, today.day, 23, 59, 59);

    //Lets analize 2 days for now
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    DateTime sevenDaysAgo = DateTime(now.year, now.month, now.day - 7, 0, 0, 0);

    from = sevenDaysAgo;
    to = endOfDay;

    Map<String, int> DaysHoursAvgHeartRate = {};

    log.info('fetchSleepScores: from: $from, to: $to');
    List<SleepSession> newSleepSessions =
        await healthService.getSleepSessions(from, to);
    log.info('fetchSleepScores: sleepSessions: $newSleepSessions');
    List<SleepDataPoint> newSleepData =
        await healthService.getSleepData(from, to);
    log.info('fetchSleepScores: sleepData: $newSleepData');
    List<HeartRate> newHeartRates = await healthService.getHeartRates(from, to);
    log.info('fetchSleepScores: heartRates: $newHeartRates');

    //TODO Asume they are ordered
    int currentDay = -1;
    int currentHour = -1;
    int totalInDay = 0;
    for (HeartRate heartRate in newHeartRates) {
      if (currentDay == -1 && currentHour == -1) {
        currentDay = heartRate.from.day;
        currentHour = heartRate.from.hour;
      }
      if (heartRate.from.day == heartRate.to.day &&
          heartRate.from.hour == heartRate.to.hour) {
        totalInDay++;
        int summatory = DaysHoursAvgHeartRate["$currentDay-$currentHour"] ?? 0;
        DaysHoursAvgHeartRate["$currentDay-$currentHour"] =
            summatory + heartRate.averageHeartRate;
      }
      if (currentDay != heartRate.from.day ||
          currentHour != heartRate.from.hour) {
        int value = DaysHoursAvgHeartRate["$currentDay-$currentHour"] ?? 0;
        DaysHoursAvgHeartRate["$currentDay-$currentHour"] =
            (value / totalInDay).round();
        currentDay = heartRate.from.day;
        currentHour = heartRate.from.hour;
        totalInDay = 0;
      }
    }
    log.info('fetchSleepScores: heartRatesByHours: $DaysHoursAvgHeartRate');

    //WHen user is sleeping:

    var averageRate = DaysHoursAvgHeartRate.values
            .fold(0, (prev, element) => prev + element) /
        DaysHoursAvgHeartRate.length;

    // Define a percentage to determine significant decrease (e.g., 10% below average)
    var thresholdRate = averageRate * 0.90; // 10% below average

    String? startSleep;
    List<String> sleepPeriods = [];

    // Iterate through heart rates to find sleep periods
    DaysHoursAvgHeartRate.forEach((hour, rate) {
      if (rate < thresholdRate && startSleep == null) {
        // Sleep starts
        startSleep = hour;
      } else if (rate >= thresholdRate && startSleep != null) {
        // Sleep ends
        sleepPeriods.add("$startSleep to $hour");
        startSleep = null;
      }
    });

    // Handle ongoing sleep at the end of data
    if (startSleep != null) {
      sleepPeriods.add("$startSleep to end of data");
    }

    // Output the results
    print("Detected sleep periods based on relative heart rate changes:");
    //end

    List<HeartRate> restingHeartRates =
        await healthService.getRestingRates(from, to);
    log.info('fetchSleepScores: restingHeartRates: $newHeartRates');

    int sumOfRestingHeartRates = 0;
    for (HeartRate rate in restingHeartRates) {
      sumOfRestingHeartRates += rate.averageHeartRate;
    }
    double averageRestingHeartRate =
        sumOfRestingHeartRates / restingHeartRates.length;
    log.info(
        "fetchSleepScores: Average Resting Heart Rate $averageRestingHeartRate");

    // Variables to track transitions
    String? startDecreasing;
    String? startIncreasing;
    List<String> potentialSleepPeriods = [];
    bool wasAboveAverage =
        DaysHoursAvgHeartRate.entries.first.value > averageRestingHeartRate;

    // Iterate through heart rates to find transitions
    DaysHoursAvgHeartRate.forEach((hour, rate) {
      if (rate < averageRestingHeartRate && wasAboveAverage) {
        // Transition from above to below average
        startDecreasing = hour;
        wasAboveAverage = false;
      } else if (rate >= averageRestingHeartRate && !wasAboveAverage) {
        // Transition from below to above average
        if (startDecreasing != null) {
          potentialSleepPeriods.add("$startDecreasing to $hour");
        }
        wasAboveAverage = true;
      }
    });

    // Output the results
    print("Detected potential sleep periods:");
    potentialSleepPeriods.forEach(print);

    log.info('fetchSleepScores: mapping data to scores');
    for (String potentialSleepPeriod in potentialSleepPeriods) {
      String start = potentialSleepPeriod.split("to")[0].trim();
      int startDay = int.parse(start.split("-")[0]);
      int startHour = int.parse(start.split("-")[1]);
      String end = potentialSleepPeriod.split("to")[1].trim();
      int endtDay = int.parse(end.split("-")[0]);
      int endHour = int.parse(end.split("-")[1]);

      DateTime scorefrom =
          DateTime(from.year, from.month, startDay, startHour - 2, 0, 0, 0, 0);
      DateTime scoreTo =
          DateTime(from.year, from.month, endtDay, endHour + 2, 0, 0, 0, 0);

      log.info(
          'fetchSleepScores: current score from: $scorefrom, to: $scoreTo');
      List<SleepDataPoint> sleepPoints = newSleepData.where((element) {
        return element.from.isAfter(scorefrom) || element.to.isBefore(scoreTo);
      }).toList();
      List<HeartRate> heartRatesPoints = newHeartRates.where((element) {
        return element.from.isAfter(scorefrom) || element.to.isBefore(scoreTo);
      }).toList();

      List<SleepSession> sleepSessions = newSleepSessions.where((element) {
        return element.from.isAfter(scorefrom) || element.to.isBefore(scoreTo);
      }).toList();

      //orderSleepPoints by hour minute second
      sleepPoints.sort((a, b) => a.from.compareTo(b.from));
      //orderHeartRates by hour minute second
      heartRatesPoints.sort((a, b) => a.from.compareTo(b.from));

      sleepSessions.sort((a, b) => a.from.compareTo(b.from));

      log.info('fetchSleepScores: sleep: $sleepPoints');
      log.info('fetchSleepScores: heartRates: $heartRatesPoints');
      if (sleepSessions.isEmpty) {
        continue;
      }
      newScores = [
        SleepScore(
          from: scorefrom,
          to: scoreTo,
          heartRatesDataPoints: heartRatesPoints,
          sleepDataPoints: sleepPoints,
          sleepSessions: sleepSessions,
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
