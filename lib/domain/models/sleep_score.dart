import 'package:intl/intl.dart';

import 'heart_rate.dart';
import 'sleep_data_point.dart';

class SleepScore {
  DateTime from;
  DateTime to;
  List<HeartRate> heartRatesDataPoints;
  List<SleepDataPoint> sleepDataPoints;

  SleepScore({
    required this.from,
    required this.to,
    required this.heartRatesDataPoints,
    required this.sleepDataPoints,
  });

  int _sessionMins() {
    int minutes = 0;
    for (var point in sleepDataPoints) {
      minutes += point.to.difference(point.from).inMinutes;
    }
    return minutes;
  }

  int _timeAsleep() {
    int minutes = 0;
    for (var point in sleepDataPoints) {
      if (point.stage != SleepStage.awake) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  int _timeAwake() {
    int minutes = 0;
    for (var point in sleepDataPoints) {
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
    for (var point in sleepDataPoints) {
      if (point.stage == SleepStage.deep) {
        minutes += point.to.difference(point.from).inMinutes;
      }
    }
    return minutes;
  }

  int _getTotalRemSleep() {
    int minutes = 0;
    for (var point in sleepDataPoints) {
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
    for (var heartRate in heartRatesDataPoints) {
      if (!restingHeartHeartRate(heartRate.averageHeartRate)) {
        minutes += heartRate.to.difference(heartRate.from).inMinutes;
      }
    }
    return minutes;
  }

  int _minsAboveRestingHR() {
    int minutes = 0;
    for (var heartRate in heartRatesDataPoints) {
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

  int _getOverallScore() {
    int sessionMins = _sessionMins();
    double asleepScore = ((_timeAsleep() / sessionMins) * 50);
    double remSleepScore = ((_getTotalRemSleep() / sessionMins) * 25);
    double restorationScore = ((_minsAboveRestingHR() / sessionMins) * 25);
    int overallScore = (asleepScore + remSleepScore + restorationScore).toInt();
    return overallScore;
  }

  String getOverallScore() {
    return "${_getOverallScore()}";
  }

  String getSleepQuality() {
    int overallScore = _getOverallScore();
    if (overallScore < 60) {
      return "Poor";
    } else if (overallScore < 80) {
      return "Fair";
    } else if (overallScore < 99) {
      return "Good";
    } else {
      return "Excellent";
    }
  }

  String getHumanDay() {
    //return full day name for the previous 7 days only and then the day + date
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    if (DateTime.now().day - from.day < 7) {
      return days[from.weekday - 1];
    } else {
      return "${from.day}/${from.month}";
    }
  }

  String sessionStart() {
    return DateFormat.jm().format(from);
  }

  String sessionEnd() {
    return DateFormat.jm().format(to);
  }

  String sessionDuration() {
    int hours = _sessionMins() ~/ 60;
    int minutes = _sessionMins() % 60;
    return "$hours h $minutes m";
  }
}
