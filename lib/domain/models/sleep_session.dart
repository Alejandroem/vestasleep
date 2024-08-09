class SleepSession {
  final DateTime from;
  final DateTime to;

  SleepSession({
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from.toIso8601String(),
      'to': to.toIso8601String(),
    };
  }

  factory SleepSession.fromJson(Map<String, dynamic> json) {
    return SleepSession(
      from: DateTime.parse(json['from']),
      to: DateTime.parse(json['to']),
    );
  }
}