import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestasleep/application/session_heart_rate/sleep_session_data.dart';

import '../session_heart_rate/model/heart_rate.dart';
import 'model/sleep_break.dart';

class SleepSessionNewCubit extends Cubit<SleepSessionState> {
  final Health healthFactory;

  SleepSessionNewCubit(this.healthFactory) : super(SleepSessionInitial());

  Future<void> loadSleepSessions() async {
    emit(SleepSessionLoading());

    try {
      // Request permissions to access sleep and heart rate data
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
            .subtract(Duration(days: 3));
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

        // Fetch heart rate data
        List<HealthDataPoint> heartRateData = await healthFactory
            .getHealthDataFromTypes(
                startTime: startDate,
                endTime: endDate,
                types: [HealthDataType.HEART_RATE]);

        // Convert heart rate data to the HeartRate model
        List<HeartRate> heartRates = heartRateData.map((point) {
          return HeartRate(
            dateFrom: point.dateFrom,
            dateTo: point.dateTo,
            bpm: (point.value as NumericHealthValue).numericValue.toDouble(),
          );
        }).toList();

        // Filter out heart rates that are 0
        heartRates = heartRates.where((hr) => hr.bpm > 0).toList();

        // Process the data and emit the result
        List<SleepSessionData> sleepSessions =
            _createSleepSessionsBasedOnHeartRates(sleepData, heartRates);

        emit(SleepSessionLoaded(sleepSessions: sleepSessions));
      }
    } catch (e) {
      emit(SleepSessionError(message: e.toString()));
    }
  }

  List<SleepSessionData> _createSleepSessionsBasedOnHeartRates(
      List<HealthDataPoint> sleepData, List<HeartRate> heartRateData) {
    List<SleepSessionData> sessions = [];
    DateTime? sessionStart;
    DateTime? sessionEnd;
    Duration timeAsleep = Duration.zero;
    Duration timeInRem = Duration.zero;
    Duration timeAwake = Duration.zero;
    const Duration maxAllowedBreak =
        Duration(minutes: 30); // Threshold duration
    List<SleepBreak> breaks = [];

    // Calculate initial heart rate statistics during sleep
    var sleepHeartRates = _getHeartRatesDuringSleep(sleepData, heartRateData);

    double minSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a < b ? a : b)
        : 40;
    double maxSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a > b ? a : b)
        : 80;


    DateTime? lastOutOfRangeTime;

    for (var hr in heartRateData) {
      print(
          'Processing heart rate: ${hr.bpm} at ${hr.dateFrom} - ${hr.dateTo}');

      // Check if the heart rate lies within the sleep range
      if (hr.bpm >= minSleepHeartRate && hr.bpm <= maxSleepHeartRate) {
        if (sessionStart == null) {
          sessionStart = hr.dateFrom;
          print('Session started at $sessionStart');
        }
        sessionEnd = hr.dateTo; // Consider the end of the heart rate data point
        print('Session updated to end at $sessionEnd');

        // If there was a break within the threshold, save it
        if (lastOutOfRangeTime != null) {
          breaks.add(SleepBreak(start: lastOutOfRangeTime, end: hr.dateFrom));
          lastOutOfRangeTime = null; // Reset after adding the break
          print('Break added from $lastOutOfRangeTime to ${hr.dateFrom}');
        }
      } else {
        // Handle out-of-range heart rates with duration threshold
        if (sessionEnd != null) {
          if (hr.dateFrom.difference(sessionEnd) <= maxAllowedBreak) {
            // This is a valid break within the session
            lastOutOfRangeTime = sessionEnd;
            print('Break started at $sessionEnd');
          } else {
            // If out-of-range duration exceeds the threshold, finalize the session
            final sessionDuration = sessionEnd!.difference(sessionStart!);

            if (sessionDuration.inMinutes > 0) {
              print('Finalizing session from $sessionStart to $sessionEnd');
              _recalculateDurations(
                sleepData,
                sessionStart,
                sessionEnd,
                timeAsleep,
                timeInRem,
                timeAwake,
              );
              double avgHeartRate = _calculateAverageHeartRateForSession(
                  heartRateData, sessionStart, sessionEnd);
              sessions.add(SleepSessionData(
                from: sessionStart,
                to: sessionEnd,
                asleepDuration: timeAsleep,
                remDuration: timeInRem,
                awakeDuration: timeAwake,
                inBedDuration: sessionDuration,
                averageHeartRate: avgHeartRate,
                breaks: breaks, // Include the list of breaks
              ));
              print('Session added with duration: $sessionDuration');
            } else {
              print('Skipped session with zero duration.');
            }

            // Reset for the next potential session
            sessionStart = null;
            sessionEnd = null;
            timeAsleep = Duration.zero;
            timeInRem = Duration.zero;
            timeAwake = Duration.zero;
            breaks = [];
            lastOutOfRangeTime = null;
          }
        }
      }
    }

    // Add the last session if it exists and has a non-zero duration
    if (sessionStart != null && sessionEnd != null) {
      final sessionDuration = sessionEnd.difference(sessionStart);
      if (sessionDuration.inMinutes > 0) {
        print('Finalizing last session from $sessionStart to $sessionEnd');
        _recalculateDurations(
          sleepData,
          sessionStart,
          sessionEnd,
          timeAsleep,
          timeInRem,
          timeAwake,
        );
        double avgHeartRate = _calculateAverageHeartRateForSession(
            heartRateData, sessionStart, sessionEnd);
        sessions.add(SleepSessionData(
          from: sessionStart,
          to: sessionEnd,
          asleepDuration: timeAsleep,
          remDuration: timeInRem,
          awakeDuration: timeAwake,
          inBedDuration: sessionDuration,
          averageHeartRate: avgHeartRate,
          breaks: breaks, // Include the list of breaks
        ));
        print('Final session added with duration: $sessionDuration');
      } else {
        print('Skipped final session with zero duration.');
      }
    }

    print('Total sessions created: ${sessions.length}');
    return sessions;
  }

/*  List<SleepSessionData> _createSleepSessionsBasedOnHeartRates(
      List<HealthDataPoint> sleepData, List<HeartRate> heartRateData) {
    List<SleepSessionData> sessions = [];
    DateTime? sessionStart;
    DateTime? sessionEnd;
    Duration timeAsleep = Duration.zero;
    Duration timeInRem = Duration.zero;
    Duration timeAwake = Duration.zero;
    const Duration maxAllowedBreak =
        Duration(minutes: 30); // Threshold duration

    // Calculate initial heart rate statistics during sleep
    var sleepHeartRates = _getHeartRatesDuringSleep(sleepData, heartRateData);

    double minSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a < b ? a : b)
        : 40;
    double maxSleepHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a > b ? a : b)
        : 80;

    for (var hr in heartRateData) {
      // Check if the heart rate lies within the sleep range
      if (hr.heartRate >= minSleepHeartRate && hr.heartRate <= maxSleepHeartRate) {
        if (sessionStart == null) {
          sessionStart = hr.timestamp;
        }
        sessionEnd = hr.timestamp;
      } else {//90
        // If the current heart rate is out of range and the difference between
        // the current time and the last sessionEnd exceeds the threshold, finalize the session
        if (sessionEnd != null &&
            hr.timestamp.difference(sessionEnd) > maxAllowedBreak) {
          // Finalize the current session
          _recalculateDurations(
            sleepData,
            sessionStart!,
            sessionEnd,
            timeAsleep,
            timeInRem,
            timeAwake,
          );
          double avgHeartRate = _calculateAverageHeartRateForSession(
              heartRateData, sessionStart, sessionEnd);
          sessions.add(SleepSessionData(
            from: sessionStart,
            to: sessionEnd,
            asleepDuration: timeAsleep,
            remDuration: timeInRem,
            awakeDuration: timeAwake,
            inBedDuration: sessionEnd.difference(sessionStart),
            averageHeartRate: avgHeartRate,
          ));

          // Reset for the next potential session
          sessionStart = null;
          sessionEnd = null;
          timeAsleep = Duration.zero;
          timeInRem = Duration.zero;
          timeAwake = Duration.zero;
        }
      }
    }

    // Add the last session if it exists
    if (sessionStart != null && sessionEnd != null) {
      final sessionDuration = sessionEnd.difference(sessionStart);
      if (sessionDuration.inMinutes > 0) {
        _recalculateDurations(
          sleepData,
          sessionStart,
          sessionEnd,
          timeAsleep,
          timeInRem,
          timeAwake,
        );
        double avgHeartRate = _calculateAverageHeartRateForSession(
            heartRateData, sessionStart, sessionEnd);
        sessions.add(SleepSessionData(
          from: sessionStart,
          to: sessionEnd,
          asleepDuration: timeAsleep,
          remDuration: timeInRem,
          awakeDuration: timeAwake,
          inBedDuration: sessionEnd.difference(sessionStart),
          averageHeartRate: avgHeartRate,
        ));
      }
    }

    return sessions;
  }*/

  List<double> _getHeartRatesDuringSleep(
      List<HealthDataPoint> sleepData, List<HeartRate> heartRateData) {
    List<double> sleepHeartRates = [];

    for (var sleepPoint in sleepData) {
      if (sleepPoint.type == HealthDataType.SLEEP_ASLEEP ||
          sleepPoint.type == HealthDataType.SLEEP_ASLEEP_CORE ||
          sleepPoint.type == HealthDataType.SLEEP_IN_BED ||
          sleepPoint.type == HealthDataType.SLEEP_SESSION) {
        for (var hr in heartRateData) {
          // Include heart rates that overlap with the sleep period
          if (hr.dateFrom.isBefore(sleepPoint.dateTo) &&
              hr.dateTo.isAfter(sleepPoint.dateFrom)) {
            sleepHeartRates.add(hr.bpm);
          }
        }
      }
    }

    return sleepHeartRates;
  }

  void _recalculateDurations(
    List<HealthDataPoint> sleepData,
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
        // Adjust the effective start time to be sessionStart if dateFrom is before sessionStart
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
  }

  double _calculateAverageHeartRateForSession(List<HeartRate> heartRateData,
      DateTime sessionStart, DateTime sessionEnd) {
    final sessionHeartRates = heartRateData
        .where((hr) =>
            hr.dateFrom.isBefore(sessionEnd) && hr.dateTo.isAfter(sessionStart))
        .map((hr) => hr.bpm)
        .toList();

    return sessionHeartRates.isNotEmpty
        ? sessionHeartRates.reduce((a, b) => a + b) / sessionHeartRates.length
        : 0.0;
  }
}

abstract class SleepSessionState extends Equatable {
  const SleepSessionState();

  @override
  List<Object> get props => [];
}

class SleepSessionInitial extends SleepSessionState {}

class SleepSessionLoading extends SleepSessionState {}

class SleepSessionLoaded extends SleepSessionState {
  final List<SleepSessionData> sleepSessions;

  SleepSessionLoaded({required this.sleepSessions});

  @override
  List<Object> get props => [sleepSessions];
}

class SleepSessionError extends SleepSessionState {
  final String message;

  SleepSessionError({required this.message});

  @override
  List<Object> get props => [message];
}
