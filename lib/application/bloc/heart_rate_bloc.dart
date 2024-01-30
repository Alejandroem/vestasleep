import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/health_service.dart';

part 'heart_rate_state.dart';
part 'heart_rate_events.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {
  HealthService healthService;

  HeartRateBloc(this.healthService) : super(HeartRateInitial()) {
    add(StartMonitoringHeartRate());

    on<StartMonitoringHeartRate>(_onStartMonitoringHeartRate);
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
      StartMonitoringHeartRate event, Emitter<HeartRateState> emit) {}
}
