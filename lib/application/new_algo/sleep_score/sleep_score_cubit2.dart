import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

import 'package:vestasleep/application/new_algo/model/daily_sleep_data.dart';
import 'package:vestasleep/application/new_algo/model/sleep_session.dart';

class SleepScoreCubit2 extends Cubit<SleepScoreState> {
  final Health healthFactory;

  SleepScoreCubit2(this.healthFactory) : super(SleepScoreInitial());

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
            HealthDataType.SLEEP_REM
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

        List<SleepSession> sessions = processSleepData(sleepData);
        List<DailySleepData> dailySleepData =
            calculateDailySleepData(sessions, heartRateData);

        emit(SleepScoreLoaded(dailySleepData));
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

  /*List<SleepSession> processSleepData(List<HealthDataPoint> sleepData) {
    // Step 1: Remove duplicates based on the unique combination of dateFrom, dateTo, and type
    sleepData = removeDuplicates(sleepData);

    List<SleepSession> sessions = [];
    DateTime? sleepStart;
    DateTime? sleepEnd;
    Duration totalAwakeDuration = Duration.zero;

    // Sort all data points by start time to ensure chronological order
    sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    for (var dataPoint in sleepData) {
      if (dataPoint.type == HealthDataType.SLEEP_IN_BED) {
        if (sleepStart == null) {
          // Start a new sleep session
          sleepStart = dataPoint.dateFrom;
          sleepEnd = dataPoint.dateTo;
        } else {
          // Extend the current sleep session if the new one overlaps or is contiguous
          if (dataPoint.dateFrom.isBefore(sleepEnd!) ||
              dataPoint.dateFrom.isAtSameMomentAs(sleepEnd)) {
            if (dataPoint.dateTo.isAfter(sleepEnd)) {
              sleepEnd = dataPoint.dateTo;
            }
          } else {
            // Finalize the current session and start a new one
            Duration asleepDuration =
                sleepEnd!.difference(sleepStart) - totalAwakeDuration;
            sessions.add(SleepSession(
              from: sleepStart,
              to: sleepEnd,
              asleepDuration: asleepDuration,
              awakeDuration: totalAwakeDuration,
            ));
            sleepStart = dataPoint.dateFrom;
            sleepEnd = dataPoint.dateTo;
            totalAwakeDuration = Duration.zero;
          }
        }
      } else if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
        // Accumulate awake duration only if it falls within the current sleep session
        if (sleepStart != null &&
            sleepEnd != null &&
            dataPoint.dateFrom.isBefore(sleepEnd)) {
          totalAwakeDuration += dataPoint.dateTo.difference(dataPoint.dateFrom);
        }
      }
    }

    // Finalize the last sleep session if it exists
    if (sleepStart != null && sleepEnd != null) {
      Duration asleepDuration =
          sleepEnd.difference(sleepStart) - totalAwakeDuration;
      sessions.add(SleepSession(
        from: sleepStart,
        to: sleepEnd,
        asleepDuration: asleepDuration,
        awakeDuration: totalAwakeDuration,
      ));
    }

    return sessions;
  }*/

  List<SleepSession> processSleepData(List<HealthDataPoint> sleepData) {
    // Remove duplicates before processing
    sleepData = removeDuplicates(sleepData);

    Map<DateTime, List<HealthDataPoint>> groupedSleepData = {};

    // Group sleep data by date (ignoring time)
    for (var dataPoint in sleepData) {
      DateTime date = DateTime(dataPoint.dateFrom.year,
          dataPoint.dateFrom.month, dataPoint.dateFrom.day);
      if (!groupedSleepData.containsKey(date)) {
        groupedSleepData[date] = [];
      }
      groupedSleepData[date]!.add(dataPoint);
    }

    List<SleepSession> sessions = [];
    groupedSleepData.forEach((date, dataPoints) {
      DateTime? sleepStart;
      DateTime? sleepEnd;
      Duration timeAsleep = Duration.zero;
      Duration timeAwake = Duration.zero;

      // Sort data points to ensure correct chronological processing
      dataPoints.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.SLEEP_IN_BED ||
            dataPoint.type == HealthDataType.SLEEP_SESSION) {
          // Set the sleep start time if it's the first in-bed data point
          if (sleepStart == null) {
            sleepStart = dataPoint.dateFrom;
          }
          // Update the sleep end time to the latest in-bed data point
          sleepEnd = dataPoint.dateTo;
         // timeAsleep += dataPoint.dateTo.difference(dataPoint.dateFrom);
        } else if (dataPoint.type == HealthDataType.SLEEP_ASLEEP) {
          // Accumulate the duration spent asleep
          timeAsleep += dataPoint.dateTo.difference(dataPoint.dateFrom);
        } else if (dataPoint.type == HealthDataType.SLEEP_REM) {
          // Accumulate the duration spent asleep
          timeAsleep += dataPoint.dateTo.difference(dataPoint.dateFrom);
        } else if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
          // Accumulate the duration spent awake
          timeAwake += dataPoint.dateTo.difference(dataPoint.dateFrom);
        }
      }

      // If no SLEEP_ASLEEP data is available, assume all time in bed was spent asleep
      if (timeAsleep == Duration.zero &&
          sleepStart != null &&
          sleepEnd != null) {
        //timeAsleep = sleepEnd.difference(sleepStart);
      }

      // Validate that we have a valid session
      if (sleepStart != null && sleepEnd != null) {
        sessions.add(SleepSession(
          from: sleepStart,
          to: sleepEnd,
          asleepDuration: timeAsleep,
          awakeDuration: timeAwake,
        ));
      }
    });
/*    // Process each group of data points by date
     groupedSleepData.forEach((date, dataPoints) {
      DateTime? sleepStart;
      DateTime? sleepEnd;
      Duration totalAsleepDuration = Duration.zero;
      Duration totalAwakeDuration = Duration.zero;

      // Sort data points by start time to ensure chronological order
      dataPoints.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.SLEEP_IN_BED) {
          if (sleepStart == null) {
            sleepStart = dataPoint.dateFrom;
            sleepEnd = dataPoint.dateTo;
          } else {
            if (dataPoint.dateFrom.isBefore(sleepEnd!) ||
                dataPoint.dateFrom.isAtSameMomentAs(sleepEnd)) {
              if (dataPoint.dateTo.isAfter(sleepEnd)) {
                sleepEnd = dataPoint.dateTo;
              }
            } else {
              // Log and add the current session
              print(
                  "Session - Start: $sleepStart, End: $sleepEnd, Duration: ${sleepEnd.difference(sleepStart)}");

              sessions.add(SleepSession(
                from: sleepStart,
                to: sleepEnd!,
                asleepDuration: totalAsleepDuration,
                awakeDuration: totalAwakeDuration,
              ));
              sleepStart = dataPoint.dateFrom;
              sleepEnd = dataPoint.dateTo;
              totalAsleepDuration = Duration.zero;
              totalAwakeDuration = Duration.zero;
            }
          }
        } else if (dataPoint.type == HealthDataType.SLEEP_ASLEEP) {
          totalAsleepDuration +=
              dataPoint.dateTo.difference(dataPoint.dateFrom);
        } else if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
          totalAwakeDuration += dataPoint.dateTo.difference(dataPoint.dateFrom);
        }
      }

      // Step 4: If no SLEEP_ASLEEP data, assume full in-bed duration as asleep
      if (totalAsleepDuration == Duration.zero &&
          sleepStart != null &&
          sleepEnd != null) {
        totalAsleepDuration = sleepEnd.difference(sleepStart);
      }

      // Log and add the final session for the day
      if (sleepStart != null && sleepEnd != null) {
        print(
            "Final Session - Start: $sleepStart, End: $sleepEnd, Total Sleep Duration: $totalAsleepDuration");

        sessions.add(SleepSession(
          from: sleepStart,
          to: sleepEnd,
          asleepDuration: totalAsleepDuration,
          awakeDuration: totalAwakeDuration,
        ));
      }
    });*/

    /* groupedSleepData.forEach((date, dataPoints) {
      DateTime? sleepStart;
      DateTime? sleepEnd;
      Duration totalAwakeDuration = Duration.zero;

      // Sort data points by start time to ensure chronological order
      dataPoints.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

      for (var dataPoint in dataPoints) {
        if (dataPoint.type == HealthDataType.SLEEP_IN_BED) {
          if (sleepStart == null) {
            sleepStart = dataPoint.dateFrom;
            sleepEnd = dataPoint.dateTo;
          } else {
            if (dataPoint.dateFrom.isBefore(sleepEnd!) || dataPoint.dateFrom.isAtSameMomentAs(sleepEnd)) {
              if (dataPoint.dateTo.isAfter(sleepEnd)) {
                sleepEnd = dataPoint.dateTo;
              }
            } else {
              // Add current session
              Duration asleepDuration = sleepEnd!.difference(sleepStart) - totalAwakeDuration;
              print("Session - Start: $sleepStart, End: $sleepEnd, Asleep Duration: $asleepDuration");

              sessions.add(SleepSession(
                from: sleepStart,
                to: sleepEnd,
                asleepDuration: asleepDuration,
                awakeDuration: totalAwakeDuration,
              ));
              sleepStart = dataPoint.dateFrom;
              sleepEnd = dataPoint.dateTo;
              totalAwakeDuration = Duration.zero;
            }
          }
        } else if (dataPoint.type == HealthDataType.SLEEP_AWAKE) {
          totalAwakeDuration += dataPoint.dateTo.difference(dataPoint.dateFrom);
        }
      }

      // Final session for the day
      if (sleepStart != null && sleepEnd != null) {
        Duration asleepDuration = sleepEnd.difference(sleepStart) - totalAwakeDuration;
        print("Final Session - Start: $sleepStart, End: $sleepEnd, Asleep Duration: $asleepDuration");

        sessions.add(SleepSession(
          from: sleepStart,
          to: sleepEnd,
          asleepDuration: asleepDuration,
          awakeDuration: totalAwakeDuration,
        ));
      }
    });*/
    return sessions;
  }

  List<DailySleepData> calculateDailySleepData(
      List<SleepSession> sessions, List<HealthDataPoint> heartRateData) {
    List<DailySleepData> data = [];

    for (var session in sessions) {
      double sleepEfficiency =
          calculateSleepEfficiency(session.asleepDuration, session.duration);
      double durationScore = calculateDurationScore(session.asleepDuration);
      double interruptionScore =
          calculateInterruptionScore(session.awakeDuration);
      double averageHeartRate =
          calculateAverageHeartRate(heartRateData, session.from, session.to);
      double heartRateScore = calculateHeartRateScore(averageHeartRate);
      double sleepScore = calculateSleepScore(
          sleepEfficiency, durationScore, interruptionScore, heartRateScore);

      String grade = gradeSleepScore(sleepScore);

      data.add(DailySleepData(
        date: session.from,
        sleepScore: sleepScore,
        grade: grade,
        sleepDuration: session.asleepDuration,
      ));
    }

    return data;
  }

  double calculateSleepEfficiency(
      Duration asleepDuration, Duration inBedDuration) {
    if (inBedDuration.inMinutes == 0) return 0;
    return (asleepDuration.inMinutes / inBedDuration.inMinutes) * 100;
  }

  double calculateInterruptionScore(Duration awakeDuration) {
    double awakeMinutes = awakeDuration.inMinutes.toDouble();
    if (awakeMinutes == 0) {
      return 100; // No interruptions, perfect score
    }
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

    double averageHeartRate = 0;
    if (heartRates.length > 0) {
      heartRates.reduce((a, b) => a + b) / heartRates.length;
    }
    return averageHeartRate;
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

  double calculateHeartRateScore(double averageHeartRate) {
    if (averageHeartRate == 0) {
      return 0;
    }
    if (averageHeartRate <= 60) {
      return 100;
    } else if (averageHeartRate <= 70) {
      return 80 + ((70 - averageHeartRate) / 10) * 20;
    } else {
      return 50 + ((80 - averageHeartRate) / 20) * 30;
    }
  }

  double calculateSleepScore(double sleepEfficiency, double durationScore,
      double interruptionScore, double heartRateScore) {
    return (sleepEfficiency * 0.4) +
        (durationScore * 0.3) +
        (interruptionScore * 0.2) +
        (heartRateScore * 0.1);
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

/*class SleepSession {
  DateTime from;
  DateTime to;
  Duration asleepDuration;
  Duration awakeDuration;

  SleepSession({
    required this.from,
    required this.to,
    required this.asleepDuration,
    required this.awakeDuration,
  });

  Duration get duration => to.difference(from);
}*/

class DailySleepData {
  DateTime date;
  double sleepScore;
  String grade;
  Duration sleepDuration;

  DailySleepData({
    required this.date,
    required this.sleepScore,
    required this.grade,
    required this.sleepDuration,
  });
}

