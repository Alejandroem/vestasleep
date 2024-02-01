import '../../domain/models/heart_rate.dart';
import '../../domain/models/user_state.dart';
import '../../domain/services/health_service.dart';

class MockHealthService implements HealthService {
  List<HeartRate> getRestingHeartRate(DateTime baseTime, int baseHeartRate) {
    return List<HeartRate>.generate(
      60,
      (index) {
        return HeartRate(
          baseHeartRate,
          baseTime.add(Duration(seconds: index)),
          baseTime.add(Duration(seconds: index + 1)),
        );
      },
    );
  }

  List<HeartRate> getHeartRateWithLowProblem(
      DateTime baseTime, int baseHeartRate) {
    return List<HeartRate>.generate(
      60,
      (index) {
        if (index < 30 || index >= 40) {
          return HeartRate(
            baseHeartRate,
            baseTime.add(Duration(seconds: index)),
            baseTime.add(Duration(seconds: index + 1)),
          );
        } else {
          return HeartRate(
            baseHeartRate - 60, // Assuming baseHeartRate is 80
            baseTime.add(Duration(seconds: index)),
            baseTime.add(Duration(seconds: index + 1)),
          );
        }
      },
    );
  }

  List<HeartRate> getHeartRateWithHighProblem(
      DateTime baseTime, int baseHeartRate) {
    return List<HeartRate>.generate(
      60,
      (index) {
        if (index < 30 || index >= 40) {
          return HeartRate(
            baseHeartRate,
            baseTime.add(Duration(seconds: index)),
            baseTime.add(Duration(seconds: index + 1)),
          );
        } else {
          return HeartRate(
            baseHeartRate + 120, // Assuming baseHeartRate is 80
            baseTime.add(Duration(seconds: index)),
            baseTime.add(Duration(seconds: index + 1)),
          );
        }
      },
    );
  }

  @override
  Future<Stream<HeartRate>> getHeartRateStream() {
    //Switch between the three and return them forever
    return Future.value(
      Stream.periodic(
        const Duration(seconds: 1),
        (index) {
          if (index % 3 == 0) {
            return getHeartRateWithLowProblem(
              DateTime.now(),
              80,
            );
          } else if (index % 3 == 1) {
            return getHeartRateWithHighProblem(
              DateTime.now(),
              80,
            );
          } else {
            return getRestingHeartRate(
              DateTime.now(),
              80,
            );
          }
        },
      ).asyncExpand((element) => Stream.fromIterable(element)),
    );
  }

  @override
  Future<Stream<HeartRate>> getRestingHeartRateStream() {
    //return the resting heart rate forever
    return Future.value(
      Stream.periodic(
        const Duration(seconds: 1),
        (index) {
          return getRestingHeartRate(
            DateTime.now(),
            80,
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
