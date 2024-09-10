import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vestasleep/application/heart_algo/sleep_Session/sleep_session_screen.dart';
import 'package:vestasleep/application/new_algo/sleep_score/sleep_score_screen.dart';
import 'package:vestasleep/application/session_heart_rate/sleep_session_heart_screen.dart';

import '../../../application/bloc/alarm/alarm_bloc.dart';
import '../../../application/bloc/heart_rate/heart_rate_bloc.dart';
import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/bottom_navigation_cubit.dart';
import '../../../application/cubit/health_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../../../constants.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/contacts_service.dart';
import '../../../domain/services/health_service.dart';
import '../../../domain/services/notifications_service.dart';
import '../../../domain/services/usernames_service.dart';
import '../../../domain/services/users_service.dart';
import '../../services/device_notifications_service.dart';
import '../../services/firebase_authentication_service.dart';
import '../../services/firebase_vestausernames_service.dart';
import '../../services/firebase_vestausers_service.dart';
import '../../services/google_apple_health_service.dart';
import '../../services/ios_android_contacts_service.dart';
import '../../services/mock_health_service.dart';
import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vesta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationService>(
            create: (context) => FirebaseAuthenticationService(),
          ),
          RepositoryProvider<UsersService>(
            create: (context) => FirebaseVestaUsersService(),
          ),
          RepositoryProvider<UserNamesService>(
            create: (context) => FirebaseVestaUserNamesService(),
          ),
          RepositoryProvider<HealthService>(
            create: (context) => USE_MOCK_HEALTH_DATA
                ? MockHealthService()
                : GoogleAppleHealthService(),
          ),
          RepositoryProvider<ContactsService>(
            create: (context) => IosAndroidContactsService(),
          ),
          RepositoryProvider<NotificationsService>(
            create: (context) => DeviceNotificationsService(),
          ),
        ],
        child: BlocProvider<AlarmBloc>(
          create: (context) => AlarmBloc(
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
            context.read<NotificationsService>(),
          ),
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationCubit>(
                create: (context) => AuthenticationCubit(
                  context.read<AuthenticationService>(),
                ),
              ),
              BlocProvider<VestaAppCubit>(
                create: (context) => VestaAppCubit(
                  context.read<AuthenticationService>(),
                ),
              ),
              BlocProvider<HealthCubit>(
                create: (context) => HealthCubit(
                  context.read<HealthService>(),
                ),
              ),
              BlocProvider<HeartRateBloc>(
                create: (context) => HeartRateBloc(
                  context.read<AlarmBloc>(),
                  context.read<HealthService>(),
                ),
              ),
              BlocProvider<BottomNavigationCubit>(
                create: (context) => BottomNavigationCubit(),
              ),
            ],
            child: Home(),
          ),
        ),
      ),
    );
  }
}
