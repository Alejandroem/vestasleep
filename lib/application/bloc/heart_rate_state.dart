part of 'heart_rate_bloc.dart';


abstract class HeartRateState extends Equatable {
  const HeartRateState();
}

class HeartRateInitial extends HeartRateState {
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
