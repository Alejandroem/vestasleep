import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';
import 'landing.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        switch (state.status) {
          case Status.justLanded:
            return Landing();
          case Status.choosingAuthenticationMethod:
          // TODO: Handle this case.
          case Status.creatingAccount:
          // TODO: Handle this case.
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
        return const Scaffold();
      },
    );
  }
}
