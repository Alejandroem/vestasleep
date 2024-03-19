enum SleepStage {
  awake, //3
  rem, //2
  asleep, //1
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
}
