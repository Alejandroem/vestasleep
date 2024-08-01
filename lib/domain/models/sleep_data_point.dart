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
}
