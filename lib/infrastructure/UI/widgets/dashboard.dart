import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/alarm/alarm_bloc.dart';
import '../../../application/cubit/authentication_cubit.dart';
import '../../../domain/models/contact.dart';
import '../../../domain/services/notifications_service.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vesta'),
      ),
      body: Center(
        child: Column(
          children: [
            BlocBuilder<AlarmBloc, AlarmState>(
              builder: (context, state) {
                if (state is WaitingToNotifyContacts) {
                  //Show alert with icon and a button to disarm the alarm
                  return Column(
                    children: [
                      Text('Time left: ${state.timeLeft}'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AlarmBloc>().add(DisarmAlarm());
                        },
                        child: const Text(
                            'Disarm Alarm or we will notify your contacts'),
                      ),
                    ],
                  );
                }
                if (state is WaitingToNotifyEmergencyServices) {
                  //Show alert with icon and a button to disarm the alarm
                  return Column(
                    children: [
                      Text('Time left: ${state.timeLeft}'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AlarmBloc>().add(DisarmAlarm());
                        },
                        child: const Text(
                            'Disarm Alarm or we will call emergency services'),
                      ),
                    ],
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
            ElevatedButton(
              child: const Text("Send local notification"),
              onPressed: () {
                //set a timer
                context
                    .read<NotificationsService>()
                    .sendLocalNotification("Test", "This is a test");
              },
            ),
            ElevatedButton(
              child: const Text("Send message to test alex"),
              onPressed: () {
                context
                    .read<NotificationsService>()
                    .sendPhoneNotificationToContacts(
                        "Mensaje de prueba", "Te amo mi amor llego esto?", [
                  VestaContact(
                    name: "Alex",
                    email: "Alexalejadroem@gmail.com",
                    phone: "+595971307111",
                  ),
                ]);
              },
            ),
            const Text('Vesta'),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationCubit>().logOut();
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
