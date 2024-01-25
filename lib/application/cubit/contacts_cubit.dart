import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/contact.dart';
import '../../domain/models/vesta_user.dart';
import '../../domain/services/authentication_service.dart';
import '../../domain/services/contacts_service.dart';
import '../../domain/services/users_service.dart';

class ContactsCubitState {
  final List<VestaContact> contacts;
  final bool isLoading;
  final String error;

  ContactsCubitState({
    required this.contacts,
    required this.isLoading,
    required this.error,
  });

  //copy with
  ContactsCubitState copyWith({
    List<VestaContact>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return ContactsCubitState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  //override equality operator to check contact equality
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactsCubitState &&
        listEquals(other.contacts, contacts) &&
        other.isLoading == isLoading &&
        other.error == error;
  }
}

class ContactsCubit extends Cubit<ContactsCubitState> {
  final ContactsService contactService;
  final AuthenticationService authenticationService;
  final UsersService usersService;

  ContactsCubit(
    this.contactService,
    this.authenticationService,
    this.usersService,
  ) : super(ContactsCubitState(
          contacts: [],
          isLoading: false,
          error: '',
        ));

  //pick contact
  void pickContact() async {
    //set loading
    emit(state.copyWith(isLoading: true));

    //pick contact
    VestaContact contact;

    try {
      contact = await contactService.pickContact();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return;
    }

    //set loading
    emit(
      state.copyWith(
        isLoading: false,
        //TODO repeated validation
        contacts: [...state.contacts, contact],
      ),
    );
  }

  void updateContact(VestaContact oldContact) async {
    //set loading
    emit(state.copyWith(isLoading: true));

    //pick contact
    VestaContact contact;

    try {
      contact = await contactService.pickContact();
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
      return;
    }

    //update contact by changing the contact in the current arrary

    emit(
      state.copyWith(
        isLoading: false,
        //TODO repeated validation
        contacts: state.contacts.map((e) {
          if (e.name == oldContact.name) {
            return contact;
          }
          return e;
        }).toList(),
      ),
    );
  }

  void submit() async {
    //get current user
    VestaUser? user = await authenticationService.getCurrentUserOrNull();

    if (user == null) {
      await authenticationService.signOut();
    } else {
      //set loading
      emit(state.copyWith(isLoading: true));

      //update user
      user = user.copyWith(contacts: state.contacts);
      try {
        await usersService.update(user);
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
        return;
      }
      //set loading
      emit(state.copyWith(isLoading: false));
    }
  }
}
