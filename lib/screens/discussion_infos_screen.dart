import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/service/discussion_participant_service.dart';
import 'package:namer_app/widgets/contact_tile.dart';
import 'package:provider/provider.dart';

class DiscussionInfosScreen extends StatefulWidget {
  final Discussion discussion;

  DiscussionInfosScreen({required this.discussion});

  @override
  State<DiscussionInfosScreen> createState() => _DiscussionInfosScreenState();
}

class _DiscussionInfosScreenState extends State<DiscussionInfosScreen> {
  List<Contact> participants = [];
  bool isEditMode = false;
  Set<Contact> selectedContacts = {};

  @override
  void initState() {
    super.initState();
    _loadParticipants();
  }

  void _loadParticipants() {
    final discussionParticipantService =
        Provider.of<DiscussionParticipantService>(context, listen: false);

    discussionParticipantService
        .getContactsByDiscussionId(widget.discussion.id!)
        .then(
      (contacts) {
        contacts.sort((a, b) => a.firstName.compareTo(b.firstName));
        setState(() {
          participants.clear();
          participants.addAll(contacts);
        });
      },
    );
  }

  void _toggleEditMode() {
    setState(() {
      isEditMode = !isEditMode;
      selectedContacts.clear();
    });
  }

  void _toggleSelection(Contact contact) {
    setState(() {
      if (selectedContacts.contains(contact)) {
        selectedContacts.remove(contact);
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  void _removeSelectedContacts() {
    setState(() {
      final discussionParticipantService =
          Provider.of<DiscussionParticipantService>(context, listen: false);

      final contactIds = selectedContacts
          .map((c) => c.id)
          .where((id) => id != null)
          .cast<int>()
          .toList();

      discussionParticipantService.removeParticipantsFromDiscussion(
          widget.discussion.id!, contactIds);

      participants.removeWhere((contact) => selectedContacts.contains(contact));
      selectedContacts.clear();
      isEditMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussion.name),
        actions: [
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _removeSelectedContacts,
            ),
          IconButton(
            icon: Icon(isEditMode ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final contact = participants[index];
                final isSelected = selectedContacts.contains(contact);

                return GestureDetector(
                  onLongPress: () {
                    if (!isEditMode) {
                      _toggleEditMode();
                    }
                    _toggleSelection(contact);
                  },
                  onTap: isEditMode ? () => _toggleSelection(contact) : null,
                  child: Container(
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.2)
                        : null,
                    child: Column(
                      children: [
                        SizedBox(height: 8),
                        ContactTile(contact: contact),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
