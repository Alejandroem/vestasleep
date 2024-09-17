import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:health/health.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vestasleep/mock/sleep_session_data.dart';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_data_point.dart';
import '../../domain/models/sleep_session.dart';
import '../../domain/models/user_state.dart';
import '../../domain/services/health_service.dart';
import '../../mock/heart_data.dart';

class GoogleAppleHealthService implements HealthService {
  final log = Logger('GoogleAppleHealthService');

  Timer? _heartRateTimer;
  StreamController<HeartRate>? heartRateStreamController;

  @override
  Future<bool> requestPermissions() async {
    // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
    var health = Health();
    Health().configure(useHealthConnectIfAvailable: true);
    await Permission.activityRecognition.request();

    final types = [
      HealthDataType.HEART_RATE,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_REM,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_DEEP,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions) ?? false;

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    //hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized = await health.requestAuthorization(types);
      } catch (error, stackTrace) {
        log.severe('Exception in authorize!', error, stackTrace);
      }
    } else {
      //authorized = await health.requestAuthorization(types);
      authorized = true;
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
    // HealthFactory health = HealthFactory();
    var health = Health();
    heartRateStreamController ??= StreamController<HeartRate>();

    if (_heartRateTimer != null) {
      _heartRateTimer!.cancel();
    }

    _heartRateTimer = Timer.periodic(delta, (timer) async {
      try {
        DateTime startTime = DateTime.now().subtract(delta);
        DateTime endTime = DateTime.now();
        log.info(
            "Getting heart rate data from health kit from $startTime to $endTime");
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          startTime: startTime,
          endTime: endTime,
          types: [
            HealthDataType.HEART_RATE,
          ],
        );
        log.info("Health data: $healthData");
        if (healthData.isNotEmpty) {
          log.info("Health data: $healthData");
          int averageHeartRate = healthData.map((e) {
                return (e.value as NumericHealthValue).numericValue.toInt();
              }).reduce((value, element) => value + element) ~/
              healthData.length;
          heartRateStreamController!.add(
            HeartRate(
              averageHeartRate,
              healthData.first.dateFrom,
              healthData.last.dateTo,
            ),
          );
        }
      } catch (error, stackTrace) {
        log.severe('"Exception in getHeartRateStream!', error, stackTrace);
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
    // HealthFactory health = HealthFactory();
    Health health = Health();
    List<HealthDataType> types = [];
/*
  HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_REM,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_DEEP,
 */
    if (Platform.isAndroid) {
      types = [
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_REM,
        HealthDataType.SLEEP_DEEP,
      ];
    } else {
      types = [
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_REM,
        HealthDataType.SLEEP_ASLEEP_CORE,
        HealthDataType.SLEEP_DEEP,
      ];
    }
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    log.info("Requesting permissions for $permissions");

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions) ?? false;

    log.info("Has permissions: $hasPermissions");

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    // hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        log.info("Requesting authorization for $types");
        authorized = await health.requestAuthorization(types);
      } catch (error, stackTrace) {
        log.severe('Exception in authorize!', error, stackTrace);
      }
    } else {
      authorized = true; // await health.requestAuthorization(types);
    }

    if (authorized) {
      log.info("Authorized to read health data");
      //log.info("Getting health data from $start to $end for $types");
      List<HealthDataPoint> healthData = [];
      try {
        healthData = await health.getHealthDataFromTypes(
          startTime: start,
          endTime: end,
          types: types,
        );
      } catch (e, s) {
        print(s);
      }
      log.info("Health data for sleep: $healthData");
      List<SleepDataPoint> sleepDataPoints = healthData.map((dataPoint) {
        log.info("MapingData: Data point: $dataPoint");
        SleepStage sleepType;
        switch (dataPoint.type) {
          case HealthDataType.SLEEP_AWAKE:
          case HealthDataType.SLEEP_OUT_OF_BED:
            sleepType = SleepStage.awake;
            break;
          case HealthDataType.SLEEP_ASLEEP:
          case HealthDataType.SLEEP_LIGHT:
            sleepType = SleepStage.asleepCore;
            break;
          case HealthDataType.SLEEP_REM:
            sleepType = SleepStage.rem;
            break;
          case HealthDataType.SLEEP_DEEP:
            sleepType = SleepStage.deep;
            break;
          default:
            sleepType = SleepStage.awake;
            log.info("Unknown sleep type: ${dataPoint.type}");
            break;
        }

        return SleepDataPoint(
          from: dataPoint.dateFrom,
          to: dataPoint.dateTo,
          stage: sleepType,
        );
      }).toList();
      var data =
          sleepDataPoints.map((heartRate) => heartRate.toJson()).toList();
      var da = json.encode(data).toString();
      log.info("Sleep data points: $sleepDataPoints");

      return sleepDataPoints;
    } else {
      log.info("Not authorized to read health data returning empty list");
      return [];
    }
  }

  @override
  Future<List<HeartRate>> getRestingRates(DateTime start, DateTime end) async {
    //HealthFactory health = HealthFactory();
    var health = Health();
    List<HealthDataType> types = [
      HealthDataType.RESTING_HEART_RATE,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    log.info("Requesting permissions for $permissions");

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;
    log.info("Has permissions: $hasPermissions");
    bool authorized = false;
    if (!hasPermissions) {
      log.info("Requesting authorization for $types");
      // requesting access to the data types before reading them
      try {
        log.info("Requesting authorization for $types");
        authorized = await health.requestAuthorization(types);
      } catch (error, stackTrace) {
        log.severe('Exception in authorize!', error, stackTrace);
      }
    } else {
      authorized = true; // await health.requestAuthorization(types);
    }

    if (authorized) {
      log.info("Authorized to read health data");
      print("Getting health data from $start to $end for $types");
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );
      log.info("Health data for resting heart rate: $healthData");
      List<HeartRate> heartRates = healthData.map((dataPoint) {
        print("MapingData: Data point: $dataPoint");
        return HeartRate(
          (dataPoint.value as NumericHealthValue).numericValue.toInt(),
          dataPoint.dateFrom,
          dataPoint.dateFrom.add(const Duration(minutes: 4)),
        );
      }).toList();
      log.info("Resting heart rate data points: $heartRates");
      return heartRates;
    } else {
      log.info("Not authorized to read health data returning empty list");
      return [];
    }
  }

  @override
  Future<List<HeartRate>> getHeartRates(DateTime start, DateTime end) async {
    //HealthFactory health = HealthFactory();
    // return HeartSampleData().getHeartRates();
    var health = Health();
    List<HealthDataType> types = [
      HealthDataType.HEART_RATE,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    log.info("Requesting permissions for $permissions");

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;
    log.info("Has permissions: $hasPermissions");
    bool authorized = false;
    if (!hasPermissions) {
      log.info("Requesting authorization for $types");
      // requesting access to the data types before reading them
      try {
        log.info("Requesting authorization for $types");
        authorized = await health.requestAuthorization(types);
      } catch (error, stackTrace) {
        log.severe('Exception in authorize!', error, stackTrace);
      }
    } else {
      authorized = true;//await health.requestAuthorization(types);
    }

    if (authorized) {
      log.info("Authorized to read health data");
      log.info("Getting health data from $start to $end for $types");
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );
      var data = Health().removeDuplicates(healthData);
      log.info("Health data for heart rate: $healthData");
      List<HeartRate> heartRates = data.map((dataPoint) {
        log.info("MapingData: Data point: $dataPoint");
        return HeartRate(
          (dataPoint.value as NumericHealthValue).numericValue.toInt(),
          dataPoint.dateFrom,
          dataPoint.dateFrom.add(const Duration(minutes: 4)),
        );
      }).toList();
      log.info("Heart rate data points: $heartRates");
      // var hrates = json.encode(heartRates);
      var dataS = heartRates.map((heartRate) => heartRate.toJson()).toList();
      var da = json.encode(dataS).toString();

      ///print(hrates);
      return heartRates;
    } else {
      log.info("Not authorized to read health data returning empty list");
      return [];
    }
  }

  @override
  Future<List<SleepSession>> getSleepSessions(
      DateTime start, DateTime end) async {
    //HealthFactory health = HealthFactory();

    //return SleepSessionData().getSleepSessions();
    var health = Health();
    List<HealthDataType> types = [HealthDataType.SLEEP_IN_BED];
    if (Platform.isAndroid) {
      types = [
        HealthDataType.SLEEP_SESSION,
      ];
    }

    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    log.info("Requesting permissions for $permissions");

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions) ?? false;

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    //hasPermissions = false;
    log.info("Has permissions: $hasPermissions");
    bool authorized = false;
    if (!hasPermissions) {
      log.info("Requesting authorization for $types");
      // requesting access to the data types before reading them
      try {
        log.info("Requesting authorization for $types");
        authorized = await health.requestAuthorization(types);
      } catch (error, stackTrace) {
        log.severe('Exception in authorize!', error, stackTrace);
      }
    } else {
      authorized = true;//await health.requestAuthorization(types);
    }

    if (authorized) {
      log.info("Authorized to read health data");
      log.info("Getting health data from $start to $end for $types");
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        startTime: start,
        endTime: end,
        types: types,
      );

      log.info("Health data for sleep session: $healthData");
      List<SleepSession> sleepSessions = healthData.map((dataPoint) {
        log.info("MapingData: Data point: $dataPoint");
        return SleepSession(
          from: dataPoint.dateFrom,
          to: dataPoint.dateTo,
        );
      }).toList();

      log.info("Sleep session data points: $sleepSessions");
      return sleepSessions;
    } else {
      log.info("Not authorized to read health data returning empty list");
      return [];
    }
  }
}
