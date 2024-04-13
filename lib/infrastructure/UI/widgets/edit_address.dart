import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/edit_address_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';

class EditAddress extends StatelessWidget {
  const EditAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<VestaAppCubit>().setPage(
                VestaPages.settingUpProfile,
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
                                text: 'What is your ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.5,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: 'Home Address?',
                                style: TextStyle(
                                  color: Color(0xFF37A2E7),
                                  fontSize: 23.5,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
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
                              controller: TextEditingController(
                                text: context
                                    .read<EditAddressCubit>()
                                    .state
                                    .address,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: BlocBuilder<EditAddressCubit,
                                    EditAddressState>(
                                  builder: (context, state) {
                                    if (state.addresTouched &&
                                        state.validAddress == "") {
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
                                    "assets/svg/address_icon.svg",
                                  ),
                                ),
                                hintText: "Address",
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
                                context
                                    .read<EditAddressCubit>()
                                    .setAddress(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                              controller: TextEditingController(
                                text: context
                                    .read<EditAddressCubit>()
                                    .state
                                    .unitNumber,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: BlocBuilder<EditAddressCubit,
                                    EditAddressState>(
                                  builder: (context, state) {
                                    if (state.unitNumberTouched &&
                                        state.validUnitNumber == "") {
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
                                    "assets/svg/unit_number_icon.svg",
                                  ),
                                ),
                                hintText: "Unit Number",
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
                                context
                                    .read<EditAddressCubit>()
                                    .setUnitNumber(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                              controller: TextEditingController(
                                text:
                                    context.read<EditAddressCubit>().state.city,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: BlocBuilder<EditAddressCubit,
                                    EditAddressState>(
                                  builder: (context, state) {
                                    if (state.cityTouched &&
                                        state.validCity == "") {
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
                                    "assets/svg/unit_number_icon.svg",
                                  ),
                                ),
                                hintText: "City",
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
                                context.read<EditAddressCubit>().setCity(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                              controller: TextEditingController(
                                text: context
                                    .read<EditAddressCubit>()
                                    .state
                                    .state,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: BlocBuilder<EditAddressCubit,
                                    EditAddressState>(
                                  builder: (context, state) {
                                    if (state.stateTouched &&
                                        state.validState == "") {
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
                                    "assets/svg/state_icon.svg",
                                  ),
                                ),
                                hintText: "State",
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
                                context
                                    .read<EditAddressCubit>()
                                    .setState(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                              controller: TextEditingController(
                                text: context
                                    .read<EditAddressCubit>()
                                    .state
                                    .zipCode,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: BlocBuilder<EditAddressCubit,
                                    EditAddressState>(
                                  builder: (context, state) {
                                    if (state.zipCodeTouched &&
                                        state.validZipCode == "") {
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
                                    "assets/svg/zip_code_icon.svg",
                                  ),
                                ),
                                hintText: "Zipcode",
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
                                context
                                    .read<EditAddressCubit>()
                                    .setZipCode(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Your personal information will only be used in case of emergency services. ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontFamily: 'M PLUS 1',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.85,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        BlocBuilder<EditAddressCubit, EditAddressState>(
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
                              onPressed: state.validForm() && !state.isLoading
                                  ? () {
                                      context
                                          .read<EditAddressCubit>()
                                          .submit()
                                          .then(
                                        (_) {
                                          context.read<VestaAppCubit>().setPage(
                                                VestaPages.editContacts,
                                              );
                                        },
                                      );
                                    }
                                  : null,
                              child: state.isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Save',
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
                        }),
                      ],
                    ),
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.settingUpProfile,
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
