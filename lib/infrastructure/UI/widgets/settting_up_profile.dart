import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../application/cubit/setup_profile_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';

class SettingUpProfile extends StatelessWidget {
  const SettingUpProfile({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle selectedStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontFamily: 'M PLUS 1',
      fontWeight: FontWeight.w600,
      letterSpacing: 0.24,
    );

    final TextStyle unselectedStyle = TextStyle(
      color: const Color(0xFFCDCDCD).withOpacity(0.20),
      fontSize: 22,
      fontFamily: 'M PLUS 1',
      fontWeight: FontWeight.w400,
      letterSpacing: 1.10,
    );
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<VestaAppCubit>().setPage(
                VestaPages.selectGender,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Setting Up ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'M PLUS 1',
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.24,
                              ),
                            ),
                            TextSpan(
                              text: 'Your Profile',
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
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enter ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: 'age',
                              style: TextStyle(
                                color: Color(0xFF37A2E7),
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: ', ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: 'height',
                              style: TextStyle(
                                color: Color(0xFF37A2E7),
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: ', and ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: 'weight',
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
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Age',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 0.07,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  Expanded(
                                    child: WheelChooser.custom(
                                      startPosition: context.select(
                                              (SetupProfileCubit c) =>
                                                  c.state.age) -
                                          18,
                                      onValueChanged: (a) => context
                                          .read<SetupProfileCubit>()
                                          .setAge(a + 18),
                                      children: [
                                        ...List.generate(
                                          80,
                                          (index) => Text("${index + 18}",
                                              style: context.select(
                                                (SetupProfileCubit c) =>
                                                    c.state.age == index + 18
                                                        ? selectedStyle
                                                        : unselectedStyle,
                                              )),
                                        ).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Height',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 0.07,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  Expanded(
                                    child: WheelChooser.custom(
                                      startPosition: context
                                          .select(
                                            (SetupProfileCubit c) =>
                                                c.state.height * 12 - 48,
                                          )
                                          .toInt(),
                                      onValueChanged: (a) => context
                                          .read<SetupProfileCubit>()
                                          .setHeight((a + 48) / 12),
                                      children: [
                                        ...List.generate(
                                          37, // This will generate heights from 4'0'' to 7'0''
                                          (index) {
                                            final feet = (index + 48) ~/ 12;
                                            final inches = (index + 48) % 12;
                                            return Text(
                                              "$feet' $inches''",
                                              style: context
                                                          .select(
                                                            (SetupProfileCubit
                                                                    c) =>
                                                                c.state.height *
                                                                    12 -
                                                                48,
                                                          )
                                                          .toInt() ==
                                                      index
                                                  ? selectedStyle
                                                  : unselectedStyle,
                                            );
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Weight',
                                    style: TextStyle(
                                      color: Color(0xFF37A2E7),
                                      fontSize: 17,
                                      fontFamily: 'SF Pro Text',
                                      fontWeight: FontWeight.w700,
                                      height: 0.07,
                                      letterSpacing: 0.85,
                                    ),
                                  ),
                                  Expanded(
                                    child: WheelChooser.custom(
                                      startPosition: context
                                              .select(
                                                (SetupProfileCubit c) =>
                                                    c.state.weight,
                                              )
                                              .toInt() -
                                          100,
                                      onValueChanged: (a) => context
                                          .read<SetupProfileCubit>()
                                          .setWeight((a + 100).toDouble()),
                                      children: [
                                        ...List.generate(
                                          151, // This will generate weights from 100 to 250 kg
                                          (index) {
                                            final weight = index + 100;
                                            return Text(
                                              "$weight",
                                              style: context
                                                          .select(
                                                            (SetupProfileCubit
                                                                    c) =>
                                                                c.state.weight,
                                                          )
                                                          .toInt() ==
                                                      weight
                                                  ? selectedStyle
                                                  : unselectedStyle,
                                            );
                                          },
                                        ).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      VestaOutlineButton(
                        onPressed: () {
                          context.read<SetupProfileCubit>().persistGender();
                          context
                              .read<VestaAppCubit>()
                              .setPage(VestaPages.editAddress);
                        },
                        buttonText: 'Next',
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    //GO BACK TO HEALTH KIT
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.selectGender,
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
