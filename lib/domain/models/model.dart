abstract class Model {
  String? get id;
  fromJson(Map<String, dynamic> json);
  Model fromJsonList(List<dynamic> json);
  Map<String, dynamic> toJson();
  List<Map<String, dynamic>> toJsonList();
  Model copyWith();
}
