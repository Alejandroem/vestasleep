import '../models/heart_rate.dart';
import '../models/sleep_data_point.dart';
import '../models/user_state.dart';

abstract class HealthService {
  Future<bool> requestLocationPermission();
  Future<bool> requestPermissions();
  Future<Stream<HeartRate>> getHeartRateStream(Duration lectureLength);
  Future<Stream<HeartRate>> getRestingHeartRateStream();
  Future<HeartRate> getCurrentRestingHeartRate();
  Future<UserState> getUserState();
  Future<List<SleepDataPoint>> getSleepData(DateTime start, DateTime end);
}
