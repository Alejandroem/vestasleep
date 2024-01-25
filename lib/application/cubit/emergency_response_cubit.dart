import 'package:flutter_bloc/flutter_bloc.dart';

class EmergencyResponseCubit extends Cubit<bool> {
  EmergencyResponseCubit() : super(false);

  void setEmergencyResponse(bool isEmergencyResponse) {
    emit(isEmergencyResponse);
  }
}
