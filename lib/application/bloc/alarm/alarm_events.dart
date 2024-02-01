part of 'alarm_bloc.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();

  @override
  List<Object> get props => [];
}

class TriggerAlarm extends AlarmEvent {}

class DisarmAlarm extends AlarmEvent {}

class TriggerContactsResponse extends AlarmEvent {
  final List<VestaContact> contacts;

  const TriggerContactsResponse(this.contacts);

  @override
  List<Object> get props => [contacts];
}

class TriggerEmergencyResponse extends AlarmEvent {}
