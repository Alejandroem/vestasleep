import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalSafetyCubit extends Cubit<List<bool>> {
  PersonalSafetyCubit() : super([false, false, false, false]);

  void changeSafety(int index, bool value) {
    List<bool> list = state;
    list[index] = value;
    emit(list);
  }

  void toggleSafety(int i) {
    List<bool> list = state;
    list[i] = !list[i];
    emit(List.from(list));
  }


}
