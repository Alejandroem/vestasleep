import '../../domain/models/heart_rate.dart';

bool hasLowerHeartRateProblem(HeartRate current, HeartRate resting) {
  return current.averageHeartRate < resting.averageHeartRate - 60;
}

bool hasHigherHeartRateProblem(HeartRate current, HeartRate resting) {
  return current.averageHeartRate > resting.averageHeartRate + 120;
}

bool hasHeartRateProblem(HeartRate current, HeartRate resting) {
  return hasLowerHeartRateProblem(current, resting) ||
      hasHigherHeartRateProblem(current, resting);
}
