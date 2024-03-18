import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/cubit/sleep_score_cubit.dart';
import '../../../domain/models/sleep_score.dart';
import 'day_detail.dart';

class SleepDashboard extends StatelessWidget {
  const SleepDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<SleepScoreCubit>().fetchSleepScores();
    return Scaffold(
      backgroundColor: const Color(0xff1B1464),
      body: PopScope(
        canPop: false,
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
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
          ),
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  const Text(
                    'Sleep',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'M PLUS 1',
                      fontWeight: FontWeight.w700,
                      height: 0.07,
                      letterSpacing: 0.85,
                    ),
                  ),
                  getSleepGraph(),
                  getThisWeekTile(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<SleepScoreCubit, SleepScoreState>(
                      builder: (context, state) {
                        if (state.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.scores.length,
                          itemBuilder: (context, index) {
                            return getSleepTile(context, state.scores[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getThisWeekTile() {
    return Container(
      width: 349,
      height: 102.50,
      child: Stack(
        children: [
          Positioned(
            left: 17.61,
            top: 0,
            child: Container(
              width: 148.39,
              height: 12,
              child: const Stack(
                children: [
                  Positioned(
                    left: 135.58,
                    top: 0,
                    child: SizedBox(
                      width: 12.81,
                      child: Text(
                        '􀋚',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFCDCDCD),
                          fontSize: 10,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: SizedBox(
                      width: 16.01,
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
            top: 31.50,
            child: Opacity(
              opacity: 0.10,
              child: Container(
                width: 349,
                height: 71,
                decoration: ShapeDecoration(
                  color: const Color(0xFF37A2E7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 18,
            top: 52.50,
            child: SizedBox(
              width: 186.82,
              child: Text(
                'This Week',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 153,
            top: 37.50,
            child: SizedBox(
              width: 171,
              child: Opacity(
                opacity: 0.60,
                child: Text(
                  '70 Sleep Score\n6 hr 3 min',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'M PLUS 1',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.85,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox getSleepGraph() {
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          minY: 0,
          maxY: 100,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: 50,
            getDrawingHorizontalLine: (value) {
              return const FlLine(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFCDCDCD),
                    Color(0xFF00FFFF),
                  ],
                ),
                color: Colors.white,
                strokeWidth: 1,
              );
            },
          ),
          barTouchData: BarTouchData(
            enabled: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
                reservedSize: 28,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 28,
                showTitles: true,
                interval: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: const TextStyle(
                      color: Color(0xFFCDCDCD),
                      fontSize: 11,
                      fontFamily: 'M PLUS 1',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.55,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  List<String> days = [
                    'Mo',
                    'Tu',
                    'We',
                    'Th',
                    'Fr',
                    'Sa',
                    'Su'
                  ];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(
                      color: Color(0xff7589a2),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: [
            ...generateSevenDaysData(),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> generateSevenDaysData() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            width: 16,
            fromY: 0,
            toY: (index + 1) *
                10, // Just an example, replace with your actual data
            color: Colors.lightBlueAccent,
          )
        ],
      );
    });
  }

  Widget getSleepTile(BuildContext context, SleepScore score) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DayDetail(),
          ),
        );
      },
      child: Container(
        height: 106,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 106,
              child: Opacity(
                opacity: 0.20,
                child: Container(
                  width: 398,
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFCDCDCD),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0xFF00FFFF),
                        blurRadius: 4,
                        offset: Offset(0, 3),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 46,
              child: Text(
                score.sessionDuration(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              left: 274,
              top: 2,
              child: Container(
                width: 62,
                height: 62,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 1, color: Color(0xFF00FFFF)),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 250,
              top: 28,
              child: Container(
                width: 22,
                height: 22,
                padding: const EdgeInsets.symmetric(vertical: 5.50),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                ),
              ),
            ),
            Positioned(
              left: 290,
              top: 18,
              child: Text(
                score.getOverallScore(),
                style: const TextStyle(
                  color: Color(0xFF00FFFF),
                  fontSize: 22,
                  fontFamily: 'M PLUS 1',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
            ),
            Positioned(
              top: 10,
              child: SizedBox(
                width: 262,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: score.getHumanDay(),
                        style: const TextStyle(
                          color: Color(0xFF37A2E7),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.70,
                        ),
                      ),
                      TextSpan(
                        text:
                            '   ${score.sessionStart()} - ${score.sessionEnd()}',
                        style: const TextStyle(
                          color: Color(0xFF37A2E7),
                          fontSize: 14,
                          fontFamily: 'M PLUS 1',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 290,
              top: 80,
              child: SizedBox(
                width: 40,
                height: 26,
                child: Text(
                  score.getSleepQuality(),
                  style: const TextStyle(
                    color: Color(0xFF37A2E7),
                    fontSize: 14,
                    fontFamily: 'M PLUS 1',
                    fontWeight: FontWeight.w700,
                    height: 0.09,
                    letterSpacing: 0.70,
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
