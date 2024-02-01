import '../../../domain/models/heart_rate.dart';
import '../bloc/heart_rate/heart_rate_bloc.dart';

bool hasHeartRateProblem(HeartRate current, UserState state) {
  int averageHeartRate = current.averageHeartRate;
  switch (state) {
    case UserState.normal:
      return averageHeartRate > 100 || averageHeartRate < 60;
    case UserState.sleeping:
      return averageHeartRate > 80 || averageHeartRate < 40;
    case UserState.excercising:
      return averageHeartRate > 150 || averageHeartRate < 100;
  }
}

bool hasSevereHeartRateProblem(HeartRate current) {
  int averageHeartRate = current.averageHeartRate;
  return averageHeartRate > 150 || averageHeartRate < 40;
}
