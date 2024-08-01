import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/authentication_service.dart';

class ForgotPasswordState {
  final String email;
  final bool emailTouched;
  final String emailValid;
  final bool isSubmitting;
  final bool isSuccess;
  

  ForgotPasswordState({
    required this.email,
    required this.emailTouched,
    required this.emailValid,
    required this.isSubmitting,
    this.isSuccess = false,
  });

  factory ForgotPasswordState.initial() {
    return ForgotPasswordState(
      email: '',
      emailTouched: false,
      emailValid: '',
      isSubmitting: false,
    );
  }

  ForgotPasswordState copyWith({
    String? email,
    bool? emailTouched,
    String? emailValid,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      emailTouched: emailTouched ?? this.emailTouched,
      emailValid: emailValid ?? this.emailValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  bool validForm() {
    return emailValid.isEmpty && email.isNotEmpty && emailTouched;
  }
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthenticationService authenticationService;

  ForgotPasswordCubit(
    this.authenticationService,
  ) : super(ForgotPasswordState.initial());

  void emailChanged(String email) {
    bool isEmailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    emit(
      state.copyWith(
        email: email,
        emailTouched: true,
        emailValid: isEmailValid ? '' : 'Invalid email',
      ),
    );
  }

  Future<void> submit() async {
    emit(
      state.copyWith(
        isSubmitting: true,
      ),
    );

    final success = await authenticationService.forgotPassword(
      email: state.email,
    );

    if (success) {
      emit(
        state.copyWith(
          isSuccess: true,
          isSubmitting: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isSuccess: false,
          isSubmitting: false,
        ),
      );
    }
  }
}
