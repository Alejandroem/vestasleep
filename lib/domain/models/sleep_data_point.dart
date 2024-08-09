enum SleepStage {
  awake, //3
  rem, //2
  asleepCore, //1
  deep, //0
}

class SleepDataPoint {
  final DateTime from;
  final DateTime to;
  final SleepStage stage;

  SleepDataPoint({
    required this.from,
    required this.to,
    required this.stage,
  });

  @override
  String toString() {
    return 'SleepDataPoint{from: $from, to: $to, stage: $stage}';
  }

  Map<String, dynamic> toJson() {
    return {
      'stage': stage.name,
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }

  factory SleepDataPoint.fromJson(Map<String, dynamic> json) {
    return SleepDataPoint(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
      stage: SleepStage.values.firstWhere((e) => e.name == json['stage']),
    );
  }
}
