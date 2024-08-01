import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/forgot_password_cubit.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password reset instructions sent to email'),
            ),
          );
          context.read<AuthenticationCubit>().setStatus(
                Status.justLanded,
              );
        }
      },
      child: Scaffold(
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
                                Status.justLanded,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/forgot_password_text.svg',
                        semanticsLabel: 'Vesta Logo',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SvgPicture.asset(
                        'assets/svg/forgot_password_icon.svg',
                        semanticsLabel: 'Vesta Logo',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Enter your email below to receive your password ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.85,
                              ),
                            ),
                            TextSpan(
                              text: 'reset instructions',
                              style: TextStyle(
                                color: Color(0xFF37A2E7),
                                fontSize: 17,
                                fontFamily: 'SF Pro Text',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.85,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: 312,
                        height: 55,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Colors.transparent,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.85,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontFamily: 'SF Pro Text',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.85,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<ForgotPasswordCubit>()
                                .emailChanged(value);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                        builder: (context, state) {
                          return Container(
                            width: 311,
                            height: 55,
                            decoration: ShapeDecoration(
                              color: state.validForm()
                                  ? const Color(0xFF37A2E7)
                                  : const Color(0x4D37A2E7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: TextButton(
                              onPressed:
                                  state.validForm() && !state.isSubmitting
                                      ? () {
                                          context
                                              .read<ForgotPasswordCubit>()
                                              .submit();
                                        }
                                      : null,
                              child: state.isSubmitting
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Send Password',
                                      // ignore: unnecessary_const
                                      style: TextStyle(
                                        color: state.validForm()
                                            ? Colors.white
                                            : const Color(0x4DFFFFFF),
                                        fontSize: 17,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w700,
                                        height: 0.07,
                                        letterSpacing: 0.85,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthenticationCubit>().setStatus(
                                Status.justLanded,
                              );
                        },
                        child: const Text(
                          'Back to Homepage',
                          style: TextStyle(
                            color: Color(0xFF37A2E7),
                            fontSize: 17,
                            fontFamily: 'M PLUS 1',
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF37A2E7),
                            height: 0.07,
                            letterSpacing: 0.85,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
