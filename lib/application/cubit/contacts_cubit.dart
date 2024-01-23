import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/contacts_service.dart';

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
}

class ContactsCubit extends Cubit<ContactsCubitState> {
  final ContactsService contactService;

  ContactsCubit(
    this.contactService,
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
        contacts: [...state.contacts, contact],
      ),
    );
  }

  void updateContact(VestaContact contact) async {
    //set loading
    emit(state.copyWith(isLoading: true));

    //pick new contact
    //pick contact
    VestaContact contact;

    try {
      contact = await contactService.pickContact();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
      return;
    }

    //update contact by changing the contact in the current arrary

    emit(
      state.copyWith(
        isLoading: false,
        contacts: state.contacts.map((e) {
          if (e.name == contact.name) {
            return contact;
          }
          return e;
        }).toList(),
      ),
    );
  }
}
