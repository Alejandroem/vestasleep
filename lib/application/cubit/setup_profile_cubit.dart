import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import '../../domain/services/users_service.dart';

class SetupProfileState {
  final int age;
  final double weight;
  final double height;

  SetupProfileState({
    required this.age,
    required this.weight,
    required this.height,
  });

  SetupProfileState copyWith({
    int? age,
    double? weight,
    double? height,
  }) {
    return SetupProfileState(
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }
}

class SetupProfileCubit extends Cubit<SetupProfileState> {
  final AuthenticationService authenticationService;
  final UsersService usersService;
  SetupProfileCubit(
    this.authenticationService,
    this.usersService,
  ) : super(
          SetupProfileState(
            age: 25,
            weight: 410,
            height: 5.0,
          ),
        );

  void setAge(int age) {
    emit(state.copyWith(age: age));
  }

  void setWeight(double weight) {
    emit(state.copyWith(weight: weight));
  }

  void setHeight(double height) {
    emit(state.copyWith(height: height));
  }

  void persistGender() async {
    VestaUser? user = await authenticationService.getCurrentUserOrNull();
    if (user == null) {
      await authenticationService.signOut();
    } else {
      user = user.copyWith(
        age: state.age,
        weight: state.weight,
        height: state.height,
      );
      await usersService.update(user);
    }
  }
}
