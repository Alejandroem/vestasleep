part of 'heart_rate_bloc.dart';

enum UserState {
  normal,
  sleeping,
  excercising,
}

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

class SendingNotificationToUser extends HeartRateState {
  @override
  List<Object> get props => [];
}

class AknowledgingNotification extends HeartRateState {
  @override
  List<Object> get props => [];
}

class NoProblemAknowledged extends HeartRateState {
  @override
  List<Object> get props => [];
}

class ProblemAknowledged extends HeartRateState {
  @override
  List<Object> get props => [];
}

class SendingNotificationToResponder extends HeartRateState {
  final int attempt;
  final VestaContact contact;

  const SendingNotificationToResponder(this.attempt, this.contact);

  @override
  List<Object> get props => [attempt, contact];
}

class AknowledgedProblemByResponder extends HeartRateState {
  final int attempt;
  final VestaContact contact;

  const AknowledgedProblemByResponder(this.attempt, this.contact);

  @override
  List<Object> get props => [attempt, contact];
}
