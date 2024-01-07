import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/vesta_exception.dart';
import '../../domain/services/authentication_service.dart';

class LoginState {
  final String email;
  final bool emailTouched;
  final String password;
  final bool passwordTouched;
  final bool showPassword;
  final bool isSubmitting;
  final String validEmail;
  final String validPassword;

  LoginState({
    this.email = '',
    this.password = '',
    this.showPassword = false,
    this.isSubmitting = false,
    this.emailTouched = false,
    this.passwordTouched = false,
    this.validEmail = '',
    this.validPassword = '',
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? emailTouched,
    bool? passwordTouched,
    bool? showPassword,
    bool? isSubmitting,
    String? validEmail,
    String? validPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      showPassword: showPassword ?? this.showPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      validEmail: validEmail ?? this.validEmail,
      validPassword: validPassword ?? this.validPassword,
    );
  }

  bool validForm() {
    return validEmail.isEmpty &&
        validPassword.isEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        emailTouched &&
        passwordTouched;
  }
}

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationService authenticationService;
  LoginCubit(
    this.authenticationService,
  ) : super(
          LoginState(),
        );

  void setEmail(String email) {
    bool isEmailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    emit(state.copyWith(
      email: email,
      emailTouched: true,
      validEmail: isEmailValid ? "" : "Invalid email",
    ));
  }

  void setPassword(String password) {
    bool isPasswordValid =
        RegExp(r"^[a-zA-Z0-9!@#$%^&*()]+").hasMatch(password);
    emit(state.copyWith(
      password: password,
      passwordTouched: true,
      validPassword: isPasswordValid ? "" : "Invalid password",
    ));
  }

  void setShowPassword(bool showPassword) {
    emit(state.copyWith(showPassword: showPassword));
  }

  void logIn() async {
    emit(state.copyWith(isSubmitting: true));
    try {
      await authenticationService.signInWithEmailAndPassword(
        state.email,
        state.password,
      );
      emit(state.copyWith(isSubmitting: false));
    } on VestaException catch (e) {
      if (e.message == "invalid-credential") {
        emit(state.copyWith(
          isSubmitting: false,
          validEmail: "Invalid email",
          validPassword: "Invalid password",
        ));
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false));
      rethrow;
    }
  }
}
