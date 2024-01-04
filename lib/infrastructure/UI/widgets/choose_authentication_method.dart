import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../common/vesta_outline_button.dart';

class ChooseAuthenticationMethod extends StatelessWidget {
  const ChooseAuthenticationMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<AuthenticationCubit>().setStatus(
                Status.justLanded,
              );
        },
        child: Container(
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
                        text: 'Log In ',
                        style: TextStyle(
                          color: Color(0xFF37A2E7),
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.85,
                        ),
                      ),
                      TextSpan(
                        text: 'or',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.85,
                        ),
                      ),
                      TextSpan(
                        text: ' create an account ',
                        style: TextStyle(
                          color: Color(0xFF37A2E7),
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.85,
                        ),
                      ),
                      TextSpan(
                        text: 'to get started',
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
                        Status.loggingIn,
                      );
                },
                buttonText: 'Log In',
              ),
              const SizedBox(height: 20),
              VestaOutlineButton(
                onPressed: () {
                  context.read<AuthenticationCubit>().setStatus(
                        Status.creatingAccount,
                      );
                },
                buttonText: 'Create Account',
              ),
              const SizedBox(height: 20),
              const Text(
                'Other sign in options',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.85,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
