import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/health_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/health_service.dart';
import '../../../domain/services/usernames_service.dart';
import '../../../domain/services/users_service.dart';
import '../../services/firebase_authentication_service.dart';
import '../../services/firebase_vestausernames_service.dart';
import '../../services/firebase_vestausers_service.dart';
import '../../services/google_apple_health_service.dart';
import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vesta',
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
            create: (context) => GoogleAppleHealthService(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationCubit>(
              create: (context) => AuthenticationCubit(
                context.read<AuthenticationService>(),
              ),
            ),
            BlocProvider<VestaAppCubit>(
              create: (context) => VestaAppCubit(),
            ),
            BlocProvider<HealthCubit>(
              create: (context) => HealthCubit(
                context.read<HealthService>(),
              ),
            ),
          ],
          child: const Home(),
        ),
      ),
    );
  }
}
