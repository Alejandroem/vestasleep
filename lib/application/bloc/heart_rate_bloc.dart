import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/contact.dart';
import '../../domain/models/heart_rate.dart';
import '../../domain/services/health_service.dart';
import '../use_cases/heart_rate_functions.dart';

part 'heart_rate_state.dart';
part 'heart_rate_events.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  HealthService healthService;
  StreamSubscription<HeartRate>? heartRateSubscription;
  Timer? _thresholdTimer;

  HeartRateBloc(this.healthService) : super(HeartRateInitial()) {
    add(StartMonitoringHeartRate());

    on<StartMonitoringHeartRate>(_onStartMonitoringHeartRate);
    on<NewHeartRateEvent>(_onNewHeartRateEvent);
    on<DetectedHeartRateProblem>(_onDetectedHeartRateProblem);
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

  FutureOr<void> _onStartMonitoringHeartRate(
      StartMonitoringHeartRate event, Emitter<HeartRateState> emit) async {
    if (heartRateSubscription != null) {
      heartRateSubscription!.cancel();
    }
    Stream<HeartRate> heartRateStream =
        await healthService.getHeartRateStream();
    heartRateSubscription = heartRateStream.listen((heartRate) {
      add(NewHeartRateEvent(heartRate));
    });
  }

  FutureOr<void> _onNewHeartRateEvent(
      NewHeartRateEvent event, Emitter<HeartRateState> emit) async {
    HeartRate baseHeartRate = await healthService.getCurrentRestingHeartRate();

    //Start a check for the next 30 seconds
    if (hasHeartRateProblem(event.heartRate, baseHeartRate)) {
      _thresholdTimer ??= Timer.periodic(const Duration(seconds: 30), (timer) {
        add(DetectedHeartRateProblem(event.heartRate));
      });
    }
    //If the heart rate is normal, cancel the timer
    else {
      _thresholdTimer?.cancel();
      _thresholdTimer = null;
    }
  }

  FutureOr<void> _onDetectedHeartRateProblem(
      DetectedHeartRateProblem event, Emitter<HeartRateState> emit) {
        if (state is SendingNotificationToUser) {
          emit(SendingNotificationToUser());
        }
      }
}
