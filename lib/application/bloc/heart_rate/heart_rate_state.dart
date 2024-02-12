part of 'heart_rate_bloc.dart';

enum HeartRateAssessment {
  potentialProblem,
  inminentProblem,
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
  final HeartRate? heartRate;
  final List<HeartRate>? heartRateList;
  final HeartRateAssessment assessment;

  const MonitoringHeartRate(
      this.heartRate, this.heartRateList, this.assessment);
  @override
  List<Object> get props => [
        heartRate ?? 0,
        heartRateList ?? [],
        assessment,
      ];
}
