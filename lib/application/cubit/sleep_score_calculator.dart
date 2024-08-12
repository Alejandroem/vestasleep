import 'package:health/health.dart';
import 'dart:async';
import 'package:vestasleep/domain/models/heart_rate.dart';

import '../../mock/heart_data.dart';

class SleepScoreCalculator {
  final Health health = Health();

  Future<Map<DateTime, Map<String, double>>>
      fetchAndCalculateSleepScores() async {
    Map<DateTime, Map<String, double>> sleepData = {};

    try {
      List<HealthDataType> types = [
        HealthDataType.HEART_RATE,
      ];

      final permissions = types.map((e) => HealthDataAccess.READ).toList();

      // Check if we have permission
      bool? hasPermissions =
          await health.hasPermissions(types, permissions: permissions) ?? false;
      if (!hasPermissions) {
        bool isAuthorized = await health.requestAuthorization(types);
        if (!isAuthorized) {
          print('Authorization failed');
          return sleepData;
        }
      }

      DateTime endDate = DateTime.now();

      // Fetch data for a broader range to determine sleep heart rate pattern
      DateTime startDateForPattern = endDate.subtract(Duration(days: 30));
      List<HeartRate> patternHeartRateData =
          await fetchHeartRateData(startDateForPattern, endDate);

      // Determine sleep heart rate range based on the user's pattern
      var sleepHeartRateRange =
          determineSleepHeartRateRange(patternHeartRateData);
      int SLEEP_HEART_RATE_MIN = sleepHeartRateRange['min'] ?? 40;
      int SLEEP_HEART_RATE_MAX = sleepHeartRateRange['max'] ?? 65;
      if (SLEEP_HEART_RATE_MAX > 65) {
        SLEEP_HEART_RATE_MAX = 65;
      }
      if (SLEEP_HEART_RATE_MAX > 65) {
        SLEEP_HEART_RATE_MIN = 40;
      }

      /*   int SLEEP_HEART_RATE_MIN = 60;
      int SLEEP_HEART_RATE_MAX = 120;*/

      for (int i = 0; i < 7; i++) {
        DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day)
            .subtract(Duration(days: i + 1));
        DateTime nextDate = startDate.add(Duration(days: 1));
        List<HeartRate> dailyHeartRateData =
            await fetchHeartRateData(startDate, nextDate);
        dailyHeartRateData = removeDuplicates(dailyHeartRateData);

        dailyHeartRateData = dailyHeartRateData.toSet().toList();
        double sleepScore = calculateDailySleepScore(
            dailyHeartRateData, SLEEP_HEART_RATE_MIN, SLEEP_HEART_RATE_MAX);
        double sleepTime = calculateDailySleepTime(
            dailyHeartRateData, SLEEP_HEART_RATE_MIN, SLEEP_HEART_RATE_MAX);

        // Debugging: Check the calculated sleep time and heart rate data
        print(
            'Date: $startDate, Sleep Time: $sleepTime, Sleep Score: $sleepScore');
        print('Heart Rate Data: $dailyHeartRateData');

        sleepData[startDate] = {
          'sleepScore': sleepScore,
          'sleepTime': sleepTime
        };
      }
    } catch (e) {
      print('Error fetching heart rate data: $e');
    }
    print(sleepData);
    return sleepData;
  }

  List<HeartRate> removeDuplicates(List<HeartRate> heartRateData) {
    Set<String> seen = Set();
    List<HeartRate> uniqueData = [];

    for (var data in heartRateData) {
      String key = '${data.from}-${data.averageHeartRate}';
      if (!seen.contains(key)) {
        seen.add(key);
        uniqueData.add(data);
      }
    }

    return uniqueData;
  }

  double calculateDailySleepTime(List<HeartRate> heartRateData,
      int SLEEP_HEART_RATE_MIN, int SLEEP_HEART_RATE_MAX) {
    if (heartRateData.isEmpty) {
      return 0.0;
    }

    double totalSleepTimeSeconds = 0.0;

    // Sort heart rate data by 'from' datetime
    heartRateData.sort((a, b) => a.from.compareTo(b.from));

    // Calculate the total sleep time based on 'from' and 'to' or consecutive heart rate entries
    for (int i = 0; i < heartRateData.length; i++) {
      var currentData = heartRateData[i];

      if (currentData.averageHeartRate >= SLEEP_HEART_RATE_MIN &&
          currentData.averageHeartRate <= SLEEP_HEART_RATE_MAX) {
        if (currentData.from == currentData.to &&
            i < heartRateData.length - 1) {
          var nextData = heartRateData[i + 1];
          totalSleepTimeSeconds +=
              nextData.from.difference(currentData.from).inSeconds;
        } else {
          totalSleepTimeSeconds +=
              currentData.to.difference(currentData.from).inSeconds;
        }
      }
    }

    // Convert total sleep time from seconds to hours
    double totalSleepTimeHours = totalSleepTimeSeconds / 3600.0;

    return totalSleepTimeHours;
  }

  Future<List<HeartRate>> fetchHeartRateData(
      DateTime startDate, DateTime endDate) async {
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
      startTime: startDate,
      endTime: endDate,
      types: [HealthDataType.HEART_RATE],
    );
    var data = Health().removeDuplicates(healthData);
    List<HeartRate> heartRateData = data.map((dataPoint) {
      return HeartRate(
        (dataPoint.value as NumericHealthValue).numericValue.toInt(),
        dataPoint.dateFrom,
        dataPoint.dateTo,
      );
    }).toList();

    //List<HeartRate> heartRateData = HeartSampleData().getHeartRateByRange(startDate, endDate);
    return heartRateData;
  }

  double calculateDailySleepScore(List<HeartRate> heartRateData,
      int SLEEP_HEART_RATE_MIN, int SLEEP_HEART_RATE_MAX) {
    if (heartRateData.isEmpty) {
      return 0.0;
    }

    List<int> sleepHeartRates = heartRateData
        .where((data) =>
            data.averageHeartRate >= SLEEP_HEART_RATE_MIN &&
            data.averageHeartRate <= SLEEP_HEART_RATE_MAX)
        .map((data) => data.averageHeartRate)
        .toList();

    if (sleepHeartRates.isEmpty) {
      return 0.0;
    }

    // Calculate average heart rate during sleep
    double avgSleepHeartRate =
        sleepHeartRates.reduce((a, b) => a + b) / sleepHeartRates.length;

    // Compute sleep score (example formula, adjust as needed)
    double sleepScore = (100 - avgSleepHeartRate) / 100 * 100;

    return sleepScore;
  }

  Map<String, int?> determineSleepHeartRateRange(
      List<HeartRate> heartRateData) {
    if (heartRateData.isEmpty) {
      return {'min': null, 'max': null}; // Return nulls to indicate no data
    }

    // Extract heart rate values from the data
    List<int> heartRates =
        heartRateData.map((data) => data.averageHeartRate).toList();

    // Calculate the minimum and maximum heart rate during sleep
    int minSleepHeartRate = heartRates.reduce((a, b) => a < b ? a : b);
    int maxSleepHeartRate = heartRates.reduce((a, b) => a > b ? a : b);

    return {'min': minSleepHeartRate, 'max': maxSleepHeartRate};
  }
}
