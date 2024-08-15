import 'model/sleep_break.dart';

class SleepSessionData {
  final DateTime from;
  final DateTime to;
  final Duration asleepDuration;
  final Duration remDuration;
  final Duration awakeDuration;
  final Duration inBedDuration;
  final List<double>? heartRates;
  final double averageHeartRate;
  final List<SleepBreak> breaks; // List of breaks within the session


  SleepSessionData({
    required this.from,
    required this.to,
    required this.asleepDuration,
    required this.remDuration,
    required this.awakeDuration,
    required this.inBedDuration,
    this.heartRates,
    required this.averageHeartRate,
    required this.breaks,
  });
}
