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

class NewHeartRateLecture extends HeartRateEvent {
  final HeartRate heartRate;

  const NewHeartRateLecture(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}

class NewHeartRateProblem extends HeartRateEvent {
  final HeartRate heartRate;

  const NewHeartRateProblem(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}

class NewUrgentHeartRateProblem extends HeartRateEvent {
  final HeartRate heartRate;

  const NewUrgentHeartRateProblem(this.heartRate);

  @override
  List<Object> get props => [heartRate];
}
