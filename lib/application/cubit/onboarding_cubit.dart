import 'package:flutter_bloc/flutter_bloc.dart';

enum OnboardingPage {
  getStarted,
}

class OnboardingState {
  final bool hasFinishedOnboarding;
  final OnboardingPage page;

  OnboardingState({
    this.hasFinishedOnboarding = false,
    this.page = OnboardingPage.getStarted,
  });

  OnboardingState copyWith({
    bool? hasFinishedOnboarding,
    OnboardingPage? page,
  }) {
    return OnboardingState(
      hasFinishedOnboarding:
          hasFinishedOnboarding ?? this.hasFinishedOnboarding,
      page: page ?? this.page,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingState());

  void setHasFinishedOnboarding(bool hasFinishedOnboarding) {
    emit(state.copyWith(hasFinishedOnboarding: hasFinishedOnboarding));
  }

  void setPage(OnboardingPage page) {
    emit(state.copyWith(page: page));
  }
}   
