import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/health_service.dart';

class HealthState {
  final bool hasPermission;

  HealthState({
    this.hasPermission = false,
  });

  HealthState copyWith({
    bool? hasPermission,
  }) {
    return HealthState(
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }

  @override
  String toString() => 'HealthState(hasPermission: $hasPermission)';
}

class HealthCubit extends Cubit<HealthState> {
  final HealthService healthService;

  HealthCubit(this.healthService) : super(HealthState()) {
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    final bool hasPermission = await healthService.requestPermissions();
    emit(state.copyWith(hasPermission: hasPermission));
  }
}
