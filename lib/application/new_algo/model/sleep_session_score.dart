
import 'package:vestasleep/application/new_algo/sleep_score/sleep_score_cubit.dart';

class SleepSessionScore {
  final SleepSession session;
  final double sleepScore;
  final String grade;

  SleepSessionScore({
    required this.session,
    required this.sleepScore,
    required this.grade,
  });
}
