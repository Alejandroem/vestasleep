import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../common/vesta_outline_button.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: Container(
        width: double.infinity,
        height: double.maxFinite,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/svg/vesta_icon.svg"),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Life-Saving technology ',
                      style: TextStyle(
                        color: Color(0xFF37A2E7),
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.85,
                      ),
                    ),
                    TextSpan(
                      text: 'that watches you when you can’t.',
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
            ),
            const SizedBox(height: 20),
            VestaOutlineButton(
              onPressed: () {
                context.read<AuthenticationCubit>().setStatus(
                      Status.choosingAuthenticationMethod,
                    );
              },
              buttonText: 'Get Started',
            ),
          ],
        ),
      ),
    );
  }
}
