import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/create_account_cubit.dart';
import 'choose_authentication_method.dart';
import 'create_account.dart';
import 'landing.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        Widget child = Container();
        switch (state.status) {
          case Status.justLanded:
            child = const Landing();
          case Status.choosingAuthenticationMethod:
            child = const ChooseAuthenticationMethod();
          case Status.creatingAccount:
            child = BlocProvider<CreateAccountCubit>(
              create: (context) => CreateAccountCubit(),
              child: const CreateAccount(),
            );
          case Status.loggingIn:
          // TODO: Handle this case.
          case Status.resettingPassword:
          // TODO: Handle this case.
          case Status.readingTosAndPp:
          // TODO: Handle this case.
          case Status.authenticating:
          // TODO: Handle this case.
          case Status.authenticated:
          // TODO: Handle this case.
        }
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}

mixin CreateAccountState {}
