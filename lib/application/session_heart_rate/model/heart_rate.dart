class HeartRate {
  final DateTime dateFrom; // Start time of the heart rate data
  final DateTime dateTo;   // End time of the heart rate data
  final double bpm;        // Heart rate value (beats per minute)

  HeartRate({
    required this.dateFrom,
    required this.dateTo,
    required this.bpm,
  });
}