import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/heart_rate.dart';
import '../../../domain/models/user_state.dart';
import '../../../domain/services/health_service.dart';
import '../../use_cases/heart_rate_functions.dart';
import '../alarm/alarm_bloc.dart';

part 'heart_rate_state.dart';
part 'heart_rate_events.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  final Duration lectureLength = Duration(seconds: 10);
  AlarmBloc alarmBloc;
  HealthService healthService;
  StreamSubscription<HeartRate>? heartRateSubscription;
  Timer? _timerBeforeTriggeringAlarm;
  Timer? _timerBeforeTriggeringEmergency;

  HeartRateBloc(
    this.alarmBloc,
    this.healthService,
  ) : super(HeartRateNotMonitored()) {
    //We trigger the monitoring of the heart rate
    add(StartMonitoringHeartRate());

    on<StartMonitoringHeartRate>(_onStartMonitoringHeartRate);
    on<StopMonitoringHeartRate>(_onStopMonitoringHeartRate);
    on<NewHeartRateLecture>(_onNewHeartRateEvent);
    on<NewHeartRateProblem>(_onNewHeartRateProblem);
    on<NewUrgentHeartRateProblem>(_onNewUrgentHeartRateProblem);
  }

  @override
  void onChange(Change<HeartRateState> change) {
    super.onChange(change);
  }

  @override
  void onTransition(
    Transition<HeartRateEvent, HeartRateState> transition,
  ) {
    super.onTransition(transition);
  }

  FutureOr<void> _onStopMonitoringHeartRate(
      StopMonitoringHeartRate event, Emitter<HeartRateState> emit) {
    heartRateSubscription?.cancel();
    emit(HeartRateNotMonitored());
  }

  FutureOr<void> _onStartMonitoringHeartRate(
      StartMonitoringHeartRate event, Emitter<HeartRateState> emit) async {
    if (heartRateSubscription != null) {
      heartRateSubscription!.cancel();
    }
    Stream<HeartRate> heartRateStream =
        await healthService.getHeartRateStream(lectureLength);
    heartRateSubscription = heartRateStream.listen((heartRate) {
      add(NewHeartRateLecture(heartRate));
    });

    emit(
      const MonitoringHeartRate(
        HeartRateAssessment.calibrating,
      ),
    ); //We assume the heart rate is normal
  }

  FutureOr<void> _onNewHeartRateEvent(
      NewHeartRateLecture event, Emitter<HeartRateState> emit) async {
    //TODO add try catch to this?
    UserState userState = await healthService.getUserState();

    //Start waiting for the next 60 seconds to check if the heart rate is still a problem
    if (hasHeartRateProblem(event.heartRate, userState)) {
      _timerBeforeTriggeringAlarm ??=
          Timer.periodic(const Duration(seconds: 60), (timer) {
        add(NewHeartRateProblem(
          event.heartRate,
        ));
      });
    }
    //If the heart it's urgent, we start waiting for the next 10 seconds to check if the heart rate is still a problem
    else if (hasSevereHeartRateProblem(event.heartRate)) {
      _timerBeforeTriggeringEmergency ??=
          Timer.periodic(const Duration(seconds: 10), (timer) {
        add(NewUrgentHeartRateProblem(event.heartRate));
      });
    }
    //If the heart rate is normal after the next lecture we cancel the timers
    //The lectures are determined by the lecture paramter
    else {
      _timerBeforeTriggeringAlarm?.cancel();
      _timerBeforeTriggeringAlarm = null;
      _timerBeforeTriggeringEmergency?.cancel();
      _timerBeforeTriggeringEmergency = null;
    }
  }

  FutureOr<void> _onNewHeartRateProblem(
      NewHeartRateProblem event, Emitter<HeartRateState> emit) {
    alarmBloc.add(TriggerAlarm());
  }

  FutureOr<void> _onNewUrgentHeartRateProblem(
      NewUrgentHeartRateProblem event, Emitter<HeartRateState> emit) {
    alarmBloc.add(TriggerEmergencyResponse());
  }
}
