import '../../../domain/models/heart_rate.dart';
import '../../domain/models/user_state.dart';

int recoveryMargin = 10; // Define your error margin

bool hasHeartRateProblem(HeartRate current, UserState state) {
  int averageHeartRate = current.averageHeartRate;
  switch (state) {
    case UserState.normal:
      return averageHeartRate <= 60 || averageHeartRate >= 100;
    case UserState.sleeping:
      return averageHeartRate <= 40 || averageHeartRate >= 120;
    case UserState.excercising:
      return averageHeartRate <= 100 || averageHeartRate >= 150;
  }
}

bool hasSevereHeartRateProblem(HeartRate current) {
  int averageHeartRate = current.averageHeartRate;
  return averageHeartRate < 35 || averageHeartRate > 140;
}

bool heartRateNormal(HeartRate current, UserState state) {
  int averageHeartRate = current.averageHeartRate;

  switch (state) {
    case UserState.normal:
      return averageHeartRate > (60 + recoveryMargin) &&
          averageHeartRate < (100 - recoveryMargin);
    case UserState.sleeping:
      return averageHeartRate > (40 + recoveryMargin) &&
          averageHeartRate < (80 - recoveryMargin);
    case UserState.excercising:
      return averageHeartRate > (100 + recoveryMargin) &&
          averageHeartRate < (150 - recoveryMargin);
  }
}
