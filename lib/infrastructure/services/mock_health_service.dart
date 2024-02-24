import 'dart:developer';
import 'dart:math';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_data_point.dart';
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
        return getListOfHeartRate(
          DateTime.now(),
          Random().nextInt(16) + 85,
          1,
        );
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
    return Future.value(UserState.normal);
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

  @override
  Future<List<SleepDataPoint>> getSleepData(
      DateTime start, DateTime end) async {
    return generateSleepData(start);
  }

  List<SleepDataPoint> generateSleepData(DateTime start) {
    var rng = Random();
    List<SleepDataPoint> sleepData = [];
    List<SleepStage> stages = SleepStage.values;
    DateTime current = start;

    while (current.isBefore(start.add(Duration(hours: 24)))) {
      SleepStage randomStage = stages[rng.nextInt(stages.length)];
      DateTime end = current.add(Duration(hours: rng.nextInt(3) + 1));
      sleepData.add(SleepDataPoint(from: current, to: end, stage: randomStage));
      current = end;
    }

    return sleepData;
  }
}
