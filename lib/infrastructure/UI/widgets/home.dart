import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/create_account_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/users_service.dart';
import 'choose_auth_method.dart';
import 'create_account.dart';
import 'landing.dart';
import 'vesta_home.dart';

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
            child = const ChooseAuthMethod();
          case Status.creatingAccount:
            child = BlocProvider<CreateAccountCubit>(
              create: (context) => CreateAccountCubit(
                context.read<AuthenticationService>(),
                context.read<UsersService>(),
              ),
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
            child = const VestaHome();
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
