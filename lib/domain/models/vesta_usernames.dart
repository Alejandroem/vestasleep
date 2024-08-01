import 'model.dart';

class VestaUserName implements Model {
  final String username;

  VestaUserName({
    required this.username,
  });

  @override
  VestaUserName copyWith({
    String? username,
  }) {
    return VestaUserName(
      username: username ?? this.username,
    );
  }

  @override
  VestaUserName fromJson(Map<String, dynamic> json) {
    return VestaUserName(
      username: json['username'],
    );
  }

  factory VestaUserName.fromJson(Map<String, dynamic> json) {
    return VestaUserName(
      username: json['username'],
    );
  }

  @override
  VestaUserName fromJsonList(List json) {
    return VestaUserName(
      username: json[0]['username'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }

  @override
  List<Map<String, dynamic>> toJsonList() {
    return [
      {
        'username': username,
      }
    ];
  }

  @override
  String? get id => username;

  @override
  Model merge(old) {
    return this;
  }
}
