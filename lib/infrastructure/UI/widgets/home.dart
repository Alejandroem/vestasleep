import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/heart_rate/heart_rate_bloc.dart';
import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/create_account_cubit.dart';
import '../../../application/cubit/forgot_password_cubit.dart';
import '../../../application/cubit/login_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/health_service.dart';
import '../../../domain/services/notifications_service.dart';
import '../../../domain/services/usernames_service.dart';
import '../../../domain/services/users_service.dart';
import 'choose_auth_method.dart';
import 'create_account.dart';
import 'forgot_password.dart';
import 'landing.dart';
import 'login.dart';
import 'terms_and_privacy.dart';
import 'vesta_home.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        if (state.status == Status.authenticated) {
          context.read<HeartRateBloc>().add(
                StartMonitoringHeartRate(),
              );

          //request permissions for health data
          context.read<HealthService>().requestPermissions();

          //request permissions for notifications
          context.read<NotificationsService>().requestNotificationPermissions();
        }
      },
      builder: (context, state) {
        Widget child = Container();
        switch (state.status) {
          case Status.justLanded:
            child = const Landing();
            break;
          case Status.choosingAuthenticationMethod:
            child = const ChooseAuthMethod();
            break;
          case Status.creatingAccount:
            child = BlocProvider<CreateAccountCubit>(
              create: (context) => CreateAccountCubit(
                context.read<AuthenticationService>(),
                context.read<UsersService>(),
                context.read<UserNamesService>(),
              ),
              child: const CreateAccount(),
            );
            break;
          case Status.loggingIn:
            child = BlocProvider(
              create: (context) => LoginCubit(
                context.read<AuthenticationService>(),
              ),
              child: const Login(),
            );
            break;
          case Status.resettingPassword:
            child = BlocProvider(
              create: (context) => ForgotPasswordCubit(
                context.read<AuthenticationService>(),
              ),
              child: const ForgotPassword(),
            );
            break;
          case Status.readingTosAndPp:
            child = const TermsAndPrivacy();
            break;
          case Status.authenticating:
            break;
          case Status.authenticated:
            child = const VestaHome();
            break;
          default:
            child = const Landing();
            break;
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
