import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/alarm/alarm_bloc.dart';

class AlarmFlow extends StatelessWidget {
  const AlarmFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlarmBloc, AlarmState>(
      builder: (context, state) {
        Widget widget = const SizedBox.shrink();
        if (state is WaitingToNotifyContacts) {
          //Show alert with icon and a button to disarm the alarm
          widget = waitingToNotifyContacts(state, context);
        }
        if (state is WaitingToNotifyEmergencyServices) {
          //Show alert with icon and a button to disarm the alarm
          widget = waitingToTriggerEmergencyResponse(state, context);
        }
        if (state is EmergencyResponseTriggered) {
          widget = emergencyResponseTriggered(context);
        }
        return AnimatedSwitcher(
          key: UniqueKey(),
          duration: const Duration(seconds: 1),
          reverseDuration: const Duration(seconds: 1),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: widget,
        );
      },
    );
  }

  Column emergencyResponseTriggered(BuildContext context) {
    return Column(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Emergency response triggered!',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Emergency response has been triggered!.\nPlease wait for help to arrive.',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xffFF0000),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextButton(
              onPressed: () {
                context.read<AlarmBloc>().add(DisarmAlarm());
              },
              child: const Text(
                'Disarm Alarm, I am fine!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Image.asset(
          'assets/images/emergency.png',
        ),
      ],
    );
  }

  Column waitingToTriggerEmergencyResponse(
      WaitingToNotifyEmergencyServices state, BuildContext context) {
    return Column(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/contacts_warning.png',
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Unusual Heart Rate Detected',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Your contacts have been notified!.\nYou have ${state.timeLeft} seconds to disarm the alarm or we will Contact emergency services.',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xffFF0000),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextButton(
              onPressed: () {
                context.read<AlarmBloc>().add(DisarmAlarm());
              },
              child: const Text(
                'Disarm Alarm, I am fine!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column waitingToNotifyContacts(
      WaitingToNotifyContacts state, BuildContext context) {
    return Column(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/images/warning.png',
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Unusual Heart Rate Detected',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            fontSize: 24,
            letterSpacing: 0.24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Please check your health data, your heart rate is unusual.\nYou have ${state.timeLeft} seconds to disarm the alarm or we will trigger the Vesta alarm.',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Container(
            height: 55,
            decoration: const BoxDecoration(
              color: Color(0xffFF0000),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: TextButton(
              onPressed: () {
                context.read<AlarmBloc>().add(DisarmAlarm());
              },
              child: const Text(
                'Disarm Alarm, I am fine!',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
