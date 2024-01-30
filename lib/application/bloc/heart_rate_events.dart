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

