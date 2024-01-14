import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/vesta_app_cubit.dart';
import 'connect_health_kit.dart';
import 'dashboard.dart';
import 'getting_started.dart';
import 'select_gender.dart';

class VestaHome extends StatelessWidget {
  const VestaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VestaAppCubit, VestaAppState>(
      builder: (context, state) {
        Widget child = Container();
        switch (state.page) {
          case VestaPages.getStarted:
            child = const GettingStarted();
            break;
          case VestaPages.connectToHealthKit:
            child = const ConnectHealthKit();
            break;
          case VestaPages.dashboard:
            child = const Dashboard();
            break;
          case VestaPages.selectGender:
            child = const SelectGender();
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
