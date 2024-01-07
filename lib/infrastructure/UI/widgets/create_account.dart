import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/authentication_cubit.dart';
import '../../../application/cubit/create_account_cubit.dart';

class CreateAccount extends StatelessWidget {
  const CreateAccount({super.key});

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
              SvgPicture.asset(
                "assets/svg/vesta_icon.svg",
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 30),
              //USERNAME
              Container(
                width: 311,
                height: 60,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.699999988079071),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon:
                          BlocBuilder<CreateAccountCubit, CreateAccountState>(
                        builder: (context, state) {
                          if (state.validatingUsername) {
                            return const Padding(
                              padding: EdgeInsets.all(6),
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          if (state.usernameTouched &&
                              state.validUsername == "") {
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                "assets/svg/done_icon.svg",
                              ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/svg/username_icon.svg",
                        ),
                      ),
                      hintText: "Username",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.85,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (String value) {
                      context.read<CreateAccountCubit>().setUsername(value);
                    },
                  ),
                ),
              ),
              //text with errors
              BlocBuilder<CreateAccountCubit, CreateAccountState>(
                builder: (context, state) {
                  if (state.usernameTouched && state.validUsername != "") {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        12,
                        4,
                        12,
                        4,
                      ),
                      child: Text(
                        state.validUsername,
                        style: const TextStyle(
                          color: Color(0xFFE02020),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.70,
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 30);
                },
              ),
              //EMAIL
              Container(
                width: 311,
                height: 60,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.699999988079071),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon:
                          BlocBuilder<CreateAccountCubit, CreateAccountState>(
                        builder: (context, state) {
                          if (state.emailTouched && state.validEmail == "") {
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                "assets/svg/done_icon.svg",
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/svg/email_icon.svg",
                        ),
                      ),
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        height: 0.07,
                        letterSpacing: 0.85,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (String value) {
                      context.read<CreateAccountCubit>().setEmail(value);
                    },
                  ),
                ),
              ),
              BlocBuilder<CreateAccountCubit, CreateAccountState>(
                builder: (context, state) {
                  if (state.emailTouched && state.validEmail != "") {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        12,
                        4,
                        12,
                        4,
                      ),
                      child: Text(
                        state.validEmail,
                        style: const TextStyle(
                          color: Color(0xFFE02020),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.70,
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 30);
                },
              ),
              Container(
                width: 311,
                height: 60,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.699999988079071),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon:
                          BlocBuilder<CreateAccountCubit, CreateAccountState>(
                        builder: (context, state) {
                          if (state.passwordTouched &&
                              state.validPassword == "") {
                            return Padding(
                              padding: const EdgeInsets.all(6),
                              child: SvgPicture.asset(
                                "assets/svg/done_icon.svg",
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/svg/password_icon.svg",
                        ),
                      ),
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        height: 0.07,
                        letterSpacing: 0.85,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                    ),
                    onChanged: (String value) {
                      context.read<CreateAccountCubit>().setPassword(value);
                    },
                  ),
                ),
              ),
              BlocBuilder<CreateAccountCubit, CreateAccountState>(
                builder: (context, state) {
                  if (state.passwordTouched && state.validPassword != "") {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(
                        12,
                        4,
                        12,
                        4,
                      ),
                      child: Text(
                        state.validPassword,
                        style: const TextStyle(
                          color: Color(0xFFE02020),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.70,
                        ),
                      ),
                    );
                  }
                  return const SizedBox(height: 30);
                },
              ),
              BlocBuilder<CreateAccountCubit, CreateAccountState>(
                  builder: (context, state) {
                return Container(
                  width: 311,
                  height: 55,
                  decoration: ShapeDecoration(
                    color: state.validUser()
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
                    onPressed: state.validUser()
                        ? () {
                            context.read<CreateAccountCubit>().createAccount();
                          }
                        : null,
                    child: Text(
                      'Create Account',
                      // ignore: unnecessary_const
                      style: TextStyle(
                        color: state.validUser()
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
              }),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Have a Vesta Sleep account already?  ',
                        style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 15,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.75,
                        ),
                      ),
                      TextSpan(
                        text: 'Log In',
                        style: const TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 17,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          //white underline
                          decorationColor: Colors.white,
                          letterSpacing: 0.85,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<AuthenticationCubit>().setStatus(
                                  Status.loggingIn,
                                );
                          },
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'By creating an account or signing you',
                        style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w400,
                          height: 0.09,
                          letterSpacing: 0.70,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Color(0xFF010102),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.70,
                        ),
                      ),
                      TextSpan(
                        text: 'agree to our Terms and Conditions.',
                        style: TextStyle(
                          color: Color(0xFF37A2E7),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.70,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
