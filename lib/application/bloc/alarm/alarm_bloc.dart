import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/contact.dart';
import '../../../domain/models/vesta_user.dart';
import '../../../domain/services/authentication_service.dart';
import '../../../domain/services/notifications_service.dart';
import '../../../domain/services/users_service.dart';

part 'alarm_events.dart';
part 'alarm_state.dart';

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  AuthenticationService authenticationService;
  UsersService usersService;
  NotificationsService notificationsService;
  Timer? _timerToConfirmPotentialProblem;
  Timer? _timerToContactEmergencyResponse;
  //Alarm loop goes as follows
  //We give T-0 -> T-30 seconds for the user to answer
  //We give T-30 -> T-60 seconds for the responders to answer
  //We give T-0 -> T-60 seconds to trigger emergency response

  AlarmBloc(
    this.authenticationService,
    this.usersService,
    this.notificationsService,
  ) : super(AlarmDisarmed()) {
    on<TriggerPotentialProblemAlarm>(_onTriggerAlarm);
    on<DisarmAlarm>(_onDisarmAlarm);
    on<TriggerContactsResponse>(_onTriggerContactsResponse);
    on<TriggerEmergencyResponse>(_onTriggerEmergencyResponse);
    on<UpdatePotentialProblemTimer>(_onUpdateUserResponseTime);
    on<UpdateEmergencyResponseTime>(_onUpdateEmergencyResponseTime);
  }

  //Or when the user disarms the alarm
  //Method called when a responder aknowledges the alarm
  FutureOr<void> _onDisarmAlarm(DisarmAlarm event, Emitter<AlarmState> emit) {
    _timerToConfirmPotentialProblem?.cancel();
    _timerToConfirmPotentialProblem = null;
    _timerToContactEmergencyResponse?.cancel();
    _timerToContactEmergencyResponse = null;
    notificationsService.stopAlarmSound();
    emit(AlarmDisarmed());
  }

  Future<List<VestaContact>?> getUserContacts() async {
    VestaUser? authUser = await authenticationService.getCurrentUserOrNull();
    log('Contacts: ${authUser?.contacts}');
    return authUser?.contacts;
  }

  FutureOr<void> _onTriggerAlarm(
      TriggerPotentialProblemAlarm event, Emitter<AlarmState> emit) async {
    //We check that the alarm is not already in the AwaitingUserResponse state
    log('Triggering alarm');
    if (state is WaitingToNotifyContacts &&
        _timerToConfirmPotentialProblem != null &&
        _timerToContactEmergencyResponse != null) {
      return;
    }
    emit(const WaitingToNotifyContacts(30));

    //Send local notification
    notificationsService.sendLocalNotification(
      'Vesta Alert',
      'You have a problem with your heart rate, please check on it. Or we will notify your contacts.',
    );

    //user has 30 seconds to disarm the alarm or it will trigger a contact to their contacts
    _timerToConfirmPotentialProblem ??=
        Timer.periodic(const Duration(seconds: 1), (timer) {
      log('Triggering contacts response. Timer tick: ${30 - timer.tick}');
      add(UpdatePotentialProblemTimer(30 - timer.tick));
      if (timer.tick == 30) {
        add(const TriggerContactsResponse());
      }
    });

    //user has 60 seconds to disarm his alarm or it will trigger an emergency response
    _timerToContactEmergencyResponse ??=
        Timer.periodic(const Duration(seconds: 1), (timer) {
      log('Triggering emergency response. Timer tick: ${60 - timer.tick}');
      if (timer.tick > 30) {
        add(UpdateEmergencyResponseTime(60 - timer.tick));
      }
      if (timer.tick == 60) {
        log('Triggering emergency response');
        add(TriggerEmergencyResponse());
      }
    });
  }

  FutureOr<void> _onTriggerContactsResponse(
      TriggerContactsResponse event, Emitter<AlarmState> emit) async {
    if (state is WaitingToNotifyContacts || state is AlarmDisarmed) {
      _timerToConfirmPotentialProblem?.cancel();
      _timerToConfirmPotentialProblem = null;
      log('Sending notification to user.');
      //Send notification to contacts
      VestaUser? user = await authenticationService.getCurrentUserOrNull();
      log('Sending notification to user.');
      await notificationsService.sendLocalNotification(
        'Vesta Alert',
        'Your contacts have been notified. Please Aknowledge the alarm. Or we will notify emergency services.',
      );

      //We start playing a sound to alert the user and we put the alarm in the AwaitingUserResponse state
      log('Playing alarm sound');
      notificationsService.playAlarmSound();

      log('Sending notification to contacts.');
      List<VestaContact>? contacts = await getUserContacts();
      if (contacts != null) {
        await notificationsService.sendPhoneNotificationToContacts(
          'Vesta Alert',
          'Your friend ${user?.username ?? ''}\nneeds help, he has triggered an alarm. Please check on him.',
          contacts,
        );
        emit(const WaitingToNotifyEmergencyServices(30));
      } else {
        log('No contacts found');
      }
    }
  }

  FutureOr<void> _onTriggerEmergencyResponse(
      TriggerEmergencyResponse event, Emitter<AlarmState> emit) {
    if (state is WaitingToNotifyContacts ||
        state is WaitingToNotifyEmergencyServices ||
        state is AlarmDisarmed) {
      _timerToContactEmergencyResponse?.cancel();
      _timerToContactEmergencyResponse = null;
      //Call 911
      log('Calling 911.');
      emit(const EmergencyResponseTriggered());
    }
  }

  FutureOr<void> _onUpdateUserResponseTime(
      UpdatePotentialProblemTimer event, Emitter<AlarmState> emit) {
    if (state is WaitingToNotifyContacts) {
      emit(WaitingToNotifyContacts(event.timeLeft));
    }
  }

  FutureOr<void> _onUpdateEmergencyResponseTime(
      UpdateEmergencyResponseTime event, Emitter<AlarmState> emit) {
    if (state is WaitingToNotifyEmergencyServices) {
      emit(WaitingToNotifyEmergencyServices(event.timeLeft));
    }
  }
}
