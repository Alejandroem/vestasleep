import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/svg/vesta_icon.svg"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Life-Saving technology ',
                      style: TextStyle(
                        color: Color(0xFF37A2E7),
                        fontSize: 17,
                        fontFamily: 'SF Pro Text',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.85,
                      ),
                    ),
                    TextSpan(
                      text: 'that watches you when you can’t.',
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
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 312,
              height: 55,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
                shadows: [
                  const BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Get Started',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'SF Pro Text',
                    fontWeight: FontWeight.w400,
                    height: 0.07,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
