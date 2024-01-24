import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../application/cubit/contacts_cubit.dart';
import '../../../application/cubit/vesta_app_cubit.dart';
import '../common/vesta_back_white_button.dart';
import '../common/vesta_outline_button.dart';

class EmergencyContacts extends StatelessWidget {
  const EmergencyContacts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) {
          context.read<VestaAppCubit>().setPage(
                VestaPages.editAddress,
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
                      top: 70,
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
                                text: 'Emergency',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontFamily: 'M PLUS 1',
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.24,
                                ),
                              ),
                              TextSpan(
                                text: ' Contacts',
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
                          height: 10,
                        ),
                        SvgPicture.asset(
                          'assets/svg/contacts.svg',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 21,
                              height: 216,
                              child: Text(
                                '1.\n\n\n2.\n\n\n\n3.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Color(0xFF37A2E7),
                                  fontSize: 15,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.85,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 292,
                              child: Text(
                                'Let\'s set up your emergency contacts\n\nPlease make sure you provide a contact that has texting capabilities\n\nIn the event of an emergency, your emergency contact will be alerted first, before contacting first responders.\n',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.85,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 180,
                          child: BlocBuilder<ContactsCubit, ContactsCubitState>(
                              builder: (context, state) {
                            return ListView.builder(
                              itemCount: 3,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    //PICK CONTACT
                                    context.read<ContactsCubit>().pickContact();
                                  },
                                  child: Column(
                                    children: [
                                      Opacity(
                                        opacity: 0.20,
                                        child: Container(
                                          width: 398,
                                          decoration: const ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFFCDCDCD),
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0xFF00FFFF),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: SvgPicture.asset(
                                                'assets/svg/contact_person.svg',
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                state.contacts[index].name,
                                                style: const TextStyle(
                                                  color: Color(0xFF37A2E7),
                                                  fontSize: 17,
                                                  fontFamily: 'M PLUS 1',
                                                  fontWeight: FontWeight.w700,
                                                   letterSpacing: 0.85,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: SvgPicture.asset(
                                                'assets/svg/arrow_right.svg',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Opacity(
                                        opacity: 0.20,
                                        child: Container(
                                          width: 398,
                                          decoration: const ShapeDecoration(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0xFFCDCDCD),
                                              ),
                                            ),
                                            shadows: [
                                              BoxShadow(
                                                color: Color(0xFF00FFFF),
                                                blurRadius: 4,
                                                offset: Offset(0, 2),
                                                spreadRadius: 0,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                        ),
                        VestaOutlineButton(
                          onPressed: () {
                            //GO TO ADD EMERGENCY CONTACTS
                            // context.read<VestaAppCubit>().setPage(
                            //       VestaPages.addEmergencyContacts,
                            //     );
                          },
                          buttonText: 'Next',
                        ),
                      ],
                    ),
                  ),
                ),
                VestaWhiteBackButton(
                  onPressed: () {
                    //GO BACK TO HEALTH KIT
                    context.read<VestaAppCubit>().setPage(
                          VestaPages.editAddress,
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
