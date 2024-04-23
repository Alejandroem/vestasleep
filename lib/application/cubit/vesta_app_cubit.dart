import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';

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

//TODO BREAKING CHANGE Here we have to figure out if the user already did the onboarding
class VestaAppCubit extends Cubit<VestaAppState> {
  AuthenticationService authenticationService;
  VestaAppCubit(
    this.authenticationService,
  ) : super(VestaAppState()) {
    checkOnboarding();
  }

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

  void checkOnboarding() async {
    VestaUser? vestaUser = await authenticationService.getCurrentUserOrNull();
    if (vestaUser == null) {
      setPage(VestaPages.getStarted);
    } else if (vestaUser.hasFinishedOnboarding ?? false) {
      setHasFinishedOnboarding(true);
      setPage(VestaPages.dashboard);
    } else {
      setHasFinishedOnboarding(false);
      setPage(VestaPages.getStarted);
    }
  }
}
