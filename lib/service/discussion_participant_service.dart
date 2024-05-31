import 'package:namer_app/models/contact.dart';
import 'package:namer_app/repositories/contact_repository.dart';
import 'package:namer_app/repositories/discussion_participant_repository.dart';

class DiscussionParticipantService {
  final DiscussionParticipantRepository _discussionParticipantRepository;
  final ContactRepository _contactRepository;

  DiscussionParticipantService(
      this._discussionParticipantRepository, this._contactRepository);

  Future<List<int>> getParticipantIdsByDiscussionId(discussionId) async {
    return await _discussionParticipantRepository
        .getDiscussionParticipantIdsByDiscussionId(discussionId);
  }

  Future<List<Contact>> getContactsByDiscussionId(discussionId) async {
    List<int> contactIds = await getParticipantIdsByDiscussionId(discussionId);

    List<Contact> contacts = [];
    for (var contactId in contactIds) {
      Contact contact = await _contactRepository.getContactById(contactId);
      contacts.add(contact);
    }

    return contacts;
  }
}
