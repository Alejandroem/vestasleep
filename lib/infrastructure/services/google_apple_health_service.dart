import 'dart:async';
import 'dart:developer';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_data_point.dart';
import '../../domain/models/user_state.dart';
import '../../domain/services/health_service.dart';

class GoogleAppleHealthService implements HealthService {
  Timer? _heartRateTimer;
  StreamController<HeartRate>? heartRateStreamController;

  @override
  Future<bool> requestPermissions() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    await Permission.activityRecognition.request();

    final types = [
      HealthDataType.WEIGHT,
      HealthDataType.STEPS,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.WORKOUT,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      // Uncomment these lines on iOS - only available on iOS
      //   // HealthDataType.AUDIOGRAM
    ];

    final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await health.requestAuthorization(types);
      } catch (error) {
        log("Exception in authorize: $error");
      }
    }

    return authorized;
  }

  @override
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }

  @override
  Future<Stream<HeartRate>> getHeartRateStream(Duration delta) async {
    HealthFactory health = HealthFactory();

    heartRateStreamController ??= StreamController<HeartRate>();

    if (_heartRateTimer != null) {
      _heartRateTimer!.cancel();
    }

    _heartRateTimer = Timer.periodic(delta, (timer) async {
      try {
        DateTime startTime = DateTime.now().subtract(delta);
        DateTime endTime = DateTime.now();
        log("Getting heart rate data from health kit from $startTime to $endTime");
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startTime,
          endTime,
          [
            HealthDataType.HEART_RATE,
          ],
        );
        log("Health data: $healthData");
        if (healthData.isNotEmpty) {
          log("Health data: $healthData");
          int averageHeartRate = healthData
                  .map((e) => e.value as int)
                  .reduce((value, element) => value + element) ~/
              healthData.length;
          heartRateStreamController!.add(
            HeartRate(
              averageHeartRate,
              healthData.first.dateFrom,
              healthData.last.dateTo,
            ),
          );
        }
      } catch (error) {
        log("Exception in getHeartRateStream: $error");
      }
    });

    return heartRateStreamController!.stream;
  }

  @override
  Future<Stream<HeartRate>> getRestingHeartRateStream() {
    // TODO: implement getRestingHeartRateStream
    throw UnimplementedError();
  }

  @override
  Future<HeartRate> getCurrentRestingHeartRate() {
    // TODO: implement getCurrentRestingHeartRate
    throw UnimplementedError();
  }

  @override
  Future<UserState> getUserState() async {
    //use google healthkit to read the state of the user
    //   normal,
    // sleeping,
    // excercising,
    return UserState.normal;
  }

  @override
  Future<List<SleepDataPoint>> getSleepData(
      DateTime start, DateTime end) async {
    //GET Awake REM light and deep sleep
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_REM,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_DEEP,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await health.requestAuthorization(types);
      } catch (error) {
        log("Exception in authorize: $error");
      }
    }

    if (authorized) {
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        start,
        end,
        types,
      );

      List<SleepDataPoint> sleepDataPoints = healthData.map((dataPoint) {
        SleepStage sleepType;
        switch (dataPoint.type) {
          case HealthDataType.SLEEP_AWAKE:
            sleepType = SleepStage.awake;
            break;
          case HealthDataType.SLEEP_REM:
            sleepType = SleepStage.rem;
            break;
          case HealthDataType.SLEEP_LIGHT:
            sleepType = SleepStage.light;
            break;
          case HealthDataType.SLEEP_DEEP:
            sleepType = SleepStage.deep;
            break;
          default:
            sleepType = SleepStage.awake;
            log("Unknown sleep type: ${dataPoint.type}");
            break;
        }

        return SleepDataPoint(
          from: dataPoint.dateFrom,
          to: dataPoint.dateTo,
          stage: sleepType,
        );
      }).toList();

      return sleepDataPoints;
    } else {
      return [];
    }
  }
}
