import 'dart:async';
import 'dart:developer';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/heart_rate.dart';
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

    _heartRateTimer =
        Timer.periodic(delta, (timer) async {
      try {
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          DateTime.now().subtract(delta),
          DateTime.now(),
          [
            HealthDataType.HEART_RATE,
          ],
        );

        if (healthData.isNotEmpty) {
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
  Future<UserState> getUserState() {
    // TODO: implement getUserState
    throw UnimplementedError();
  }
}
