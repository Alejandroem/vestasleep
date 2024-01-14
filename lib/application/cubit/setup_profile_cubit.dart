import 'package:flutter_bloc/flutter_bloc.dart';

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
  SetupProfileCubit()
      : super(
          SetupProfileState(
            age: 25,
            weight: 125,
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
}
