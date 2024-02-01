import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/contact.dart';
import '../../../domain/models/heart_rate.dart';
import '../../../domain/models/user_state.dart';
import '../../../domain/services/health_service.dart';
import '../../use_cases/heart_rate_functions.dart';

part 'heart_rate_state.dart';
part 'heart_rate_events.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  HealthService healthService;
  StreamSubscription<HeartRate>? heartRateSubscription;
  Timer? _regularThresholdTimer;
  Timer? _urgentThresholdTimer;

  HeartRateBloc(this.healthService) : super(HeartRateNotMonitored()) {
    //We trigger the monitoring of the heart rate
    add(StartMonitoringHeartRate());

    on<StartMonitoringHeartRate>(_onStartMonitoringHeartRate);
    on<StopMonitoringHeartRate>(_onStopMonitoringHeartRate);
    on<NewHeartRateLecture>(_onNewHeartRateEvent);
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
        await healthService.getHeartRateStream();
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

    //Start a check for the next 30 seconds
    if (hasHeartRateProblem(event.heartRate, userState)) {
      _regularThresholdTimer ??=
          Timer.periodic(const Duration(seconds: 60), (timer) {
        add(NewHeartRateProblem(
          event.heartRate,
        ));
      });
    }
    if (hasSevereHeartRateProblem(event.heartRate)) {
      _urgentThresholdTimer ??=
          Timer.periodic(const Duration(seconds: 10), (timer) {
        add(NewHeartRateProblem(event.heartRate));
      });
    }
    //If the heart rate is normal, cancel the timer
    else {
      _regularThresholdTimer?.cancel();
      _regularThresholdTimer = null;
      _urgentThresholdTimer?.cancel();
      _urgentThresholdTimer = null;
    }
  }
}
