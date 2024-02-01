import 'package:hydrated_bloc/hydrated_bloc.dart';

enum VestaPages {
  getStarted,
  connectToHealthKit,
  dashboard,
  selectGender,
  settingUpProfile,
  editAddress,
  editContacts,
  enableEmergencyResponse,
  personalSafety,
  done,
}

class VestaAppState {
  final bool hasFinishedOnboarding;
  final VestaPages page;

  VestaAppState({
    this.hasFinishedOnboarding = false,
    this.page = VestaPages.getStarted,
  });

  VestaAppState copyWith({
    bool? hasFinishedOnboarding,
    VestaPages? page,
  }) {
    return VestaAppState(
      hasFinishedOnboarding:
          hasFinishedOnboarding ?? this.hasFinishedOnboarding,
      page: page ?? this.page,
    );
  }
}

class VestaAppCubit extends Cubit<VestaAppState> {
  VestaAppCubit() : super(VestaAppState());

  void setHasFinishedOnboarding(bool hasFinishedOnboarding) {
    emit(state.copyWith(hasFinishedOnboarding: hasFinishedOnboarding));
  }

  void setPage(VestaPages page) {
    emit(state.copyWith(page: page));
  }

  @override
  VestaAppState? fromJson(Map<String, dynamic> json) {
    return VestaAppState(
      hasFinishedOnboarding: json["hasFinishedOnboarding"],
      page: VestaPages.values[json["page"]],
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
