import 'package:flutter/material.dart';

class DayDetail extends StatelessWidget {
  const DayDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: true,
        onPopInvoked: (bool isPop) {},
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Wednesday',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.85,
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    '45',
                    style: TextStyle(
                      color: Color(0xFF00FFFF),
                      fontSize: 38,
                      fontFamily: 'M PLUS 1',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.90,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Good',
                      style: TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 22,
                        fontFamily: 'M PLUS 1',
                        fontWeight: FontWeight.w400,
                        height: 0.05,
                        letterSpacing: 1.10,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              getScoreCard(
                context,
                "Time Asleep",
                "7h 51 min",
                "1h 16 min",
                "Asleep",
                "Awake",
                "40",
                "50",
              ),
              const SizedBox(height: 20),
              getScoreCard(
                context,
                "Deep and REM",
                "1h 27 min",
                "18%  ",
                "Deep",
                "REM",
                "22",
                "25",
              ),
              const SizedBox(height: 20),
              getScoreCard(
                context,
                "Restoration",
                "78% below resting",
                "11%",
                "Sleep heart rate",
                "Restless",
                "19",
                "25",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getScoreCard(
      BuildContext context,
      String title,
      String avgFirst,
      String avgSecond,
      String metricFirst,
      String metricSecond,
      String score,
      String total) {
    return Container(
      width: 340,
      height: 153,
      child: Stack(
        children: [
          Positioned(
            left: 17.16,
            top: 50.50,
            child: Container(
              width: 144.56,
              height: 12,
              child: const Stack(
                children: [
                  Positioned(
                    left: 132.08,
                    top: 0,
                    child: SizedBox(
                      width: 12.48,
                      child: Text(
                        '􀋚',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 10,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 15.60,
                      child: Text(
                        '􀙪',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 10,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Opacity(
              opacity: 0.10,
              child: Container(
                width: 340,
                height: 153,
                decoration: ShapeDecoration(
                  color: const Color(0xFF37A2E7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 89,
            child: Text(
              '${avgFirst}      ${avgSecond}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'M PLUS 1',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 109,
            child: Text(
              '${metricFirst}               ${metricSecond}',
              style: const TextStyle(
                color: Color(0xFFB2AFAF),
                fontSize: 14,
                fontFamily: 'M PLUS 1',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 56,
            child: Container(
              width: 306,
              height: 6,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            left: 17,
            top: 56,
            child: Container(
              width: 251,
              height: 6,
              decoration: ShapeDecoration(
                color: const Color(0xFF00FFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            left: 19,
            top: 23,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF37A2E7),
                fontSize: 17,
                fontFamily: 'M PLUS 1',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.85,
              ),
            ),
          ),
          Positioned(
            left: 270,
            top: 26,
            child: Opacity(
              opacity: 0.60,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${score}',
                      style: const TextStyle(
                        color: Color(0xFF00FFFF),
                        fontSize: 17,
                        fontFamily: 'M PLUS 1',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.85,
                      ),
                    ),
                    TextSpan(
                      text: '/${total}',
                      style: const TextStyle(
                        color: Color(0xFFCDCDCD),
                        fontSize: 17,
                        fontFamily: 'M PLUS 1',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.85,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
