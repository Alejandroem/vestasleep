import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/forgot_password_cubit.dart';

class TermsAndPrivacy extends StatelessWidget {
  const TermsAndPrivacy({super.key});

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
                const SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Terms & ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'Conditions',
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
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 305,
                          child: Text(
                            'These statements have not been evaluated by the Food and Drug Administration. These products are not intended to diagnose, treat, cure, or prevent any disease.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.85,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 311,
                          child: Text(
                            'Consult your physician before beginning any exercise or diet program.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.85,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 301,
                          child: Text(
                            'Prior to using these products or information, take them to your physician for approval.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.85,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 329,
                          child: Text(
                            'IN NO WAY SHOULD VESTA SLEEP WEB SITE AND Heart monitor BE CONSIDERED AS OFFERING MEDICAL ADVICE! THE CONTENT ON THE SITE IS PRESENTED IN SUMMARY FORM IS GENERAL IN NATURE IS PROVIDED FOR INFORMATIONAL PURPOSES ONLY. NEVER DISREGARD MEDICAL ADVICE OR DELAY IN SEEKING IT BECAUSE OF SOMETHING YOU HAVE READ ON THIS OR ANY OTHER SITE ON THE INTERNET!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.85,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: InkWell(
                      onTap: () {
                        context.read<AuthenticationCubit>().setStatus(
                              Status.creatingAccount,
                            );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/arrow_back.svg',
                            semanticsLabel: 'Vesta Logo',
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Back",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffFFFFFF),
                            ),
                          )
                        ],
                      ),
                    ),
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
