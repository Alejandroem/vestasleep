class SleepInterruption {
  DateTime from;
  DateTime to;

  SleepInterruption({required this.from, required this.to});

  Duration get duration => to.difference(from);
}