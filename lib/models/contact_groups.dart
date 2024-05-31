class ContactGroup {
  int contactId;
  int groupId;

  ContactGroup({
    required this.contactId,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'contact_id': contactId,
      'group_id': groupId,
    };
  }

  factory ContactGroup.fromMap(Map<String, dynamic> map) {
    return ContactGroup(
      contactId: map['contact_id'],
      groupId: map['group_id'],
    );
  }

  // function that map the contact with his group
  factory ContactGroup.fromContactGroup(int contactId, int groupId) {
    return ContactGroup(
      contactId: contactId,
      groupId: groupId,
    );
  }

  @override
  String toString() {
    return 'ContactGroup{contactId: $contactId, groupId: $groupId}';
  }
}
