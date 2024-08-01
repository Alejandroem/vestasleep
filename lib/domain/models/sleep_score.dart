import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import 'heart_rate.dart';
import 'sleep_data_point.dart';
import 'sleep_session.dart';

class SleepScore {
  DateTime from;
  DateTime to;
  List<SleepSession> sleepSessions;
  List<HeartRate> heartRatesDataPoints;
  List<SleepDataPoint> sleepDataPoints;

  SleepScore({
    required this.from,
    required this.to,
    required this.heartRatesDataPoints,
    required this.sleepDataPoints,
    required this.sleepSessions,
  });

  int sessionTotalMins() {
    int minutes = 0;
    for (var session in sleepSessions) {
      minutes += session.to.difference(session.from).inMinutes;
    }
    return minutes;
  }

  int _timeAsleep() {
    int minutes = 0;
    for (var point in sleepDataPoints) {
      if (point.stage != SleepStage.asleepCore) {
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

  int getAsleepAwakeScore() {
    if (sessionTotalMins() == 0) return 0;
    return ((_timeAsleep() / sessionTotalMins()) * 25).toInt();
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

  int getDeepReemScore() {
    if (sessionTotalMins() == 0) return 0;
    return ((_getTotalRemSleep() / sessionTotalMins()) * 50).toInt();
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
    if (sessionTotalMins() == 0) return "0 %";
    return "${_getMinutesBellowRestingHeartRate() ~/ sessionTotalMins()} %";
  }

  String getRestLessPercentage() {
    if (sessionTotalMins() == 0) return "0 %";
    return "${_minsAboveRestingHR() ~/ sessionTotalMins()} %";
  }

  String getRestorationScore() {
    return "${((_minsAboveRestingHR() / sessionTotalMins()) * 25).toInt()} / 25}";
  }

  int getOverallScoreValue() {
    int sessionMins = sessionTotalMins();
    if (sessionMins == 0) return 0;
    double asleepScore = ((_timeAsleep() / sessionMins) * 25);
    double remSleepScore = ((_getTotalRemSleep() / sessionMins) * 50);
    double restorationScore = ((_minsAboveRestingHR() / sessionMins) * 25);
    int overallScore = (asleepScore + remSleepScore + restorationScore).toInt();
    return overallScore;
  }

  String getOverallScore() {
    return "${getOverallScoreValue()}";
  }

  String getSleepQuality() {
    int overallScore = getOverallScoreValue();
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
      return days[from.weekday - 1] +
          (kDebugMode ? " ${from.day}/${from.month}" : "");
    } else {
      return "${from.day}/${from.month}";
    }
  }

  String sessionStart() {
    return DateFormat.jm().format(sleepSessions.first.from);
  }

  String sessionEnd() {
    return DateFormat.jm().format(sleepSessions.last.to);
  }

  String sessionDuration() {
    int minutes =
        sleepSessions.last.to.difference(sleepSessions.first.from).inMinutes;
    int hours = minutes ~/ 60;
    minutes = minutes % 60;
    return "$hours h $minutes m";
  }
}
