part of 'heart_rate_bloc.dart';

abstract class HeartRateEvent extends Equatable {
  const HeartRateEvent();
}

class StartMonitoringHeartRate extends HeartRateEvent {
  @override
  List<Object> get props => [];
}

class StopMonitoringHeartRate extends HeartRateEvent {
  @override
  List<Object> get props => [];
}

class NewHeartRateEvent extends HeartRateEvent {
  final HeartRate heartRate;

  const NewHeartRateEvent(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}

class DetectedHeartRateProblem extends HeartRateEvent {
  final HeartRate heartRate;

  const DetectedHeartRateProblem(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}
