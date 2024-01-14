import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import '../../domain/services/users_service.dart';

class GenderState {
  final String gender;

  GenderState({
    required this.gender,
  });

  GenderState copyWith({
    String? gender,
  }) {
    return GenderState(
      gender: gender ?? this.gender,
    );
  }
}

class GenderCubit extends Cubit<GenderState> {
  final AuthenticationService authenticationService;
  final UsersService usersService;
  GenderCubit(
    this.authenticationService,
    this.usersService,
  ) : super(GenderState(gender: 'Rather Not Say'));

  void setGender(String gender) {
    String genderString = "";
    switch (gender) {
      case "0":
        genderString = "Non Binary";
        break;
      case "1":
        genderString = "Rather Not Say";
        break;
      case "2":
        genderString = "Male";
        break;
      case "3":
        genderString = "Female";
        break;
    }
    emit(state.copyWith(gender: genderString));
  }

  void persistGender() async {
    VestaUser? user = await authenticationService.getCurrentUserOrNull();
    if (user == null) {
      await authenticationService.signOut();
    } else {
      user = user.copyWith(gender: state.gender);
      await usersService.update(user);
    }
  }
}
