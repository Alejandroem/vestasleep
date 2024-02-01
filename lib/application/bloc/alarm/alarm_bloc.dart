import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/contact.dart';
import '../../../domain/models/vesta_user.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/users_service.dart';

part 'alarm_events.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AuthenticationService authenticationService;
  UsersService usersService;
  Timer? _alarmTimer;
  Timer? _emergencyResponseTimer;
  //Alarm loop goes as follows
  //We give T-0 -> T-30 seconds for the user to answer
  //We give T-30 -> T-60 seconds for the responders to answer
  //We give T-0 -> T-60 seconds to trigger emergency response

  AlarmBloc(
    this.authenticationService,
    this.usersService,
  ) : super(AlarmDisarmed()) {
    on<TriggerAlarm>(_onTriggerAlarm);
    on<DisarmAlarm>(_onDisarmAlarm);
    on<TriggerContactsResponse>(_onTriggerContactsResponse);
    on<TriggerEmergencyResponse>(_onTriggerEmergencyResponse);
  }

  //Or when the user disarms the alarm
  //Method called when a responder aknowledges the alarm
  FutureOr<void> _onDisarmAlarm(DisarmAlarm event, Emitter<AlarmState> emit) {
    _alarmTimer?.cancel();
    _alarmTimer = null;
    _emergencyResponseTimer?.cancel();
    _emergencyResponseTimer = null;
    emit(AlarmDisarmed());
  }

  Future<List<VestaContact>?> getUserContacts() async {
    VestaUser? authUser = await authenticationService.getCurrentUserOrNull();
    List<VestaContact>? contacts;
    if (authUser == null) {
      VestaUser? user = await usersService.read(authUser!.id!);
      contacts = user!.contacts;
    }
    return contacts;
  }

  FutureOr<void> _onTriggerAlarm(
      TriggerAlarm event, Emitter<AlarmState> emit) async {
    List<VestaContact>? contacts = await getUserContacts();

    _alarmTimer ??= Timer(const Duration(seconds: 30), () {
      if (contacts != null) {
        add(TriggerContactsResponse(contacts));
      }
    });

    _emergencyResponseTimer ??= Timer(const Duration(seconds: 60), () {
      add(TriggerEmergencyResponse());
    });

    emit(AwaitingUserResponse());
  }

  FutureOr<void> _onTriggerContactsResponse(
      TriggerContactsResponse event, Emitter<AlarmState> emit) {
    if (state is AwaitingUserResponse) {
      //Send notification to contacts
      log('Sending notification to contacts');
      emit(AwaitResponderResponse(event.contacts));
    }
  }

  FutureOr<void> _onTriggerEmergencyResponse(
      TriggerEmergencyResponse event, Emitter<AlarmState> emit) {
    if (state is AwaitingUserResponse || state is AwaitResponderResponse) {
      //Call 911
      log('Calling 911');
    }
  }
}
