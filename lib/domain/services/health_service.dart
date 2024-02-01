import '../../application/bloc/heart_rate/heart_rate_bloc.dart';
import '../models/heart_rate.dart';

abstract class HealthService {
  Future<bool> requestLocationPermission();
  Future<bool> requestPermissions();
  Future<Stream<HeartRate>> getHeartRateStream();
  Future<Stream<HeartRate>> getRestingHeartRateStream();
  Future<HeartRate> getCurrentRestingHeartRate();
  Future<UserState> getUserState();
}
