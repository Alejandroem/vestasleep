import 'package:vestasleep/application/new_algo/model/sleep_interruption.dart';

class SleepSession {
  DateTime from;
  DateTime to;
  Duration asleepDuration;
  Duration awakeDuration;

  SleepSession({
    required this.from,
    required this.to,
    required this.asleepDuration,
    required this.awakeDuration,
  });

  Duration get duration => to.difference(from);
}