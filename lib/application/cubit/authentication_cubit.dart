import 'package:flutter_bloc/flutter_bloc.dart';

enum Status {
  justLanded,
  choosingAuthenticationMethod,
  creatingAccount,
  loggingIn,
  resettingPassword,
  readingTosAndPp,
  authenticating,
  authenticated,
}

class AuthenticationState {
  final Status status;
  final String? errorMessage;

  AuthenticationState({
    this.status = Status.justLanded,
    this.errorMessage,
  });

  AuthenticationState copyWith({
    Status? status,
    String? errorMessage,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationState());

  void setStatus(Status status) {
    emit(state.copyWith(status: status));
  }

  void setErrorMessage(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }
}
