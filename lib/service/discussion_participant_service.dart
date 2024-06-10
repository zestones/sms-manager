import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/discussion_participant.dart';
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

  Future<void> updateDiscussionParticipants(
      discussionId, List<int?> contactIds) async {
    List<int> currentContactIds =
        await getParticipantIdsByDiscussionId(discussionId);

    // Ensure there are no null values and convert to List<int>
    List<int> nonNullContactIds = contactIds.whereType<int>().toList();

    // Determine the contacts to add
    List<int> contactIdsToAdd = nonNullContactIds
        .toSet()
        .difference(currentContactIds.toSet())
        .toList();

    // Determine the contacts to remove
    List<int> contactIdsToRemove = currentContactIds
        .toSet()
        .difference(nonNullContactIds.toSet())
        .toList();

    await addParticipantsToDiscussion(
        discussionId,
        contactIdsToAdd
            .map((contactId) => DiscussionParticipant(
                  discussionId: discussionId,
                  contactId: contactId,
                ))
            .toList());

    await removeParticipantsFromDiscussion(discussionId, contactIdsToRemove);
  }

  Future<void> addParticipantsToDiscussion(discussionId, participants) async {
    if (participants.isEmpty) return;
    await _discussionParticipantRepository
        .insertDiscussionParticipants(participants);
  }

  Future<void> removeParticipantsFromDiscussion(
      discussionId, contactIds) async {
    if (contactIds.isEmpty) return;
    await _discussionParticipantRepository.removeParticipantsFromDiscussion(
        discussionId, contactIds!);
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
