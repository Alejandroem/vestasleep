import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/onboarding_cubit.dart';
import 'dashboard.dart';
import 'getting_started.dart';

class VestaHome extends StatelessWidget {
  const VestaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VestaAppCubit, VestaAppState>(
      builder: (context, state) {
        Widget child = Container();
        switch (state.page) {
          case CurrentPage.getStarted:
            child = const GettingStarted();
            break;
          case CurrentPage.connectToHealthKit:
            child = const Text('Connect to HealthKit');
            break;
          case CurrentPage.dashboard:
            child = const Dashboard();
            break;
        }
        //animated child
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
