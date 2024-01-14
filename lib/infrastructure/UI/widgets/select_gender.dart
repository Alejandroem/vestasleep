import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

import '../../../application/cubit/gender_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';

class SelectGender extends StatelessWidget {
  const SelectGender({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle selectedStyle = TextStyle(
      color: Color(0xFF37A2E7),
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
                VestaPages.connectToHealthKit,
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
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 100,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'What is your ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'M PLUS 1',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.24,
                          ),
                        ),
                        TextSpan(
                          text: 'Gender?',
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
                ),
                WheelChooser.custom(
                  startPosition: 1,
                  onValueChanged: (a) =>
                      context.read<GenderCubit>().setGender(a.toString()),
                  children: <Widget>[
                    Text(
                      "Non Binary",
                      style: context.select((GenderCubit c) =>
                          c.state.gender == "Non Binary"
                              ? selectedStyle
                              : unselectedStyle),
                    ),
                    Text(
                      "Rather Not Say",
                      style: context.select((GenderCubit c) =>
                          c.state.gender == "Rather Not Say"
                              ? selectedStyle
                              : unselectedStyle),
                    ),
                    Text(
                      "Male",
                      style: context.select((GenderCubit c) =>
                          c.state.gender == "Male"
                              ? selectedStyle
                              : unselectedStyle),
                    ),
                    Text(
                      "Female",
                      style: context.select((GenderCubit c) =>
                          c.state.gender == "Female"
                              ? selectedStyle
                              : unselectedStyle),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 100,
                  child: VestaOutlineButton(
                    onPressed: () {
                      context.read<GenderCubit>().persistGender();
                      context
                          .read<VestaAppCubit>()
                          .setPage(VestaPages.settingUpProfile);
                    },
                    buttonText: 'Next',
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    //GO BACK TO HEALTH KIT
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.connectToHealthKit,
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
