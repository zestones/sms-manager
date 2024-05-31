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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.discussion.name),
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
                return Column(
                  children: [
                    SizedBox(height: 8),
                    ContactTile(contact: participants[index]),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
