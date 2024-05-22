import 'package:namer_app/models/contact.dart';
import 'package:namer_app/repositories/contact_repository.dart';

class ContactService {
  final ContactRepository _contactRepository;

  ContactService(this._contactRepository);

  Future<void> insertContact(Contact contact) async {
    await _contactRepository.insertContact(contact);
  }

  Future<void> deleteAllContact() async {
    await _contactRepository.deleteAllContact();
  }
}
