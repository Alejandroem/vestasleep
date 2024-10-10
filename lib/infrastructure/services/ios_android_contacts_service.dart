import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

import '../../domain/models/contact.dart';
import '../../domain/services/contacts_service.dart';

class IosAndroidContactsService extends ContactsService {
  @override
  Future<List<VestaContact>> getContacts() async {
    if (await flutter_contacts.FlutterContacts.requestPermission()) {
      final contacts = await flutter_contacts.FlutterContacts.getContacts();
      return contacts
          .map((flutter_contacts.Contact contact) => VestaContact(
                name: contact.displayName,
                email: (contact.emails.firstOrNull ?? '').toString(),
                phone: (contact.phones.firstOrNull ?? '').toString(),
              ))
          .toList();
    }
    throw Exception('Permission denied');
  }

  @override
  Future<VestaContact> pickContact() async {
    final FlutterNativeContactPicker _contactPicker =
        FlutterNativeContactPicker();
    final contact = await _contactPicker.selectContact();

    if (contact == null) {
      throw Exception('No contact selected');
    }

    return VestaContact(
      name: contact.fullName ?? '',
      email: "",
      phone: (contact.phoneNumbers ?? []).first,
    );
  }
}
