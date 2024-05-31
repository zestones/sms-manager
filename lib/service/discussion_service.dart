import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/models/discussion_participant.dart';
import 'package:namer_app/repositories/contact_list_repository.dart';
import 'package:namer_app/repositories/discussion_participant_repository.dart';
import 'package:namer_app/repositories/discussion_repository.dart';

class DiscussionService {
  final DiscussionRepository _discussionRepository;
  final ContactListRepository _contactListRepository;
  final DiscussionParticipantRepository _discussionParticipantRepository;

  DiscussionService(
    this._discussionRepository,
    this._contactListRepository,
    this._discussionParticipantRepository,
  );

  Future<int> createDiscussion(discussionName, groups, contactIds) async {
    Discussion discussion = Discussion(name: discussionName);
    int discussionId = await _discussionRepository.insertDiscussion(discussion);

    List<Contact> contactsList =
        await _contactListRepository.getContactsByGroups(groups);

    var contactListIds = contactsList.map((contact) => contact.id).toSet();
    contactIds = contactIds.toSet();

    var union = contactListIds.union(contactIds).toSet().toList();
    List<DiscussionParticipant> discussionParticipants = union
        .map((id) =>
            DiscussionParticipant(discussionId: discussionId, contactId: id!))
        .toList();

    await _discussionParticipantRepository
        .insertDiscussionParticipants(discussionParticipants);

    return discussionId;
  }

  Future<int> insertDiscussion(Discussion discussion) async {
    return await _discussionRepository.insertDiscussion(discussion);
  }

  Future<List<Discussion>> getAllDiscussion() async {
    return await _discussionRepository.getAllDiscussion();
  }

  Future<void> deleteAllDiscussion() async {
    await _discussionRepository.deleteAllDiscussion();
    await _discussionParticipantRepository.deleteAllDiscussionParticipants();
  }
}
