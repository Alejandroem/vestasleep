part of 'alarm_bloc.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();
}

class AlarmDisarmed extends AlarmState {
  @override
  List<Object> get props => [];
}

class AwaitingUserResponse extends AlarmState {
  @override
  List<Object> get props => [];
}

class AwaitResponderResponse extends AlarmState {
  final List<VestaContact> contact;

  const AwaitResponderResponse(this.contact);

  @override
  List<Object> get props => [contact];
}

class EmergencyResponse extends AlarmState {
  const EmergencyResponse();

  @override
  List<Object> get props => [];
}
