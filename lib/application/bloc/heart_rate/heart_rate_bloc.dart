import 'dart:async';
import 'dart:developer';

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
  final Duration tenSeconds = const Duration(seconds: 10);
  AlarmBloc alarmBloc;
  HealthService healthService;
  StreamSubscription<HeartRate>? heartRateSubscription;
  Timer? _timerToAddressPotentialProblem;
  Timer? _timerToAddressSevereProblem;
  Timer? _recoveryTimer;

  HeartRateBloc(
    this.alarmBloc,
    this.healthService,
  ) : super(HeartRateNotMonitored()) {
    //We trigger the monitoring of the heart rate

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
    log('Monitoring heart rate');
    if (heartRateSubscription != null) {
      await heartRateSubscription!.cancel();
    }
    Stream<HeartRate> heartRateStream =
        await healthService.getHeartRateStream(tenSeconds);

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
    log('New heart rate lecture: ${event.heartRate}');

    //Start waiting for the next 60 seconds to check if the heart rate is still a problem
    if (hasHeartRateProblem(event.heartRate, userState) &&
        alarmBloc.state is AlarmDisarmed) {
      _timerToAddressPotentialProblem ??=
          Timer.periodic(const Duration(seconds: 1), (timer) {
        log('Heart rate problem detected. Timer tick: ${50 - timer.tick}');
        //We wait for 50 seconds before triggering the alarm because
        //the reading was from the last 10 seconds
        //and we want to wait for the next 20 seconds to be sure
        //Total time is 60 seconds
        if (timer.tick == 50) {
          log('Heart rate problem timer expired');
          add(NewHeartRateProblem(
            event.heartRate,
          ));
          _timerToAddressPotentialProblem?.cancel();
          _timerToAddressPotentialProblem = null;
        }
      });
    }
    if (hasSevereHeartRateProblem(event.heartRate) &&
        alarmBloc.state is AlarmDisarmed) {
      _timerToAddressSevereProblem ??=
          Timer.periodic(const Duration(seconds: 1), (timer) {
        log('Urgent heart rate problem detected. Timer tick: ${10 - timer.tick}');
        //We wait for 10 seconds before triggering the emergency response because
        //the reading was from the last 10 seconds
        //and we want to wait for the next 10 seconds to be sure
        //total time is 20 seconds
        if (timer.tick == 10) {
          log('Urgent heart rate problem timer expired');
          add(NewUrgentHeartRateProblem(
            event.heartRate,
          ));

          _timerToAddressSevereProblem?.cancel();
          _timerToAddressSevereProblem = null;
        }
      });
    }
    //We only start a recovery timer if the heart rate is normal
    if (heartRateNormal(event.heartRate, userState) &&
        alarmBloc.state is! AlarmDisarmed) {
      _recoveryTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
        log('Heart rate recovery detected. Timer tick: ${110 - timer.tick}');
        //We wait for 110 seconds before disarming the timers because
        //We want to be sure the heart rate has recovered
        //Total time is 120 seconds
        if (timer.tick == 110) {
          log('Heart rate recovery timer expired');
          _timerToAddressPotentialProblem?.cancel();
          _timerToAddressSevereProblem?.cancel();
          _recoveryTimer?.cancel();
        }
      });
    }
    //We cancel the recovery timer if the heart rate is not normal
    else {
      _recoveryTimer?.cancel();
    }
  }

  FutureOr<void> _onNewHeartRateProblem(
      NewHeartRateProblem event, Emitter<HeartRateState> emit) {
    log('Heart rate problem detected');
    _timerToAddressPotentialProblem?.cancel();
    _timerToAddressPotentialProblem = null;
    alarmBloc.add(TriggerPotentialProblemAlarm());
  }

  FutureOr<void> _onNewUrgentHeartRateProblem(
      NewUrgentHeartRateProblem event, Emitter<HeartRateState> emit) {
    log('Urgent heart rate problem detected');
    _timerToAddressPotentialProblem?.cancel();
    _timerToAddressPotentialProblem = null;
    alarmBloc.add(const TriggerContactsResponse());
  }
}
