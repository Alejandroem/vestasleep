import 'dart:developer';

import 'package:health/health.dart';

import '../../domain/services/health_service.dart';

class GoogleAppleHealthService implements HealthService {
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  @override
  Future<bool> requestPermissions() async {
    //Request permissions for
    //   HealthDataType.BLOOD_GLUCOSE,
    //   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    //   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,

    List<HealthDataType> types = [
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
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
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        log("Exception in healthservice authorize: $error");
      }
    }

    return authorized;
  }
}
