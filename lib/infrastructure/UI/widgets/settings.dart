import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/models/vesta_user.dart';
import '../../../domain/services/authentication_service.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VestaUser?>(
        future: context.read<AuthenticationService>().getCurrentUserOrNull(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('An error occurred'),
            );
          }
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'M PLUS 1',
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    letterSpacing: 0.24,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                snapshot.data!.username,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.85,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                snapshot.data!.email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.85,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/images/card_background.png',
              ),
            ],
          );
        });
  }
}
