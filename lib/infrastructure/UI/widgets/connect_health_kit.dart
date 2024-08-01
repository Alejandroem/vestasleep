import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/health_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';
import '../common/vesta_underlined_button.dart';

class ConnectHealthKit extends StatelessWidget {
  const ConnectHealthKit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HealthCubit, HealthState>(
      listener: (context, state) {
        if (state.hasPermission) {
          context.read<VestaAppCubit>().setPage(VestaPages.selectGender);
          //Show a toast that permission has been granted
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Permission has been granted for ${Platform.isIOS ? 'Apple Health Kit' : 'Google Fit'}'),
            ),
          );
        }
        if (state.permissionDeniedByUser) {
          context.read<VestaAppCubit>().setPage(VestaPages.selectGender);
          //Show a toast that permission has been denied
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Permission has been denied for ${Platform.isIOS ? 'Apple Health Kit' : 'Google Fit'}'),
            ),
          );
        }
      },
      child: Scaffold(
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
                      top: MediaQuery.of(context).size.height * 0.1,
                      left: 20,
                      right: 20,
                      bottom: MediaQuery.of(context).size.height * 0.15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Health ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'Kit',
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
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Please enable your ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.85,
                                ),
                              ),
                              TextSpan(
                                text: Platform.isIOS
                                    ? 'Apple Health Kit'
                                    : 'Google Fit',
                                style: const TextStyle(
                                  color: Color(0xFF37A2E7),
                                  fontSize: 17,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.85,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' to allow for more accurate data and get help ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.85,
                                ),
                              ),
                              const TextSpan(
                                text: 'in case of emergency.',
                                style: TextStyle(
                                  color: Color(0xFF37A2E7),
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
                        SvgPicture.asset(
                          Platform.isIOS
                              ? 'assets/svg/apple_health_kit.svg'
                              : 'assets/svg/google_fit.svg',
                          width: 200,
                          height: 200,
                        ),
                        VestaOutlineButton(
                          onPressed: () {
                            context.read<HealthCubit>().checkPermissions();
                          },
                          buttonText: 'Give Permission to Vesta',
                        ),
                        VestaUnderlinedButton(
                          color: const Color(0xff37A2E7),
                          onPressed: () {
                            context
                                .read<HealthCubit>()
                                .permissionDeniedByUser();
                            context
                                .read<VestaAppCubit>()
                                .setPage(VestaPages.selectGender);
                          },
                          text: 'Skip for Now',
                        ),
                      ],
                    ),
                  ),
                  VestaWhiteBackButton(
                    onPressed: () {
                      context
                          .read<VestaAppCubit>()
                          .setPage(VestaPages.getStarted);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
