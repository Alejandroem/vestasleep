class HeartRate {
  final DateTime timestamp;  // Single timestamp for the heart rate data
  final double bpm;          // Heart rate value (beats per minute)

  HeartRate({
    required this.timestamp,
    required this.bpm,
  });
}