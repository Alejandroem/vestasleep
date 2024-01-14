import 'model.dart';

class VestaUser implements Model {
  @override
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String photoURL;
  final bool isAnonymous;
  final String? gender;
  final int? age;
  final double? weight;
  final double? height;

  VestaUser({
    this.id,
    required this.username,
    required this.email,
    this.password,
    required this.photoURL,
    required this.isAnonymous,
    this.gender,
    this.age,
    this.weight,
    this.height,
  });

  @override
  VestaUser copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? photoURL,
    bool? isAnonymous,
    String? gender,
    int? age,
    double? weight,
    double? height,
  }) {
    return VestaUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      photoURL: photoURL ?? this.photoURL,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return VestaUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      photoURL: json['photoURL'],
      isAnonymous: json['isAnonymous'],
      gender: json['gender'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
    );
  }

  factory VestaUser.fromJson(Map<String, dynamic> json) {
    return VestaUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      photoURL: json['photoURL'],
      isAnonymous: json['isAnonymous'],
      gender: json['gender'],
      age: json['age'],
      weight: json['weight'],
      height: json['height'],
    );
  }

  @override
  VestaUser fromJsonList(List json) {
    return VestaUser(
      id: json[0]['id'],
      username: json[0]['username'],
      email: json[0]['email'],
      password: json[0]['password'],
      photoURL: json[0]['photoURL'],
      isAnonymous: json[0]['isAnonymous'],
      gender: json[0]['gender'],
      age: json[0]['age'],
      weight: json[0]['weight'],
      height: json[0]['height'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'photoURL': photoURL,
      'isAnonymous': isAnonymous,
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  @override
  List<Map<String, dynamic>> toJsonList() {
    return [
      {
        'username': username,
        'email': email,
        'password': password,
        'photoURL': photoURL,
        'isAnonymous': isAnonymous,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
      }
    ];
  }
}
