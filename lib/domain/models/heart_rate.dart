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

  Map<String, dynamic> toJson() {
    return {
      'averageHeartRate': averageHeartRate,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }

  factory HeartRate.fromJson(Map<String, dynamic> json) {
    return HeartRate(
      json['averageHeartRate'],
      DateTime.parse(json['from']),
      DateTime.parse(json['to']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HeartRate &&
        other.averageHeartRate == averageHeartRate &&
        other.from == from &&
        other.to == to;
  }

  @override
  int get hashCode => averageHeartRate.hashCode ^ from.hashCode ^ to.hashCode;
}
