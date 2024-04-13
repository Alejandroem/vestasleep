import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/address.dart';
import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import '../../domain/services/users_service.dart';

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

  final bool isLoading;

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
    required this.isLoading,
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
    bool? isLoading,
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
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool validForm() {
    //Validate if the form is valid by checking errors and touched
    return validAddress.isEmpty &&
        addresTouched &&
        validCity.isEmpty &&
        cityTouched &&
        validState.isEmpty &&
        stateTouched &&
        validZipCode.isEmpty &&
        zipCodeTouched;
  }
}

class EditAddressCubit extends Cubit<EditAddressState> {
  final AuthenticationService authenticationService;
  final UsersService usersService;
  EditAddressCubit(
    this.authenticationService,
    this.usersService,
  ) : super(
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
            isLoading: false,
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

  Future<void> submit() async {
    //set loading
    emit(state.copyWith(isLoading: true));
    VestaUser? user = await authenticationService.getCurrentUserOrNull();

    if (user == null) {
      await authenticationService.signOut();
    } else {
      user = user.copyWith(
        address: Address(
          address: state.address,
          unitNumber: state.unitNumber,
          city: state.city,
          state: state.state,
          zipcode: state.zipCode,
        ),
      );
      await usersService.update(user);
    }
    //set loading
    emit(state.copyWith(isLoading: false));
  }
}
