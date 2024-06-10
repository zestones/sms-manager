import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/contact_groups.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/repositories/contact_list_repository.dart';

class ContactListService {
  final ContactListRepository _contactListRepository;

  ContactListService(this._contactListRepository);

  Future<void> insertContactGroup(ContactGroup contactGroup) async {
    await _contactListRepository.insertContactGroup(contactGroup);
  }

  Future<List<Contact>> getContactListByGroups(
      List<FilterOption> filterOptions) async {
    return await _contactListRepository.getContactsByGroups(filterOptions);
  }

  Future<void> deleteAllContactList() async {
    await _contactListRepository.deleteAllContactList();
  }
}
