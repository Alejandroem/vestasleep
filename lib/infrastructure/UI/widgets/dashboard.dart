import 'package:flutter/material.dart';

import 'alarm_flow.dart';
import 'heart_rate_chart.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Welcome!',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          letterSpacing: 0.24,
                        ),
                      ),
                    ),
                  ],
                ),
                AlarmFlow(),
                HeartRateChart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
