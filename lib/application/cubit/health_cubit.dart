import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/health_service.dart';

class HealthState {
  final bool hasPermission;
  final bool permissionDeniedByUser;

  HealthState({
    this.hasPermission = false,
    this.permissionDeniedByUser = false,
  });

  HealthState copyWith({
    bool? hasPermission,
    bool? permissionDeniedByUser,
  }) {
    return HealthState(
      hasPermission: hasPermission ?? this.hasPermission,
      permissionDeniedByUser:
          permissionDeniedByUser ?? this.permissionDeniedByUser,
    );
  }

  @override
  String toString() => 'HealthState(hasPermission: $hasPermission)';
}

class HealthCubit extends Cubit<HealthState> {
  final HealthService healthService;

  HealthCubit(this.healthService) : super(HealthState()) {}

  Future<void> checkPermissions() async {
    final bool hasPermission = await healthService.requestPermissions();
    emit(state.copyWith(
        hasPermission: hasPermission, permissionDeniedByUser: false));
  }

  void permissionDeniedByUser() {
    emit(state.copyWith(permissionDeniedByUser: true));
  }
}
