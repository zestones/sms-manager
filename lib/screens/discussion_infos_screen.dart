import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/screens/add_discussion_screen.dart';
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
        if (selectedContacts.isEmpty) {
          isEditMode = false;
        }
      } else {
        selectedContacts.add(contact);
      }
    });
  }

  void _removeSelectedContacts() {
    final discussionParticipantService =
        Provider.of<DiscussionParticipantService>(context, listen: false);

    final contactIds = selectedContacts
        .map((c) => c.id)
        .where((id) => id != null)
        .cast<int>()
        .toList();

    discussionParticipantService.removeParticipantsFromDiscussion(
        widget.discussion.id!, contactIds);

    setState(() {
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
        title: Text('Membres'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _removeSelectedContacts,
            )
          else
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // TODO: use the AddDiscussionScreen component to select contacts
                    builder: (context) => AddDiscussionScreen(),
                  ),
                ).then((_) => _loadParticipants());
              },
              child: Text(
                'AJOUTER',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Liste des membres',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final contact = participants[index];
                final isSelected = selectedContacts.contains(contact);

                return Container(
                  color: isSelected
                      ? theme.colorScheme.primary.withOpacity(0.2)
                      : null,
                  child: Column(
                    children: [
                      ContactTile(
                        contact: contact,
                        onLongPress: () {
                          if (!isEditMode) _toggleEditMode();
                          _toggleSelection(contact);
                        },
                        onTap:
                            isEditMode ? () => _toggleSelection(contact) : null,
                      ),
                    ],
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
