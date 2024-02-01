import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            ElevatedButton(
              child: Text("Request permissions"),
              onPressed: () {
                context
                    .read<NotificationsService>()
                    .requestNotificationPermissions();
              },
            ),
            ElevatedButton(
              child: Text("Send local notification"),
              onPressed: () {
                //set a timer
                context
                    .read<NotificationsService>()
                    .sendLocalNotification("Test", "This is a test");
                Timer t = Timer(
                  const Duration(seconds: 5),
                  () {
                    context
                        .read<NotificationsService>()
                        .sendLocalNotification("Test", "This is a test");
                  },
                );
              },
            ),
            ElevatedButton(
              child: Text("Send message to test alex"),
              onPressed: () {
                context
                    .read<NotificationsService>()
                    .sendPhoneNotificationToContacts(
                        "Mensaje de prueba", "Te amo mi amor llego esto?", [
                  VestaContact(
                    name: "Alex",
                    email: "Alexalejadroem@gmail.com",
                    phone: "+595971722855",
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
