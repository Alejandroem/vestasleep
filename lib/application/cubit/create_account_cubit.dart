import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountState {
  final String username;
  final String validUsername;
  final String email;
  final String validEmail;
  final String password;
  final String validPassword;
  final bool obscurePassword;

  final bool isSubmitting;
  final bool isSuccess;

  const CreateAccountState({
    this.username = "",
    this.validUsername = "",
    this.email = "",
    this.validEmail = "",
    this.password = "",
    this.validPassword = "",
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  CreateAccountState copyWith({
    String? username,
    String? validUsername,
    String? email,
    String? validEmail,
    String? password,
    String? validPassword,
    bool? obscurePassword,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return CreateAccountState(
      username: username ?? this.username,
      validUsername: validUsername ?? this.validUsername,
      email: email ?? this.email,
      validEmail: validEmail ?? this.validEmail,
      password: password ?? this.password,
      validPassword: validPassword ?? this.validPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(const CreateAccountState());

  void setUsername(String username) {
    emit(state.copyWith(username: username));
  }

  void setValidUsername(String validUsername) {
    emit(state.copyWith(validUsername: validUsername));
  }

  void setEmail(String email) {
    emit(state.copyWith(email: email));
  }

  void setValidEmail(String validEmail) {
    emit(state.copyWith(validEmail: validEmail));
  }

  void setPassword(String password) {
    emit(state.copyWith(password: password));
  }

  void setValidPassword(String validPassword) {
    emit(state.copyWith(validPassword: validPassword));
  }

  void setObscurePassword(bool obscurePassword) {
    emit(state.copyWith(obscurePassword: obscurePassword));
  }

  void setIsSubmitting(bool isSubmitting) {
    emit(state.copyWith(isSubmitting: isSubmitting));
  }

  void setIsSuccess(bool isSuccess) {
    emit(state.copyWith(isSuccess: isSuccess));
  }

  void reset() {
    emit(const CreateAccountState());
  }
}
