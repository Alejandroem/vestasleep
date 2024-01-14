import 'dart:developer';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/services/health_service.dart';

class GoogleAppleHealthService implements HealthService {
  @override
  Future<bool> requestPermissions() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    await Permission.activityRecognition.request();
    await Permission.location.request();

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
}
