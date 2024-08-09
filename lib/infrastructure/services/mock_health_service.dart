// ignore_for_file: dead_code

import 'dart:math';

import '../../domain/models/heart_rate.dart';
import '../../domain/models/sleep_data_point.dart';
import '../../domain/models/sleep_session.dart';
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
            100,
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
    final today = DateTime.now();
    DateTime yesterdayNight =
        DateTime(today.year, today.month, today.day - 1, 20, 0, 0, 0, 0);
    return [
      SleepDataPoint(
        from: yesterdayNight,
        to: yesterdayNight.add(const Duration(hours: 1)),
        stage: SleepStage.awake,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 1)),
        to: yesterdayNight.add(const Duration(hours: 2)),
        stage: SleepStage.rem,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 2)),
        to: yesterdayNight.add(const Duration(hours: 3)),
        stage: SleepStage.asleepCore,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 3)),
        to: yesterdayNight.add(const Duration(hours: 4)),
        stage: SleepStage.deep,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 4)),
        to: yesterdayNight.add(const Duration(hours: 5)),
        stage: SleepStage.asleepCore,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 5)),
        to: yesterdayNight.add(const Duration(hours: 6)),
        stage: SleepStage.rem,
      ),
      SleepDataPoint(
        from: yesterdayNight.add(const Duration(hours: 6)),
        to: yesterdayNight.add(const Duration(hours: 10)),
        stage: SleepStage.awake,
      ),
    ];
  }

  @override
  Future<List<SleepSession>> getSleepSessions(
      DateTime start, DateTime end) async {
    final today = DateTime.now();
    final yesterdayNight =
        DateTime(today.year, today.month, today.day - 1, 20, 0, 0, 0, 0);
    return [
      SleepSession(
        from: yesterdayNight,
        to: yesterdayNight.add(
          const Duration(
            hours: 3,
          ),
        ),
      ),
      SleepSession(
        from: yesterdayNight.add(
          const Duration(
            hours: 4,
          ),
        ),
        to: yesterdayNight.add(
          const Duration(
            hours: 10,
          ),
        ),
      ),
    ];
  }

  @override
  Future<List<HeartRate>> getHeartRates(DateTime start, DateTime end) async {
    var rng = Random();
    List<HeartRate> heartRates = [];

    final today = DateTime.now();
    DateTime yesterdayNight =
        DateTime(today.year, today.month, today.day - 1, 0, 0, 0, 0, 0);
    end = yesterdayNight.add(const Duration(hours: 24 + 12));
    while (yesterdayNight.isBefore(end)) {
      //Range of adults 35 years 162 to 95
      int heartRate = rng.nextInt(162 - 95) + 95;
      if ((yesterdayNight.hour > 20 && yesterdayNight.day == today.day - 1) ||
          (yesterdayNight.hour < 8 && yesterdayNight.day == today.day)) {
        //Decreases between 50 to 40 of a normal heart rate
        heartRate = (rng.nextInt(100 - 60) + 40);
      }
      heartRates.add(HeartRate(
        heartRate,
        yesterdayNight,
        yesterdayNight.add(const Duration(minutes: 15)),
      ));
      yesterdayNight = yesterdayNight.add(const Duration(minutes: 15));
    }
    return heartRates;
  }

  @override
  Future<List<HeartRate>> getRestingRates(DateTime start, DateTime end) async {
    var rng = Random();
    List<HeartRate> heartRates = [];

    final today = DateTime.now();
    DateTime yesterdayNight =
        DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0).subtract(Duration(days: 1));
    end = yesterdayNight.add(const Duration(hours: 24 + 12));
    while (yesterdayNight.isBefore(end)) {
      //Average heart rate 100 to 60
      int heartRate = rng.nextInt(100 - 60) + 60;
      heartRates.add(HeartRate(
        heartRate,
        yesterdayNight,
        yesterdayNight.add(const Duration(minutes: 15)),
      ));
      yesterdayNight = yesterdayNight.add(const Duration(minutes: 15));
    }
    return heartRates;
  }
}
