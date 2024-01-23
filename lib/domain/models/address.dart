class Address {
  final String address;
  final String unitNumber;
  final String city;
  final String state;
  final String zipcode;

  Address({
    required this.address,
    required this.unitNumber,
    required this.city,
    required this.state,
    required this.zipcode,
  });


  Address copyWith({
    String? address,
    String? unitNumber,
    String? city,
    String? state,
    String? zipcode,
  }) {
    return Address(
      address: address ?? this.address,
      unitNumber: unitNumber ?? this.unitNumber,
      city: city ?? this.city,
      state: state ?? this.state,
      zipcode: zipcode ?? this.zipcode,
    );
  }

  //toJSON
  Map<String, dynamic> toJSON() {
    return {
      'address': address,
      'unitNumber': unitNumber,
      'city': city,
      'state': state,
      'zipcode': zipcode,
    };
  }

  //fromJSON
  factory Address.fromJSON(Map<String, dynamic> json) {
    return Address(
      address: json['address'],
      unitNumber: json['unitNumber'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
    );
  }


}
