part of 'alarm_bloc.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object> get props => [];
}

class TriggerPotentialProblemAlarm extends AlarmEvent {}

class DisarmAlarm extends AlarmEvent {}

class TriggerContactsResponse extends AlarmEvent {
  const TriggerContactsResponse();

  @override
  List<Object> get props => [];
}

class TriggerEmergencyResponse extends AlarmEvent {}

class UpdatePotentialProblemTimer extends AlarmEvent {
  final int timeLeft;
  const UpdatePotentialProblemTimer(this.timeLeft);

  @override
  List<Object> get props => [timeLeft];
}

class UpdateEmergencyResponseTime extends AlarmEvent {
  final int timeLeft;
  const UpdateEmergencyResponseTime(this.timeLeft);

  @override
  List<Object> get props => [timeLeft];
}
