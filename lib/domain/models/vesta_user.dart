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

  VestaUser({
    this.id,
    required this.username,
    required this.email,
    this.password,
    required this.photoURL,
    required this.isAnonymous,
    this.gender,
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
  }) {
    return VestaUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      photoURL: photoURL ?? this.photoURL,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      gender: gender ?? this.gender,
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
      }
    ];
  }
}
