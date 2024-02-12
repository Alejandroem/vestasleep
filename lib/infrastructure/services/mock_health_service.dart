import 'dart:developer';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/user_state.dart';
import '../../domain/services/health_service.dart';

class MockHealthService implements HealthService {
  List<HeartRate> getListOfHeartRate(
      DateTime baseTime, int heartRate, int length) {
    return List<HeartRate>.generate(
      length,
      (index) {
        return HeartRate(
          heartRate,
          baseTime.add(Duration(seconds: index)),
          baseTime.add(Duration(seconds: index + 1)),
        );
      },
    );
  }

  @override
  Future<Stream<HeartRate>> getHeartRateStream(Duration delta) async {
    //Switch between the three and return them forever
    return Stream.periodic(
      delta,
      (index) {
        if (index < 3) {
          log('Normal');
          return getListOfHeartRate(
            DateTime.now(),
            80,
            10,
          );
        } else {
          log('Low problem');
          return getListOfHeartRate(
            DateTime.now(),
            80,
            10,
          );
        }
      },
    ).asyncExpand((element) => Stream.fromIterable(element));
  }

  @override
  Future<Stream<HeartRate>> getRestingHeartRateStream() {
    //return the resting heart rate forever
    return Future.value(
      Stream.periodic(
        const Duration(seconds: 1),
        (index) {
          return getListOfHeartRate(
            DateTime.now(),
            80,
            10,
          );
        },
      ).asyncExpand((element) => Stream.fromIterable(element)),
    );
  }

  @override
  Future<bool> requestLocationPermission() {
    return Future.value(true);
  }

  @override
  Future<bool> requestPermissions() {
    return Future.value(true);
  }

  @override
  Future<HeartRate> getCurrentRestingHeartRate() {
    // TODO: implement getCurrentRestingHeartRate
    throw UnimplementedError();
  }

  int _index = 0;

  @override
  Future<UserState> getUserState() {
    //use index to return different user states
    _index++;
    if (_index % 3 == 0) {
      return Future.value(UserState.normal);
    } else if (_index % 3 == 1) {
      return Future.value(UserState.sleeping);
    } else {
      return Future.value(UserState.excercising);
    }
  }
}
