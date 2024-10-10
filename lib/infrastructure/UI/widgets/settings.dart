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
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/card_background.png',
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 32, 20, 32),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E9FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.85,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () {
                                context.read<AuthenticationService>().signOut();
                              },
                            ),
                            ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8E9FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              title: const Text(
                                'Delete Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.85,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () {
                                final userId = snapshot.data!.id;
                                context
                                    .read<AuthenticationService>()
                                    .deleteAccount(userId!);
                                context.read<AuthenticationService>().signOut();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
