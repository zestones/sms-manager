class DiscussionParticipant {
  int? id;
  int contactId;
  int discussionId;

  DiscussionParticipant({
    this.id,
    required this.contactId,
    required this.discussionId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'contact_id': contactId,
      'discussion_id': discussionId,
    };
  }

  factory DiscussionParticipant.fromMap(Map<String, dynamic> map) {
    return DiscussionParticipant(
      id: map['id'],
      contactId: map['contact_id'],
      discussionId: map['discussion_id'],
    );
  }

  @override
  String toString() {
    return 'DiscussionParticipant{id: $id, contactId: $contactId, discussionId: $discussionId}';
  }
}
