import '../models/contact.dart';

abstract class ContactsService {
  Future<List<VestaContact>> getContacts();

  Future<VestaContact> pickContact();
}
