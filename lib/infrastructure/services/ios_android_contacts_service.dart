import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import '../../domain/models/contact.dart';
import '../../domain/services/contacts_service.dart';

class IosAndroidContactsService extends ContactsService {
  @override
  Future<List<VestaContact>> getContacts() async {
    // Request permission and check if granted
    if (await flutter_contacts.FlutterContacts.requestPermission()) {
      // Retrieve contacts
      final contacts = await flutter_contacts.FlutterContacts.getContacts(withProperties: true);
      return contacts
          .map((flutter_contacts.Contact contact) => VestaContact(
                name: contact.displayName ?? '',
                email: contact.emails.isNotEmpty ? contact.emails.first.address : '',
                phone: contact.phones.isNotEmpty ? contact.phones.first.number : '',
              ))
          .toList();
    }
    throw Exception('Permission denied');
  }

  @override
  Future<VestaContact> pickContact() async {
    final contact = await flutter_contacts.FlutterContacts.openExternalPick();

    if (contact == null) {
      throw Exception('No contact selected');
    }

    return VestaContact(
      name: contact.displayName ?? '',
      email: contact.emails.isNotEmpty ? contact.emails.first.address : '',
      phone: contact.phones.isNotEmpty ? contact.phones.first.number : '',
    );
  }
}
