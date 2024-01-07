import 'model.dart';

class VestaUser implements Model {
  @override
  final String? id;
  final String username;
  final String email;
  final String? password;
  final String photoURL;
  final bool isAnonymous;

  VestaUser({
    this.id,
    required this.username,
    required this.email,
    this.password,
    required this.photoURL,
    required this.isAnonymous,
  });

  @override
  Model copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    String? photoURL,
    bool? isAnonymous,
  }) {
    return VestaUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      photoURL: photoURL ?? this.photoURL,
      isAnonymous: isAnonymous ?? this.isAnonymous,
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
      }
    ];
  }
}
