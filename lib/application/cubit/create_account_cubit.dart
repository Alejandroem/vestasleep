import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountState {
  final String username;
  final bool usernameTouched;
  final String validUsername;
  final String email;
  final String validEmail;
  final bool emailTouched;
  final String password;
  final String validPassword;
  final bool passwordTouched;
  final bool obscurePassword;

  final bool isSubmitting;
  final bool isSuccess;

  const CreateAccountState({
    this.username = "",
    this.usernameTouched = false,
    this.validUsername = "",
    this.email = "",
    this.emailTouched = false,
    this.validEmail = "",
    this.password = "",
    this.passwordTouched = false,
    this.validPassword = "",
    this.obscurePassword = true,
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  CreateAccountState copyWith({
    String? username,
    bool? usernameTouched,
    String? validUsername,
    String? email,
    bool? emailTouched,
    String? validEmail,
    String? password,
    bool? passwordTouched,
    String? validPassword,
    bool? obscurePassword,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return CreateAccountState(
      username: username ?? this.username,
      usernameTouched: usernameTouched ?? this.usernameTouched,
      validUsername: validUsername ?? this.validUsername,
      email: email ?? this.email,
      emailTouched: emailTouched ?? this.emailTouched,
      validEmail: validEmail ?? this.validEmail,
      password: password ?? this.password,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      validPassword: validPassword ?? this.validPassword,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  bool validUser() {
    return validUsername.isEmpty &&
        validEmail.isEmpty &&
        validPassword.isEmpty &&
        username.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }
}

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit() : super(const CreateAccountState());

  void setUsername(String username) {
    String isUsernameValid = "";
    if (!RegExp(r"^[a-zA-Z0-9]+").hasMatch(username)) {
      isUsernameValid = "Invalid username";
    }
    //min 5 characters
    if (username.length < 5) {
      isUsernameValid = "Invalid length";
    }
    emit(
      state.copyWith(
        usernameTouched: true,
        username: username,
        validUsername: isUsernameValid,
      ),
    );
  }

  void setEmail(String email) {
    //validate email with a regex email
    bool isEmailValid =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

    emit(
      state.copyWith(
        emailTouched: true,
        email: email,
        validEmail: isEmailValid ? "" : "Invalid email",
      ),
    );
  }

  void setPassword(String password) {
    //validate password with a regex password
    bool isPasswordValid =
        RegExp(r"^[a-zA-Z0-9!@#$%^&*()]+").hasMatch(password);

    emit(
      state.copyWith(
        passwordTouched: true,
        password: password,
        validPassword: isPasswordValid ? "" : "Invalid password",
      ),
    );
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
