import 'package:vestasleep/domain/models/model.dart';

class VestaUser implements Model {
  final String username;
  final String email;
  final String password;

  VestaUser({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  Model copyWith(covariant parameters) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Model fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Model fromJsonList(List json) {
    // TODO: implement fromJsonList
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  List<Map<String, dynamic>> toJsonList() {
    // TODO: implement toJsonList
    throw UnimplementedError();
  }
}
