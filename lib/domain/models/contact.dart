class VestaContact {
  final String name;
  final String email;
  final String phone;

  VestaContact({
    required this.name,
    required this.email,
    required this.phone,
  });

  //from json
  factory VestaContact.fromJson(Map<String, dynamic> json) {
    return VestaContact(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }

  //to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}
