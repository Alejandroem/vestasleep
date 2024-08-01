import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/personal_safety_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';

class PersonalSafety extends StatelessWidget {
  const PersonalSafety({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<VestaAppCubit>().setPage(
                VestaPages.enableEmergencyResponse,
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 100,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Personal ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'Safety',
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
                        const SizedBox(
                          height: 20,
                        ),
                        SvgPicture.asset(
                          'assets/svg/personal_safety.svg',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Please confirm each of the following: ',
                          style: TextStyle(
                            color: Color(0xFF37A2E7),
                            fontSize: 17,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.85,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vesta Sleep',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' does not\nshare your information.',
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
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PersonalSafetyCubit>()
                                    .toggleSafety(0);
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const ShapeDecoration(
                                  shape: OvalBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF37A2E7)),
                                  ),
                                ),
                                child: BlocBuilder<PersonalSafetyCubit,
                                    List<bool>>(
                                  builder: (context, state) {
                                    if (state[0]) {
                                      return SvgPicture.asset(
                                        'assets/svg/personal_safety_check.svg',
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vesta Sleep',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' does not\nguarantee it will save your life.',
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
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PersonalSafetyCubit>()
                                    .toggleSafety(1);
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const ShapeDecoration(
                                  shape: OvalBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF37A2E7)),
                                  ),
                                ),
                                child: BlocBuilder<PersonalSafetyCubit,
                                    List<bool>>(
                                  builder: (context, state) {
                                    if (state[1]) {
                                      return SvgPicture.asset(
                                        'assets/svg/personal_safety_check.svg',
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vesta Sleep',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'does not treat,\nnor diagnose. This is not\nmeant to replace or substitute\nmedical care.',
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
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PersonalSafetyCubit>()
                                    .toggleSafety(2);
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const ShapeDecoration(
                                  shape: OvalBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF37A2E7)),
                                  ),
                                ),
                                child: BlocBuilder<PersonalSafetyCubit,
                                    List<bool>>(
                                  builder: (context, state) {
                                    if (state[2]) {
                                      return SvgPicture.asset(
                                        'assets/svg/personal_safety_check.svg',
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Vesta Sleep',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' charts and\nnumbers are estimates.',
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
                            ),
                            InkWell(
                              onTap: () {
                                context
                                    .read<PersonalSafetyCubit>()
                                    .toggleSafety(3);
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: const ShapeDecoration(
                                  shape: OvalBorder(
                                    side: BorderSide(
                                        width: 1, color: Color(0xFF37A2E7)),
                                  ),
                                ),
                                child: BlocBuilder<PersonalSafetyCubit,
                                    List<bool>>(
                                  builder: (context, state) {
                                    if (state[3]) {
                                      return SvgPicture.asset(
                                        'assets/svg/personal_safety_check.svg',
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<PersonalSafetyCubit, List<bool>>(
                            builder: (context, state) {
                          return VestaOutlineButton(
                            enabled: state.every((element) => element == true),
                            onPressed: () {
                              // context
                              //     .read<ContactsCubit>()
                              //     .submit();
                              context.read<VestaAppCubit>().setPage(
                                    VestaPages.done,
                                  );
                            },
                            buttonText: 'Next',
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    //GO BACK TO HEALTH KIT
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.enableEmergencyResponse,
                        );
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
