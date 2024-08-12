class DailySleepData {
  final DateTime date;
  final double sleepScore;
  final String grade;
  final Duration timeInBed;
  final Duration asleepDuration;
  final Duration remDuration;
  final Duration? awakeDuration;

  DailySleepData({
    required this.date,
    required this.sleepScore,
    required this.grade,
    required this.timeInBed,
    required this.asleepDuration,
    required this.remDuration,
    this.awakeDuration
  });
}
