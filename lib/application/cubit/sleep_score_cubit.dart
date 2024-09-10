import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:logging/logging.dart';
import 'package:vestasleep/domain/models/sleep_data_point.dart';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_score.dart';
import '../../domain/models/sleep_session.dart';
import '../../domain/services/health_service.dart';
import '../session_heart_rate/model/sleep_break.dart';

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
    try {
      for (SleepScore sleepScore in scores) {
        score += sleepScore.getOverallScoreValue();
      }
      return "${score ~/ scores.length}";
    } catch (e) {
      return "0";
    }
  }

  String averageSessionTime() {
    try {
      int minutes = 0;
      int hours = 0;
      for (SleepScore sleepScore in scores) {
        minutes += sleepScore.sessionTotalMins();
      }
      hours = minutes ~/ scores.length ~/ 60;
      return "$hours hr ${minutes ~/ scores.length % 60} min";
    } catch (e) {
      return "0 hr 0  min";
    }
  }
}

class SleepScoreCubit extends Cubit<SleepScoreState> {
  final log = Logger('SleepScoreCubit');
  final HealthService healthService;
  Duration maxAllowedBreak = Duration(hours: 1);

  SleepScoreCubit(
    this.healthService,
  ) : super(SleepScoreState(
          scores: [],
          loading: false,
          lastUpdatedAt: DateTime.now(),
        ));

  Future<void> fetchSleepScores() async {
    try {
      emit(state.copyWith(loading: true));
      DateTime from;
      DateTime to;
      List<SleepScore> newScores = [];

      to = DateTime.now();
      from = DateTime(to.year, to.month, to.day).subtract(Duration(days: 15));

      log.info('fetchSleepScores: from: $from, to: $to');
      List<SleepSession> sleepSessionData =
          await healthService.getSleepSessions(from, to);
      log.info('fetchSleepScores: sleepSessions: $sleepSessionData');
      List<SleepDataPoint> sleepData =
          await healthService.getSleepData(from, to);
      log.info('fetchSleepScores: sleepData: $sleepData');
      List<HeartRate> heartRates = await healthService.getHeartRates(from, to);
      log.info('fetchSleepScores: heartRates: $heartRates');

      // Filter out heart rates that are 0
      heartRates = heartRates.where((hr) => hr.averageHeartRate > 0).toList();

      // Process the data and emit the result
      List<SleepSessionData> sleepSessions =
          _createSleepSessionsBasedOnHeartRates(sleepSessionData, heartRates);

      sleepSessions.forEach((session) {
        var newSession = SleepSession(from: session.from, to: session.to);

        newScores = [
          SleepScore(
            from: session.from,
            to: session.to,
            heartRatesDataPoints:
                _getHeartRatesForSession(heartRates, session.from, session.to),
            sleepDataPoints:
                _getSleepPointsForSession(sleepData, session.from, session.to),
            sleepSessions: [newSession],
          ),
          ...newScores,
        ];
      });

      List<SleepScore> scores = [...state.scores, ...newScores];
      if (scores.length > 1) {
        scores.sort((a, b) => a.from.compareTo(b.from));
      }
      emit(state.copyWith(
        scores: scores,
        loading: false,
        lastUpdatedAt: DateTime.now(),
      ));
    } catch (e, s) {
      print(s);
    }
  }

  List<HeartRate> _getHeartRatesForSession(List<HeartRate> heartRateData,
      DateTime sessionStart, DateTime sessionEnd) {
    final sessionHeartRates = heartRateData
        .where(
            (hr) => hr.to.isAfter(sessionStart) && hr.from.isBefore(sessionEnd))
        .toList();

    return sessionHeartRates;
  }

  List<SleepDataPoint> _getSleepPointsForSession(
      List<SleepDataPoint> sleepPoints,
      DateTime sessionStart,
      DateTime sessionEnd) {
    final sessionSleepPoints = sleepPoints
        .where(
            (hr) => hr.to.isAfter(sessionStart) && hr.from.isBefore(sessionEnd))
        .toList();

    return sessionSleepPoints;
  }

  List<SleepSessionData> _createSleepSessionsBasedOnHeartRates(
      List<SleepSession> sleepData, List<HeartRate> heartRateData) {
    // Sort the heart rate data by timestamp to ensure correct processing order
    heartRateData.sort((a, b) => a.to.compareTo(b.to));

    List<SleepSessionData> sessions = [];
    DateTime? sessionStart;
    DateTime? sessionEnd;
    DateTime? lastHeartRateTimestamp;

    // const Duration maxAllowedBreak =
    //     Duration(minutes: 30); // Threshold duration for session breaks
    const Duration breakThreshold =
        Duration(minutes: 5); // Minimum duration for a break to be recorded
    const Duration maxAllowedGap =
        Duration(hours: 1); // Maximum allowed gap between heart rates
    List<SleepBreak> breaks = [];

    // Calculate initial heart rate statistics during sleep
    var sleepHeartRates = _getHeartRatesDuringSleep(sleepData, heartRateData);

    int minSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a < b ? a : b)
        : 40;
    int maxSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a > b ? a : b)
        : 80;
    print("MIN:${minSleepHeartRate}===MAX:${maxSleepHeartRate}");

    // Apply additional heart rate logic
    if (maxSleepHeartRate > 90) {
      maxSleepHeartRate = 90;
    }
    if (minSleepHeartRate <= 0) {
      minSleepHeartRate = 40;
    }

    DateTime? lastOutOfRangeTime;

    for (var hr in heartRateData) {
      print('Processing heart rate: ${hr.averageHeartRate} at ${hr.to}');

      // Check if the heart rate lies within the sleep range
      if (hr.averageHeartRate >= minSleepHeartRate &&
          hr.averageHeartRate <= maxSleepHeartRate) {
        if (sessionStart == null) {
          sessionStart = hr.to;
          print('Session started at $sessionStart');
        }

        // Check for large gaps between consecutive heart rate timestamps
        if (lastHeartRateTimestamp != null &&
            hr.to.difference(lastHeartRateTimestamp) > maxAllowedGap) {
          // End the session with the last valid heart rate timestamp
          sessionEnd = lastHeartRateTimestamp;
          print(
              'Ending session due to large gap from $sessionStart to $sessionEnd');

          final sessionDuration = sessionEnd!.difference(sessionStart!);
          if (sessionDuration.inMinutes > 0) {
            /*  _recalculateDurations(
              sleepData,
              sessionStart,
              sessionEnd,
            );*/
            double avgHeartRate = _calculateAverageHeartRateForSession(
                heartRateData, sessionStart, sessionEnd);
            sessions.add(SleepSessionData(
              from: sessionStart,
              to: sessionEnd,
              inBedDuration: sessionDuration,
              averageHeartRate: avgHeartRate,
              breaks: breaks, // Include the list of breaks
            ));
            print('Session added with duration: $sessionDuration');
          }

          // Reset for a new session
          sessionStart = hr.to;
          breaks = [];
        }

        sessionEnd =
            hr.to; // Update the session end to the current heart rate timestamp
        lastHeartRateTimestamp = hr.to; // Track the last heart rate timestamp

        // If there was an out-of-range break detected earlier, it should now be recorded if it exceeds the threshold
        if (lastOutOfRangeTime != null && lastOutOfRangeTime != sessionEnd) {
          final breakDuration = sessionEnd.difference(lastOutOfRangeTime);
          if (breakDuration > breakThreshold) {
            breaks.add(SleepBreak(start: lastOutOfRangeTime, end: sessionEnd));
            print('Break added from $lastOutOfRangeTime to $sessionEnd');
          }
          lastOutOfRangeTime = null;
        }
      } else {
        // Handle out-of-range heart rates with duration threshold
        if (sessionEnd != null &&
            sessionStart != null &&
            sessionEnd.isAfter(sessionStart)) {
          if (hr.to.difference(sessionEnd) <= maxAllowedBreak) {
            // This is a valid break within the session
            lastOutOfRangeTime = sessionEnd;
            print('Break detected starting at $sessionEnd');
          } else {
            // If out-of-range duration exceeds the threshold, finalize the session
            final sessionDuration = sessionEnd!.difference(sessionStart!);

            if (sessionDuration.inMinutes > 0) {
              print('Finalizing session from $sessionStart to $sessionEnd');
              /*    _recalculateDurations(
                sleepData,
                sessionStart,
                sessionEnd,
              );*/
              double avgHeartRate = _calculateAverageHeartRateForSession(
                  heartRateData, sessionStart, sessionEnd);
              sessions.add(SleepSessionData(
                from: sessionStart,
                to: sessionEnd,
                inBedDuration: sessionDuration,
                averageHeartRate: avgHeartRate,
                breaks: breaks, // Include the list of breaks
              ));
              print('Session added with duration: $sessionDuration');
            } else {
              print('Skipped session with zero or negative duration.');
            }

            // Reset for the next potential session
            sessionStart = null;
            sessionEnd = null;
            breaks = [];
            lastOutOfRangeTime = null;
          }
        }
      }
    }

    // Add the last session if it exists and has a non-zero duration
    if (sessionStart != null &&
        sessionEnd != null &&
        sessionEnd.isAfter(sessionStart)) {
      final sessionDuration = sessionEnd.difference(sessionStart);
      if (sessionDuration.inMinutes > 0) {
        print('Finalizing last session from $sessionStart to $sessionEnd');
        /*    _recalculateDurations(
          sleepData,
          sessionStart,
          sessionEnd,
        );*/
        double avgHeartRate = _calculateAverageHeartRateForSession(
            heartRateData, sessionStart, sessionEnd);
        sessions.add(SleepSessionData(
          from: sessionStart,
          to: sessionEnd,
          inBedDuration: sessionDuration,
          averageHeartRate: avgHeartRate,
          breaks: breaks, // Include the list of breaks
        ));
        print('Final session added with duration: $sessionDuration');
      } else {
        print('Skipped final session with zero or negative duration.');
      }
    }

    print('Total sessions created: ${sessions.length}');
    // Reverse the session list before returning
    if (sessions.length > 0) {
      sessions = sessions.reversed.toList();
    }
    return sessions;
  }

  bool _isWithinAnySleepSession(
      DateTime timestamp, List<HealthDataPoint> sleepData) {
    // Check if the timestamp is within any sleep session data
    for (var sleepPoint in sleepData) {
      if (timestamp.isAfter(sleepPoint.dateFrom) &&
          timestamp.isBefore(sleepPoint.dateTo)) {
        return true;
      }
    }
    return false;
  }

  /* void _recalculateDurations(
    List<SleepSession> sleepData,
    DateTime sessionStart,
    DateTime sessionEnd,
    Duration timeAsleep,
    Duration timeInRem,
    Duration timeAwake,
  ) {
    timeAsleep = Duration.zero;
    timeInRem = Duration.zero;
    timeAwake = Duration.zero;

    for (var sleepPoint in sleepData) {
      if (sleepPoint.dateFrom.isBefore(sessionEnd) &&
          sleepPoint.dateTo.isAfter(sessionStart)) {
        DateTime effectiveStart = sleepPoint.dateFrom.isBefore(sessionStart)
            ? sessionStart
            : sleepPoint.dateFrom;
        DateTime effectiveEnd = sleepPoint.dateTo.isAfter(sessionEnd)
            ? sessionEnd
            : sleepPoint.dateTo;

        if (sleepPoint.type == HealthDataType.SLEEP_ASLEEP ||
            sleepPoint.type == HealthDataType.SLEEP_ASLEEP_CORE) {
          timeAsleep += effectiveEnd.difference(effectiveStart);
        } else if (sleepPoint.type == HealthDataType.SLEEP_REM) {
          timeInRem += effectiveEnd.difference(effectiveStart);
        } else if (sleepPoint.type == HealthDataType.SLEEP_AWAKE) {
          timeAwake += effectiveEnd.difference(effectiveStart);
        }
      }
    }
  }*/

  double _calculateAverageHeartRateForSession(List<HeartRate> heartRateData,
      DateTime sessionStart, DateTime sessionEnd) {
    final sessionHeartRates = heartRateData
        .where(
            (hr) => hr.to.isAfter(sessionStart) && hr.from.isBefore(sessionEnd))
        .map((hr) => hr.averageHeartRate)
        .toList();

    return sessionHeartRates.isNotEmpty
        ? sessionHeartRates.reduce((a, b) => a + b) / sessionHeartRates.length
        : 0.0;
  }

  List<int> _getHeartRatesDuringSleep(
      List<SleepSession> sleepData, List<HeartRate> heartRateData) {
    List<int> sleepHeartRates = [];

    for (var sleepPoint in sleepData) {
/*      if (sleepPoint.type == HealthDataType.SLEEP_ASLEEP ||
          sleepPoint.type == HealthDataType.SLEEP_ASLEEP_CORE ||
          sleepPoint.type == HealthDataType.SLEEP_IN_BED ||
          sleepPoint.type == HealthDataType.SLEEP_SESSION) {*/
      for (var hr in heartRateData) {
        // Include heart rates that are exactly at the boundaries as well
        if (!hr.to.isBefore(sleepPoint.from) &&
            !hr.from.isAfter(sleepPoint.to)) {
          sleepHeartRates.add(hr.averageHeartRate);
        }
      }
      //}
    }

    return sleepHeartRates;
  }
}

class SleepSessionData {
  final DateTime from;
  final DateTime to;

  final List<double>? heartRates;
  final double averageHeartRate;
  final List<SleepBreak> breaks; // List of breaks within the session
  final Duration inBedDuration;

  SleepSessionData({
    required this.from,
    required this.to,
    required this.inBedDuration,
    this.heartRates,
    required this.averageHeartRate,
    required this.breaks,
  });
}
