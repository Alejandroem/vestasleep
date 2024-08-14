import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestasleep/application/session_heart_rate/sleep_session_data.dart';

import '../heart_algo/model/hear_rate.dart';

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
            .subtract(Duration(days: 2));
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
            timestamp: point.dateFrom,
            heartRate: (point.value as NumericHealthValue).numericValue
                .toDouble(),
          );
        }).toList();

        // Filter out heart rates that are 0
        heartRates = heartRates.where((hr) => hr.heartRate > 0).toList();

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
    const Duration maxAllowedOutOfRangeDuration = Duration(minutes: 10); // Threshold duration

    // Calculate initial heart rate statistics during sleep
    var sleepHeartRates = _getHeartRatesDuringSleep(sleepData, heartRateData);

    double minHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a < b ? a : b)
        : 40;
    double maxHeartRate = sleepHeartRates.isNotEmpty
        ? sleepHeartRates.reduce((a, b) => a > b ? a : b)
        : 80;


    for (var hr in heartRateData) {
      // Check if the heart rate lies within the sleep range
      if (hr.heartRate >= minHeartRate && hr.heartRate <= maxHeartRate) {
        if (sessionStart == null) {
          sessionStart = hr.timestamp;
        }
        sessionEnd = hr.timestamp;
      } else {
        // If the current heart rate is out of range and the difference between
        // the current time and the last sessionEnd exceeds the threshold, finalize the session
        if (sessionEnd != null &&
            hr.timestamp.difference(sessionEnd) > maxAllowedOutOfRangeDuration) {
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

    return sessions;
  }


  List<double> _getHeartRatesDuringSleep(
      List<HealthDataPoint> sleepData, List<HeartRate> heartRateData) {
    List<double> sleepHeartRates = [];

    for (var sleepPoint in sleepData) {
      if (sleepPoint.type == HealthDataType.SLEEP_ASLEEP ||
          sleepPoint.type == HealthDataType.SLEEP_ASLEEP_CORE ||
          sleepPoint.type == HealthDataType.SLEEP_IN_BED || sleepPoint.type == HealthDataType.SLEEP_SESSION) {
        for (var hr in heartRateData) {
          // Include heart rates that are exactly at the boundaries as well
          if (!hr.timestamp.isBefore(sleepPoint.dateFrom) &&
              !hr.timestamp.isAfter(sleepPoint.dateTo)) {
            sleepHeartRates.add(hr.heartRate);
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
        DateTime effectiveStart =
        sleepPoint.dateFrom.isBefore(sessionStart) ? sessionStart : sleepPoint.dateFrom;
        DateTime effectiveEnd =
        sleepPoint.dateTo.isAfter(sessionEnd) ? sessionEnd : sleepPoint.dateTo;

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


  double _calculateAverageHeartRateForSession(
      List<HeartRate> heartRateData, DateTime sessionStart, DateTime sessionEnd) {
    final sessionHeartRates = heartRateData
        .where((hr) => hr.timestamp.isAfter(sessionStart) && hr.timestamp.isBefore(sessionEnd))
        .map((hr) => hr.heartRate)
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
