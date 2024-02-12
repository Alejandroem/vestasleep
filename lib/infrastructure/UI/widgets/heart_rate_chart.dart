import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/bloc/heart_rate/heart_rate_bloc.dart';

class HeartRateChart extends StatelessWidget {
  const HeartRateChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeartRateBloc, HeartRateState>(
        builder: (context, state) {
      return Container(
        height: 300,
        padding: const EdgeInsets.all(20),
        child: Card(
          color: const Color(0xff1B1464),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Heart Rate BPM',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'M PLUS 1',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          left: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid,
                          ),
                          bottom: BorderSide(
                            color: Colors.white,
                            width: 0.1,
                            style: BorderStyle.solid,
                          ),
                          right: BorderSide(
                            color: Colors.transparent,
                          ),
                          top: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      gridData: const FlGridData(
                        show: false,
                      ),
                      minY: 0,
                      maxY: 160,
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: Colors.white,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              return LineTooltipItem(
                                touchedSpot.y.toString(),
                                const TextStyle(
                                  color: Color(0xff1B1464),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,
                          color: Colors.white.withOpacity(0.6),
                          barWidth: 1,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (p0, p1, p2, p3) {
                              return FlDotCirclePainter(
                                radius: 2,
                                color: const Color(0xff1B1464).withOpacity(0.3),
                                strokeWidth: 1,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          spots: state is MonitoringHeartRate &&
                                  state.heartRateList != null
                              ? state.heartRateList!.asMap().keys.map((i) {
                                  return FlSpot(
                                    i.toDouble(),
                                    state.heartRateList![i].averageHeartRate
                                        .toDouble(),
                                  );
                                }).toList()
                              : [],
                        ),
                      ],
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                reservedSize: 44, showTitles: false)),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                                reservedSize: 44, showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 35,
                            showTitles: true,
                            interval: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 20,
                            showTitles: false,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
