import 'package:flutter/material.dart';

import 'heart_rate_chart.dart';
import 'sleep_chart.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: const Column(
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
          SleepChart(),
          HeartRateChart(),
        ],
      ),
    );
  }
}
