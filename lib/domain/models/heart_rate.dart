class HeartRate {
  final int averageHeartRate;
  final DateTime dateFrom;
  final DateTime dateTo;

  HeartRate(
    this.averageHeartRate,
    this.dateFrom,
    this.dateTo,
  );

  @override
  String toString() {
    return 'HeartRate{averageHeartRate: $averageHeartRate, dateFrom: $dateFrom, dateTo: $dateTo}';
  }
}
