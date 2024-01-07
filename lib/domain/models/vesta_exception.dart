class VestaException implements Exception {
  final String message;
  final String? code;

  VestaException({
    required this.message,
    this.code,
  });

  @override
  String toString() {
    return 'VestaError(message: $message, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VestaException &&
        other.message == message &&
        other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}
