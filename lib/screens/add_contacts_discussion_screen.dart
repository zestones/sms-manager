import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/discussion_participant_service.dart';
import 'package:namer_app/widgets/contacts_selection_container.dart';
import 'package:namer_app/widgets/selected_contacts_scroll_container.dart';
import 'package:namer_app/widgets/styled_search_bar.dart';
import 'package:provider/provider.dart';

class AddContactsDiscussionScreen extends StatefulWidget {
  final Discussion discussion;

  AddContactsDiscussionScreen({required this.discussion});

  @override
  AddContactsDiscussionScreenState createState() =>
      AddContactsDiscussionScreenState();
}

class AddContactsDiscussionScreenState
    extends State<AddContactsDiscussionScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool isSearchBarFocused = false;

  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];
  @override
  void initState() {
    super.initState();
    _loadParticipants();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  void _loadContacts() async {
    final contactService = Provider.of<ContactService>(context, listen: false);
    final contacts = await contactService.getAllContact();
    setState(() {
      contacts.sort((a, b) => a.firstName.compareTo(b.firstName));
      allContacts = contacts;
      filteredContacts = contacts;
    });
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
          selectedContacts.clear();
          selectedContacts.addAll(contacts);
        });
      },
    );
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredContacts = allContacts.where((contact) {
        final fullName =
            '${contact.firstName} ${contact.lastName}'.toLowerCase();
        return fullName.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToRightmost() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _updateDiscussionContacts() {
    final discussionParticipantService =
        Provider.of<DiscussionParticipantService>(context, listen: false);
    final discussionId = widget.discussion.id!;
    final contacts = selectedContacts.map((c) => c.id).toList();
    discussionParticipantService
        .updateDiscussionParticipants(
          discussionId,
          contacts,
        )
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouter des contacts',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StyledSearchBar(
            controller: _searchController,
            hintText: 'Rechercher des contacts',
            onChanged: (value) => {},
            onFocusChange: (value) =>
                setState(() => isSearchBarFocused = value),
          ),
          SelectedContactsScrollContainer(
            selectedContacts: selectedContacts,
            scrollController: _scrollController,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Suggestions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondary,
                fontSize: 12.0,
              ),
            ),
          ),
          ContactsSelectionContainer(
            filteredContacts: filteredContacts,
            selectedContacts: selectedContacts,
            onContactTap: (contact) {
              setState(() {
                if (selectedContacts.contains(contact)) {
                  selectedContacts.remove(contact);
                } else {
                  selectedContacts.add(contact);
                  _scrollToRightmost();
                }
              });
            },
            onCheckboxChanged: (contact, isSelected) {
              setState(() {
                if (isSelected) {
                  selectedContacts.add(contact);
                  _scrollToRightmost();
                } else {
                  selectedContacts.remove(contact);
                }
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateDiscussionContacts(),
        child: Icon(Icons.check),
      ),
    );
  }
}
