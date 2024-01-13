import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../domain/services/health_service.dart';

enum CurrentPage {
  getStarted,
  connectToHealthKit, dashboard,
}

class VestaAppState {
  final bool hasFinishedOnboarding;
  final CurrentPage page;

  VestaAppState({
    this.hasFinishedOnboarding = false,
    this.page = CurrentPage.getStarted,
  });

  VestaAppState copyWith({
    bool? hasFinishedOnboarding,
    CurrentPage? page,
  }) {
    return VestaAppState(
      hasFinishedOnboarding:
          hasFinishedOnboarding ?? this.hasFinishedOnboarding,
      page: page ?? this.page,
    );
  }
}

class VestaAppCubit extends HydratedCubit<VestaAppState> {
  final HealthService healthService;
  VestaAppCubit(this.healthService) : super(VestaAppState()) {
    healthService.requestPermission();
  }

  void setHasFinishedOnboarding(bool hasFinishedOnboarding) {
    emit(state.copyWith(hasFinishedOnboarding: hasFinishedOnboarding));
  }

  void setPage(CurrentPage page) {
    emit(state.copyWith(page: page));
  }

  @override
  VestaAppState? fromJson(Map<String, dynamic> json) {
    return VestaAppState(
      hasFinishedOnboarding: json["hasFinishedOnboarding"],
      page: CurrentPage.values[json["page"]],
    );
  }

  @override
  Map<String, dynamic>? toJson(VestaAppState state) {
    return {
      "hasFinishedOnboarding": state.hasFinishedOnboarding,
      "page": state.page.index,
    };
  }
}
