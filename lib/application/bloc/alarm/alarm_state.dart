part of 'alarm_bloc.dart';

abstract class AlarmState extends Equatable {
  const AlarmState();
}

class AlarmDisarmed extends AlarmState {
  @override
  List<Object> get props => [];
}

class WaitingToNotifyContacts extends AlarmState {
  final int timeLeft;
  const WaitingToNotifyContacts(this.timeLeft);
  @override
  List<Object> get props => [
        timeLeft,
      ];
}

class WaitingToNotifyEmergencyServices extends AlarmState {
  final int timeLeft;

  const WaitingToNotifyEmergencyServices(this.timeLeft);

  @override
  List<Object> get props => [timeLeft];
}

class EmergencyResponseTriggered extends AlarmState {
  const EmergencyResponseTriggered();

  @override
  List<Object> get props => [];
}
