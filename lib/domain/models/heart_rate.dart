class HeartRate {
  final int averageHeartRate;
  final DateTime from;
  final DateTime to;

  HeartRate(
    this.averageHeartRate,
    this.from,
    this.to,
  );

  @override
  String toString() {
    return 'HeartRate{averageHeartRate: $averageHeartRate, dateFrom: $from, dateTo: $to}';
  }
}
