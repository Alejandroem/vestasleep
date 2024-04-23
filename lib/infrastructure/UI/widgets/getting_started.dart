import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/vesta_app_cubit.dart';
import '../../../domain/services/authentication_service.dart';
import '../common/vesta_outline_button.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          context.read<AuthenticationService>().signOut();
        },
      ),
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          //cant pop
          return;
        },
        child: Container(
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
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 100,
                    left: 20,
                    right: 20,
                    bottom: MediaQuery.of(context).size.height * 0.2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Getting ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'M PLUS 1',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.24,
                              ),
                            ),
                            TextSpan(
                              text: 'Started ',
                              style: TextStyle(
                                color: Color(0xFF37A2E7),
                                fontSize: 24,
                                fontFamily: 'M PLUS 1',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.24,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Let\'s get',
                              style: TextStyle(
                                color: Color(0xFF37A2E7),
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' to know your sleeping habits, tell us a few things about yourself.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      VestaOutlineButton(
                        onPressed: () {
                          context
                              .read<VestaAppCubit>()
                              .setPage(VestaPages.connectToHealthKit);
                        },
                        buttonText: 'Next',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
