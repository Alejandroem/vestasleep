part of 'heart_rate_bloc.dart';

enum HeartRateAssessment {
  aboveRestingThreshold,
  belowRestingThreshold,
  aboveSleepingThreshold,
  belowSleepingThreshold,
  aboveExcerciseThreshold,
  belowExcerciseThreshold,
  normal,
  calibrating,
}

abstract class HeartRateState extends Equatable {
  const HeartRateState();
}

class HeartRateNotMonitored extends HeartRateState {
  @override
  List<Object> get props => [];
}

class MonitoringHeartRate extends HeartRateState {
  final HeartRateAssessment assessment;

  const MonitoringHeartRate(this.assessment);
  @override
  List<Object> get props => [];
}

