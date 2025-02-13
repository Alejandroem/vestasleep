import 'address.dart';
import 'contact.dart';
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
  final Address? address;
  final List<VestaContact>? contacts;
  final bool? emergencyResponseEnabled;
  final bool? hasFinishedOnboarding;

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
    this.address,
    this.contacts,
    this.emergencyResponseEnabled,
    this.hasFinishedOnboarding,
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
    Address? address,
    List<VestaContact>? contacts,
    bool? emergencyResponseEnabled,
    bool? hasFinishedOnboarding,
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
      address: address ?? this.address,
      contacts: contacts ?? this.contacts,
      emergencyResponseEnabled:
          emergencyResponseEnabled ?? this.emergencyResponseEnabled,
      hasFinishedOnboarding:
          hasFinishedOnboarding ?? this.hasFinishedOnboarding,
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
      address: Address.fromJSON(json['address']),
      contacts: json['contacts'] != null
          ? (json['contacts'] as List)
              .map((contact) => VestaContact.fromJson(contact))
              .toList()
          : null,
      emergencyResponseEnabled: json['emergencyResponseEnabled'],
      hasFinishedOnboarding: json['hasFinishedOnboarding'],
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
      address: json.keys.contains('address') && json['address'] != null
          ? Address.fromJSON(json['address'])
          : null,
      contacts: json['contacts'] != null
          ? (json['contacts'] as List)
              .map((contact) => VestaContact.fromJson(contact))
              .toList()
          : null,
      emergencyResponseEnabled: json['emergencyResponseEnabled'],
      hasFinishedOnboarding: json['hasFinishedOnboarding'],
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
      address: Address.fromJSON(json[0]['address']),
      contacts: json[0]['contacts'] != null
          ? (json[0]['contacts'] as List)
              .map((contact) => VestaContact.fromJson(contact))
              .toList()
          : null,
      emergencyResponseEnabled: json[0]['emergencyResponseEnabled'],
      hasFinishedOnboarding: json[0]['hasFinishedOnboarding'],
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
      'address': address?.toJSON(),
      'contacts': contacts?.map((contact) => contact.toJson()).toList(),
      'emergencyResponseEnabled': emergencyResponseEnabled,
      'hasFinishedOnboarding': hasFinishedOnboarding,
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
        'address': address?.toJSON(),
        'contacts': contacts?.map((contact) => contact.toJson()).toList(),
        'emergencyResponseEnabled': emergencyResponseEnabled,
        'hasFinishedOnboarding': hasFinishedOnboarding,
      }
    ];
  }

  @override
  VestaUser merge(old) {
    return VestaUser(
      id: id ?? old.id,
      username: username.isEmpty ? old.username : username,
      email: email.isEmpty ? old.email : email,
      password: password ?? old.password,
      photoURL: photoURL.isEmpty ? old.photoURL : photoURL,
      isAnonymous: isAnonymous,
    );
  }

  //tostring
  @override
  String toString() {
    return 'VestaUser{id: $id, username: $username, email: $email, password: $password, photoURL: $photoURL, isAnonymous: $isAnonymous, contacts: $contacts, emergencyResponseEnabled: $emergencyResponseEnabled}';
  }
}
