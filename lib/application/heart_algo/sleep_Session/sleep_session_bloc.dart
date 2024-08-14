import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:equatable/equatable.dart';

import '../model/hear_rate.dart';
import '../model/sleep_session_data.dart';

class SleepSessionCubit extends Cubit<SleepSessionState> {
  final Health healthFactory;

  SleepSessionCubit(this.healthFactory) : super(SleepSessionInitial());

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

        // Process the data and emit the result
        List<
            SleepSessionData> sleepSessions = _processSleepDataAndCalculateHeartRate(
          sleepData,
          heartRates,
        );

        emit(SleepSessionLoaded(sleepSessions: sleepSessions));
      }
    } catch (e) {
      emit(SleepSessionError(message: e.toString()));
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
  List<SleepSessionData> _processSleepDataAndCalculateHeartRate(
      List<HealthDataPoint> sleepData,
      List<HeartRate> heartRateData,
      ) {
    sleepData = removeDuplicates(sleepData);

    List<SleepSessionData> sessions = [];
    DateTime? sleepStart;
    DateTime? sleepEnd;
    Duration timeAsleep = Duration.zero;
    Duration timeInRem = Duration.zero;
    Duration timeAwake = Duration.zero;
    Duration breakDuration = Duration.zero;
    Duration maxAllowedBreak = Duration(hours: 1); // Threshold to merge sessions

    sleepData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

    DateTime? lastAsleepEndTime;

    for (var dataPoint in sleepData) {
      if (dataPoint.type == HealthDataType.SLEEP_IN_BED || dataPoint.type == HealthDataType.SLEEP_SESSION) {
        if (sleepStart == null) {
          sleepStart = dataPoint.dateFrom;
        } else {
          final durationSinceLastSession = dataPoint.dateFrom.difference(sleepEnd!);

          if (durationSinceLastSession > maxAllowedBreak) {
            timeAwake = sleepEnd!.difference(sleepStart!) - timeAsleep - timeInRem;

            // Calculate average heart rate for this session
            List<double> sessionHeartRates = heartRateData
                .where((hr) => hr.timestamp.isAfter(sleepStart!) && hr.timestamp.isBefore(sleepEnd!))
                .map((hr) => hr.heartRate)
                .toList();
            double averageHeartRate = sessionHeartRates.isNotEmpty
                ? sessionHeartRates.reduce((a, b) => a + b) / sessionHeartRates.length
                : 0.0;

            sessions.add(SleepSessionData(
              from: sleepStart,
              to: sleepEnd,
              asleepDuration: timeAsleep,
              remDuration: timeInRem,
              awakeDuration: timeAwake,
              inBedDuration: sleepEnd.difference(sleepStart),
              averageHeartRate: averageHeartRate,
            ));

            sleepStart = dataPoint.dateFrom;
            timeAsleep = Duration.zero;
            timeInRem = Duration.zero;
            timeAwake = Duration.zero;
            breakDuration = Duration.zero;
          }
        }
        sleepEnd = dataPoint.dateTo;
      } else if (dataPoint.type == HealthDataType.SLEEP_ASLEEP || dataPoint.type == HealthDataType.SLEEP_ASLEEP_CORE) {
        if (lastAsleepEndTime == null || dataPoint.dateFrom.isAfter(lastAsleepEndTime)) {
          timeAsleep += dataPoint.dateTo.difference(dataPoint.dateFrom);
          lastAsleepEndTime = dataPoint.dateTo;
        } else if (dataPoint.dateTo.isAfter(lastAsleepEndTime)) {
          timeAsleep += dataPoint.dateTo.difference(lastAsleepEndTime);
          lastAsleepEndTime = dataPoint.dateTo;
        }
      } else if (dataPoint.type == HealthDataType.SLEEP_REM) {
        timeInRem += dataPoint.dateTo.difference(dataPoint.dateFrom);
      }
    }

    if (sleepStart != null && sleepEnd != null) {
      timeAwake = sleepEnd.difference(sleepStart) - timeAsleep - timeInRem;

      // Calculate average heart rate for the last session
      List<double> sessionHeartRates = heartRateData
          .where((hr) => hr.timestamp.isAfter(sleepStart!) && hr.timestamp.isBefore(sleepEnd!))
          .map((hr) => hr.heartRate)
          .toList();
      double averageHeartRate = sessionHeartRates.isNotEmpty
          ? sessionHeartRates.reduce((a, b) => a + b) / sessionHeartRates.length
          : 0.0;

      sessions.add(SleepSessionData(
        from: sleepStart,
        to: sleepEnd,
        asleepDuration: timeAsleep,
        remDuration: timeInRem,
        awakeDuration: timeAwake,
        inBedDuration: sleepEnd.difference(sleepStart),
        averageHeartRate: averageHeartRate,
      ));
    }

    return sessions;
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
