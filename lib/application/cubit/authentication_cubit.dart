import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/authentication_service.dart';

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
  AuthenticationService authenticationService;
  StreamSubscription? authStateChangesSubscription;
  AuthenticationCubit(
    this.authenticationService,
  ) : super(AuthenticationState()) {
    //We won't subscribe if we are already subscribed
    authStateChangesSubscription ??=
        authenticationService.authStateChanges.listen((authenticated) {
      if (authenticated) {
        emit(state.copyWith(status: Status.authenticated));
      } else {
        emit(state.copyWith(status: Status.justLanded));
      }
    });
  }

  void setStatus(Status status) {
    emit(state.copyWith(status: status));
  }

  void setErrorMessage(String errorMessage) {
    emit(state.copyWith(errorMessage: errorMessage));
  }

  void logOut() async {
    await authenticationService.signOut();
  }
}
