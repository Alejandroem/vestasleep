import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';

class AllDone extends StatelessWidget {
  const AllDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<VestaAppCubit>().setPage(
                VestaPages.personalSafety,
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
                                text: 'All ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'Done',
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
                          height: 100,
                        ),
                        SvgPicture.asset(
                          'assets/svg/done.svg',
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        VestaOutlineButton(
                          onPressed: () {
                            context.read<VestaAppCubit>().setPage(
                                  VestaPages.dashboard,
                                );
                          },
                          buttonText: 'continue',
                        )
                      ],
                    ),
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    //GO BACK TO HEALTH KIT
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.personalSafety,
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
