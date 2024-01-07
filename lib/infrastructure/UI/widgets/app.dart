import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/users_service.dart';
import '../../services/firebase_authentication_service.dart';
import '../../services/firebase_vestausers_service.dart';
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
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationCubit>(
              create: (context) => AuthenticationCubit(
                context.read<AuthenticationService>(),
              ),
            ),
          ],
          child: const Home(),
        ),
      ),
    );
  }
}
