import 'package:flutter_bloc/flutter_bloc.dart';

class EditAddressState {
  final String address;
  final String validAddress;
  final bool addresTouched;

  final String unitNumber;
  final String validUnitNumber;
  final bool unitNumberTouched;

  final String city;
  final String validCity;
  final bool cityTouched;

  final String state;
  final String validState;
  final bool stateTouched;

  final String zipCode;
  final String validZipCode;
  final bool zipCodeTouched;

  EditAddressState({
    required this.address,
    required this.validAddress,
    required this.addresTouched,
    required this.unitNumber,
    required this.validUnitNumber,
    required this.unitNumberTouched,
    required this.city,
    required this.validCity,
    required this.cityTouched,
    required this.state,
    required this.validState,
    required this.stateTouched,
    required this.zipCode,
    required this.validZipCode,
    required this.zipCodeTouched,
  });

  //copyWith
  EditAddressState copyWith({
    String? address,
    String? validAddress,
    bool? addresTouched,
    String? unitNumber,
    String? validUnitNumber,
    bool? unitNumberTouched,
    String? city,
    String? validCity,
    bool? cityTouched,
    String? state,
    String? validState,
    bool? stateTouched,
    String? zipCode,
    String? validZipCode,
    bool? zipCodeTouched,
  }) {
    return EditAddressState(
      address: address ?? this.address,
      validAddress: validAddress ?? this.validAddress,
      addresTouched: addresTouched ?? this.addresTouched,
      unitNumber: unitNumber ?? this.unitNumber,
      validUnitNumber: validUnitNumber ?? this.validUnitNumber,
      unitNumberTouched: unitNumberTouched ?? this.unitNumberTouched,
      city: city ?? this.city,
      validCity: validCity ?? this.validCity,
      cityTouched: cityTouched ?? this.cityTouched,
      state: state ?? this.state,
      validState: validState ?? this.validState,
      stateTouched: stateTouched ?? this.stateTouched,
      zipCode: zipCode ?? this.zipCode,
      validZipCode: validZipCode ?? this.validZipCode,
      zipCodeTouched: zipCodeTouched ?? this.zipCodeTouched,
    );
  }
}

class EditAddressCubit extends Cubit<EditAddressState> {
  EditAddressCubit()
      : super(
          EditAddressState(
            address: "",
            validAddress: "",
            addresTouched: false,
            unitNumber: "",
            validUnitNumber: "",
            unitNumberTouched: false,
            city: "",
            validCity: "",
            cityTouched: false,
            state: "",
            validState: "",
            stateTouched: false,
            zipCode: "",
            validZipCode: "",
            zipCodeTouched: false,
          ),
        );

  void setAddress(String value) {
    String validAddress = "";

    if (value.isEmpty) {
      validAddress = "Address is required";
    }

    emit(
      state.copyWith(
        addresTouched: true,
        address: value,
        validAddress: validAddress,
      ),
    );
  }

  void setUnitNumber(String value) {
    String validStreet = "";

    if (value.isEmpty) {
      validStreet = "Unit number is required";
    }

    emit(
      state.copyWith(
        unitNumberTouched: true,
        unitNumber: value,
        validUnitNumber: validStreet,
      ),
    );
  }

  void setCity(String value) {
    String validCity = "";

    if (value.isEmpty) {
      validCity = "City is required";
    }

    emit(
      state.copyWith(
        cityTouched: true,
        city: value,
        validCity: validCity,
      ),
    );
  }

  void setState(String value) {
    String validState = "";

    if (value.isEmpty) {
      validState = "State is required";
    }

    emit(
      state.copyWith(
        stateTouched: true,
        state: value,
        validState: validState,
      ),
    );
  }

  void setZipCode(String value) {
    String validZipCode = "";

    if (value.isEmpty) {
      validZipCode = "Zip code is required";
    }

    emit(
      state.copyWith(
        zipCodeTouched: true,
        zipCode: value,
        validZipCode: validZipCode,
      ),
    );
  }
}
