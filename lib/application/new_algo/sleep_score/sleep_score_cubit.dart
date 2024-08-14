import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

import 'package:vestasleep/application/new_algo/model/daily_sleep_data.dart';
import 'package:vestasleep/application/new_algo/model/sleep_session.dart';
import 'package:vestasleep/application/new_algo/model/sleep_session_score.dart';

class SleepScoreCubit extends Cubit<SleepScoreState> {
  final Health healthFactory;

  SleepScoreCubit(this.healthFactory) : super(SleepScoreInitial());

  Future<void> fetchSleepData() async {
    emit(SleepScoreLoading());

    try {
      healthFactory.configure(useHealthConnectIfAvailable: true);
      await Permission.activityRecognition.request();
      var types = [
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_REM,
        HealthDataType.SLEEP_ASLEEP_CORE
      ];
      if (Platform.isAndroid) {
        types = [
          HealthDataType.SLEEP_SESSION,
          HealthDataType.SLEEP_ASLEEP,
          HealthDataType.SLEEP_AWAKE,
          HealthDataType.HEART_RATE,
          HealthDataType.SLEEP_REM,
          HealthDataType.SLEEP_LIGHT
        ];
      }
      final permissions = types.map((e) => HealthDataAccess.READ).toList();
      bool? hasPermissions =
          await healthFactory.hasPermissions(types, permissions: permissions) ??
              false;
      bool requested = false;
      if (!hasPermissions) {
        requested = await healthFactory.requestAuthorization(types,
            permissions: permissions);
      } else {
        requested = true;
      }

      if (requested) {
        DateTime endDate = DateTime.now();
        DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day)
            .subtract(Duration(days: 7));
        List<HealthDataType> mTypes = [];
        if (Platform.isAndroid) {
          mTypes = [
            HealthDataType.SLEEP_SESSION,
            HealthDataType.SLEEP_ASLEEP,
            HealthDataType.SLEEP_AWAKE,
            HealthDataType.SLEEP_REM,
            HealthDataType.SLEEP_LIGHT
          ];
        } else {
          mTypes = [
            HealthDataType.SLEEP_IN_BED,
            HealthDataType.SLEEP_ASLEEP,
            HealthDataType.SLEEP_AWAKE,
            HealthDataType.SLEEP_REM,
            HealthDataType.SLEEP_ASLEEP_CORE
          ];
        }
        List<HealthDataPoint> sleepData =
            await healthFactory.getHealthDataFromTypes(
                startTime: startDate, endTime: endDate, types: mTypes);

        List<HealthDataPoint> heartRateData = await healthFactory
            .getHealthDataFromTypes(
                startTime: startDate,
                endTime: endDate,
                types: [HealthDataType.HEART_RATE]);

        // Process heart rate data with splitting logic
        heartRateData = processHeartRateData(heartRateData);

        /* List<SleepSession> sessions = processSleepData(sleepData);
        List<DailySleepData> dailySleepData =
            calculateDailySleepData(sessions, heartRateData);

        emit(SleepScoreLoaded(dailySleepData));*/

        List<SleepSession> sessions = processSleepData(sleepData);
        List<SleepSessionScore> sessionScores =
            calculateSessionScores(sessions, heartRateData);
        final sortedSessionScores = sessionScores
          ..sort((a, b) => b.session.from.compareTo(a.session.from));
        emit(SleepSessionScoreLoaded(sortedSessionScores));
      } else {
        emit(SleepScoreError("Authorization not granted"));
      }
    } catch (e) {
      emit(SleepScoreError(e.toString()));
    }
  }

  List<HealthDataPoint> removeDuplicates(List<HealthDataPoint> dataPoints) {
    final uniqueDataPoints = <HealthDataPoint>[];

    for (var dataPoint in dataPoints) {
      bool isDuplicate = uniqueDataPoints.any((dp) =>
          dp.dateFrom == dataPoint.dateFrom &&
          dp.dateTo == dataPoint.dateTo &&
          dp.type == dataPoint.type);
      if (!isDuplicate) {
        uniqueDataPoints.add(dataPoint);
      }
    }

    return uniqueDataPoints;
  }

  List<HealthDataPoint> processHeartRateData(
      List<HealthDataPoint> heartRateData) {
    // Remove duplicates before processing
    heartRateData = removeDuplicates(heartRateData);

    List<HealthDataPoint> processedHeartRateData = [];

    for (var dataPoint in heartRateData) {
      // Split data point if it spans midnight
      List<HealthDataPoint> splitPoints = splitDataPointAtMidnight(dataPoint);
      processedHeartRateData.addAll(splitPoints);
    }

    return processedHeartRateData;
  }

  List<HealthDataPoint> splitDataPointAtMidnight(HealthDataPoint dataPoint) {
    DateTime dateFrom = dataPoint.dateFrom;
    DateTime dateTo = dataPoint.dateTo;

    // Check if the data point spans midnight
    if (dateFrom.day != dateTo.day) {
      DateTime endOfDay = DateTime(
          dateFrom.year, dateFrom.month, dateFrom.day, 23, 59, 59, 999);
      DateTime startOfNextDay =
          DateTime(dateTo.year, dateTo.month, dateTo.day, 0, 0, 0, 0);

      // Split into two data points
      if (dateFrom.day != dateTo.day) {
        // Create two separate data points
        DateTime endOfDay = DateTime(
            dateFrom.year, dateFrom.month, dateFrom.day, 23, 59, 59, 999);
        DateTime startOfNextDay =
            DateTime(dateTo.year, dateTo.month, dateTo.day, 0, 0, 0, 0);

        // First data point ends at midnight
        HealthDataPoint firstPart = HealthDataPoint(
            dateFrom: dateFrom,
            dateTo: endOfDay,
            value: dataPoint.value,
            type: dataPoint.type,
            unit: dataPoint.unit,
            sourceId: dataPoint.sourceId,
            sourceName: dataPoint.sourceName,
            sourcePlatform: dataPoint.sourcePlatform,
            sourceDeviceId: dataPoint.sourceDeviceId);

        // Second data point starts at midnight
        HealthDataPoint secondPart = HealthDataPoint(
            dateFrom: startOfNextDay,
            dateTo: dateTo,
            value: dataPoint.value,
            type: dataPoint.type,
            unit: dataPoint.unit,
            sourceId: dataPoint.sourceId,
            sourceName: dataPoint.sourceName,
            sourcePlatform: dataPoint.sourcePlatform,
            sourceDeviceId: dataPoint.sourceDeviceId);

        return [firstPart, secondPart];
      }
    }

    // Return the original data point as a single-item list if it doesn't span midnight
    return [dataPoint];
  }

  List<SleepSession> processSleepData(List<HealthDataPoint> sleepData) {
    sleepData = removeDuplicates(sleepData);

    List<SleepSession> sessions = [];
    DateTime? sleepStart;
    DateTime? sleepEnd;
    Duration timeAsleep = Duration.zero;
    Duration timeInRem = Duration.zero;
    Duration timeAwake = Duration.zero;
    Duration breakDuration = Duration.zero;
    Duration maxAllowedBreak =
        Duration(hours: 1); // Threshold to merge sessions

    sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    DateTime? lastAsleepEndTime;

    for (var dataPoint in sleepData) {
      if (dataPoint.type == HealthDataType.SLEEP_IN_BED ||
          dataPoint.type == HealthDataType.SLEEP_SESSION) {
        if (sleepStart == null) {
          sleepStart = dataPoint.dateFrom;
        } else {
          // Calculate the duration since the last session ended
          final durationSinceLastSession =
              dataPoint.dateFrom.difference(sleepEnd!);

          // If the break is longer than maxAllowedBreak, finalize the current session
          if (durationSinceLastSession > maxAllowedBreak) {
            // Finalize the current session
            sessions.add(SleepSession(
              from: sleepStart,
              to: sleepEnd,
              asleepDuration: timeAsleep,
              remDuration: timeInRem,
              awakeDuration: timeAwake,
              inBedDuration: sleepEnd
                  .difference(sleepStart), // Calculate based on start and end
            ));

            // Reset for a new session
            sleepStart = dataPoint.dateFrom;
            timeAsleep = Duration.zero;
            timeInRem = Duration.zero;
            timeAwake = Duration.zero;
            breakDuration = Duration.zero;
          }
        }

        sleepEnd = dataPoint.dateTo;
      } else if (dataPoint.type == HealthDataType.SLEEP_ASLEEP ||
          dataPoint.type == HealthDataType.SLEEP_ASLEEP_CORE) {
        if (lastAsleepEndTime == null ||
            dataPoint.dateFrom.isAfter(lastAsleepEndTime)) {
          // No overlap or a new segment, add duration
          timeAsleep += dataPoint.dateTo.difference(dataPoint.dateFrom);
          lastAsleepEndTime = dataPoint.dateTo;
        } else if (dataPoint.dateTo.isAfter(lastAsleepEndTime)) {
          // Handle overlapping period, only add the non-overlapping part
          timeAsleep += dataPoint.dateTo.difference(lastAsleepEndTime);
          lastAsleepEndTime = dataPoint.dateTo;
        }
      } else if (dataPoint.type == HealthDataType.SLEEP_REM) {
        timeInRem += dataPoint.dateTo.difference(dataPoint.dateFrom);
      } else if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
        timeAwake += dataPoint.dateTo.difference(dataPoint.dateFrom);
      }
    }

    // Add the last session if it exists
    if (sleepStart != null && sleepEnd != null) {
      sessions.add(SleepSession(
        from: sleepStart,
        to: sleepEnd,
        asleepDuration: timeAsleep,
        remDuration: timeInRem,
        awakeDuration: timeAwake,
        inBedDuration:
            sleepEnd.difference(sleepStart), // Calculate based on start and end
      ));
    }

    return sessions;
  }

  List<DailySleepData> calculateDailySleepData(
      List<SleepSession> sessions, List<HealthDataPoint> heartRateData) {
    List<DailySleepData> data = [];

    for (var session in sessions) {
      double sleepEfficiency = calculateSleepEfficiency(
          session.asleepDuration, session.inBedDuration);
      double durationScore = calculateDurationScore(session.inBedDuration);
      // Assign a default REM score if REM duration is 0
      double remScore = session.remDuration.inMinutes > 0
          ? calculateRemScore(session.remDuration, session.asleepDuration)
          : 75.0; // Default score for REM if REM data is not available
      double interruptionScore =
          calculateInterruptionScore(session.awakeDuration);
      double averageHeartRate =
          calculateAverageHeartRate(heartRateData, session.from, session.to);
      double heartRateScore = calculateHeartRateScore(averageHeartRate);
      double sleepScore = calculateSleepScore(sleepEfficiency, durationScore,
          remScore, interruptionScore, heartRateScore);

      String grade = gradeSleepScore(sleepScore);

      data.add(DailySleepData(
          date: session.from,
          sleepScore: sleepScore,
          grade: grade,
          timeInBed: session.inBedDuration,
          asleepDuration: session.asleepDuration,
          remDuration: session.remDuration,
          awakeDuration: session.awakeDuration));
    }

    return data;
  }

  double calculateSleepEfficiency(
      Duration asleepDuration, Duration inBedDuration) {
    if (inBedDuration.inMinutes == 0) return 0;
    return (asleepDuration.inMinutes / inBedDuration.inMinutes) * 100;
  }

  double calculateDurationScore(Duration sleepDuration) {
    double sleepHours = sleepDuration.inSeconds / 3600.0;

    if (sleepHours >= 7) {
      return 100; // Full score if sleep is 7 hours or more
    } else if (sleepHours >= 5) {
      // Linearly interpolate the score between 80 and 100 for sleep between 5 and 7 hours
      return 80 + ((sleepHours - 5) / 2) * 20;
    } else {
      // Linearly interpolate the score between 50 and 80 for sleep less than 5 hours
      return 50 + (sleepHours / 5) * 30;
    }
  }

  double calculateRemScore(Duration remDuration, Duration asleepDuration) {
    double remMinutes = remDuration.inMinutes.toDouble();
    double totalSleepMinutes = asleepDuration.inMinutes.toDouble();

    if (totalSleepMinutes == 0) return 0;

    // Assume ideal REM duration is about 20-25% of total sleep time
    double remPercentage = (remMinutes / totalSleepMinutes) * 100;

    if (remPercentage >= 20 && remPercentage <= 25) {
      return 100; // Perfect REM sleep score
    } else if (remPercentage >= 15 && remPercentage < 20) {
      return 80 + ((remPercentage - 15) / 5) * 20; // Gradually decrease score
    } else if (remPercentage > 25 && remPercentage <= 30) {
      return 80 + ((30 - remPercentage) / 5) * 20; // Gradually decrease score
    } else {
      return 50; // Poor REM sleep score
    }
  }

  double calculateInterruptionScore(Duration awakeDuration) {
    double awakeMinutes = awakeDuration.inMinutes.toDouble();
    if (awakeMinutes == 0) {
      return 100; // No interruptions, perfect score
    }
    //The penalty for interruptions is calculated by dividing the total minutes awake by 5. This means that for every 5 minutes of being awake, the score is reduced by 1 point.
    double interruptionPenalty = awakeMinutes / 5.0;
    return max(
        100 - interruptionPenalty, 50); // Ensure the score doesn't go below 50
  }

  double calculateAverageHeartRate(List<HealthDataPoint> heartRateData,
      DateTime sleepStart, DateTime sleepEnd) {
    List<double> heartRates = [];

    for (var dataPoint in heartRateData) {
      if (dataPoint.dateFrom.isAfter(sleepStart) &&
          dataPoint.dateFrom.isBefore(sleepEnd)) {
        heartRates.add(
            (dataPoint.value as NumericHealthValue).numericValue.toDouble());
      }
    }

    if (heartRates.isEmpty) {
      return 0;
    }

    double averageHeartRate =
        heartRates.reduce((a, b) => a + b) / heartRates.length;
    return averageHeartRate;
  }

  double calculateHeartRateScore(double averageHeartRate) {
    if (averageHeartRate == 0) {
      return 75;
    }
    if (averageHeartRate <= 60) {
      return 100;
    } else if (averageHeartRate <= 70) {
      return 80 + ((70 - averageHeartRate) / 10) * 20;
    } else {
      return 50 + ((80 - averageHeartRate) / 20) * 30;
    }
  }

  List<SleepSessionScore> calculateSessionScores(
      List<SleepSession> sessions, List<HealthDataPoint> heartRateData) {
    List<SleepSessionScore> sessionScores = [];

    for (var session in sessions) {
      double sleepEfficiency = calculateSleepEfficiency(
          session.asleepDuration, session.inBedDuration);
      double durationScore = calculateDurationScore(session.inBedDuration);
      double remScore =
          calculateRemScore(session.remDuration, session.asleepDuration);
      double interruptionScore =
          calculateInterruptionScore(session.awakeDuration);
      double averageHeartRate =
          calculateAverageHeartRate(heartRateData, session.from, session.to);
      double heartRateScore = calculateHeartRateScore(averageHeartRate);
      double sleepScore = calculateSleepScore(sleepEfficiency, durationScore,
          remScore, interruptionScore, heartRateScore);

      String grade = gradeSleepScore(sleepScore);

      sessionScores.add(SleepSessionScore(
        session: session,
        sleepScore: sleepScore,
        grade: grade,
      ));
    }

    return sessionScores;
  }

  double calculateOverallScore(List<SleepSessionScore> sessionScores) {
    if (sessionScores.isEmpty) return 0;

    double totalScore =
        sessionScores.fold(0, (sum, score) => sum + score.sleepScore);
    return totalScore / sessionScores.length;
  }

  double calculateSleepScore(double sleepEfficiency, double durationScore,
      double remScore, double interruptionScore, double heartRateScore) {
    return (sleepEfficiency * 0.2) +
        (durationScore * 0.25) +
        (remScore * 0.2) +
        (interruptionScore * 0.15) +
        (heartRateScore * 0.2);
  }

  String gradeSleepScore(double sleepScore) {
    if (sleepScore >= 90) {
      return "Excellent";
    } else if (sleepScore >= 75) {
      return "Good";
    } else if (sleepScore >= 60) {
      return "Fair";
    } else {
      return "Poor";
    }
  }


}

class SleepScoreState extends Equatable {
  @override
  List<Object> get props => [];
}

class SleepScoreInitial extends SleepScoreState {}

class SleepScoreLoading extends SleepScoreState {}

class SleepScoreLoaded extends SleepScoreState {
  final List<DailySleepData> dailySleepData;

  SleepScoreLoaded(this.dailySleepData);

  @override
  List<Object> get props => [dailySleepData];
}

class SleepScoreError extends SleepScoreState {
  final String message;

  SleepScoreError(this.message);

  @override
  List<Object> get props => [message];
}

class SleepSessionScoreLoaded extends SleepScoreState {
  final List<SleepSessionScore> sessionScores;

  SleepSessionScoreLoaded(this.sessionScores);

  @override
  List<Object> get props => [sessionScores];
}

class SleepSession {
  DateTime from;
  DateTime to;
  Duration asleepDuration;
  Duration remDuration;
  Duration awakeDuration;
  Duration inBedDuration;

  SleepSession({
    required this.from,
    required this.to,
    required this.asleepDuration,
    required this.remDuration,
    required this.awakeDuration,
    required this.inBedDuration,
  });

  Duration get duration => to.difference(from);
}
