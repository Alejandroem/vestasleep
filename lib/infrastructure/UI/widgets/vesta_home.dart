import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/contacts_cubit.dart';
import '../../../application/cubit/edit_address_cubit.dart';
import '../../../application/cubit/emergency_response_cubit.dart';
import '../../../application/cubit/gender_cubit.dart';
import '../../../application/cubit/setup_profile_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/contacts_service.dart';
import '../../../domain/services/users_service.dart';
import 'connect_health_kit.dart';
import 'dashboard.dart';
import 'edit_address.dart';
import 'emergency_contacts.dart';
import 'emergency_response.dart';
import 'getting_started.dart';
import 'personal_safety.dart';
import 'select_gender.dart';
import 'settting_up_profile.dart';

class VestaHome extends StatelessWidget {
  const VestaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GenderCubit>(
          create: (context) => GenderCubit(
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
          ),
        ),
        BlocProvider<SetupProfileCubit>(
          create: (context) => SetupProfileCubit(
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
          ),
        ),
        BlocProvider(
          create: (context) => EditAddressCubit(
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
          ),
        ),
        BlocProvider(
          create: (context) => ContactsCubit(
            context.read<ContactsService>(),
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
          ),
        ),
        BlocProvider(
          create: (context) => EmergencyResponseCubit(
            context.read<AuthenticationService>(),
            context.read<UsersService>(),
          ),
        ),
      ],
      child: BlocBuilder<VestaAppCubit, VestaAppState>(
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
              break;
            case VestaPages.settingUpProfile:
              child = const SettingUpProfile();
              break;
            case VestaPages.editAddress:
              child = const EditAddress();
              break;
            case VestaPages.editContacts:
              child = const EmergencyContacts();
              break;
            case VestaPages.enableEmergencyResponse:
              child = const EmergencyResponse();
              break;
            case VestaPages.personalSafety:
              child = const PersonalSafety();
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
      ),
    );
  }
}
