import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/alarm/alarm_bloc.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vesta',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'M PLUS 1',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
        ),
        backgroundColor: const Color(0xff1B1464),
      ),
      backgroundColor: const Color(0xff1B1464),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [
              Color(0xFF14103F),
              Color(0x02161B26),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<AlarmBloc, AlarmState>(
                  builder: (context, state) {
                    if (state is WaitingToNotifyContacts) {
                      //Show alert with icon and a button to disarm the alarm
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                    if (state is WaitingToNotifyEmergencyServices) {
                      //Show alert with icon and a button to disarm the alarm
                      return Column(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                    if (state is EmergencyResponseTriggered) {
                      return Column(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
