import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import '../../domain/services/users_service.dart';

class EmergencyResponseCubit extends Cubit<bool> {
  final AuthenticationService authenticationService;
  final UsersService usersService;

  EmergencyResponseCubit(
    this.authenticationService,
    this.usersService,
  ) : super(false);

  void setEmergencyResponse(bool isEmergencyResponse) {
    emit(isEmergencyResponse);
  }

  void submit() async {
    VestaUser? user = await authenticationService.getCurrentUserOrNull();

    if (user == null) {
      await authenticationService.signOut();
    } else {
      await usersService.update(
        user.copyWith(
          emergencyResponseEnabled: state,
        ),
      );
    }
  }
}
