import 'heart_rate.dart';
import 'sleep_data_point.dart';

class SleepScore {
  List<HeartRate> heartRates;
  List<SleepDataPoint> sessionPoints;

  SleepScore({
    required this.heartRates,
    required this.sessionPoints,
  });

  int _sessionMins() {
    int minutes = 0;
    for (var point in sessionPoints) {
      minutes += point.to.difference(point.from).inMinutes;
    }
    return minutes;
  }

  int _timeAsleep() {
    int minutes = 0;
    for (var point in sessionPoints) {
      if (point.stage != SleepStage.awake) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  int _timeAwake() {
    int minutes = 0;
    for (var point in sessionPoints) {
      if (point.stage == SleepStage.awake) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  String getAsleepString() {
    int hours = _timeAsleep() ~/ 60;
    int minutes = _timeAsleep() % 60;
    return "$hours h $minutes m";
  }

  String getAwakeString() {
    int hours = _timeAwake() ~/ 60;
    int minutes = _timeAwake() % 60;
    return "$hours h $minutes m";
  }

  String getAsleepAwakeScore() {
    return "${((_timeAsleep() / _sessionMins()) * 50).toInt()} / 50";
  }

  int _getTotalDeepSleep() {
    int minutes = 0;
    for (var point in sessionPoints) {
      if (point.stage == SleepStage.deep) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  int _getTotalRemSleep() {
    int minutes = 0;
    for (var point in sessionPoints) {
      if (point.stage == SleepStage.rem) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  String getDeepSleepString() {
    int hours = _getTotalDeepSleep() ~/ 60;
    int minutes = _getTotalDeepSleep() % 60;
    return "$hours h $minutes m";
  }

  String getRemSleepString() {
    int hours = _getTotalRemSleep() ~/ 60;
    int minutes = _getTotalRemSleep() % 60;
    return "$hours h $minutes m";
  }

  String getDeepReemScore() {
    return "${((_getTotalRemSleep() / _sessionMins()) * 25).toInt()} / 25";
  }

  bool restingHeartHeartRate(int averageHeartRate) {
    return averageHeartRate <= 40 || averageHeartRate >= 120;
  }

  int _getMinutesBellowRestingHeartRate() {
    int minutes = 0;
    for (var heartRate in heartRates) {
      if (!restingHeartHeartRate(heartRate.averageHeartRate)) {
        minutes += heartRate.to.difference(heartRate.from).inMinutes;
      }
    }
    return minutes;
  }

  int _minsAboveRestingHR() {
    int minutes = 0;
    for (var heartRate in heartRates) {
      if (restingHeartHeartRate(heartRate.averageHeartRate)) {
        minutes += heartRate.to.difference(heartRate.from).inMinutes;
      }
    }
    return minutes;
  }

  String getBellowRestingString() {
    //percentage
    return "${_getMinutesBellowRestingHeartRate()} / ${_sessionMins()} %";
  }

  String getRestLessPercentage() {
    //percentage
    return "${_minsAboveRestingHR()} / ${_sessionMins()} %";
  }

  String getRestorationScore() {
    return "${((_minsAboveRestingHR() / _sessionMins()) * 25).toInt()} / 25}";
  }

  String getOverallScore() {
    double asleepScore = ((_timeAsleep() / _sessionMins()) * 50);
    double remSleepScore = ((_getTotalRemSleep() / _sessionMins()) * 25);
    double restorationScore = ((_minsAboveRestingHR() / _sessionMins()) * 25);
    int overallScore = (asleepScore + remSleepScore + restorationScore).toInt();
    return "$overallScore / 100";
  }
}
