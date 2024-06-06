import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/screens/group_selection_screen.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/discussion_service.dart';
import 'package:namer_app/widgets/large_ink_well_button.dart';
import 'package:namer_app/widgets/styled_search_bar.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';
import 'package:provider/provider.dart';

import '../widgets/contacts_selection_container.dart';
import '../widgets/selected_contacts_scroll_container.dart';

class AddDiscussionScreen extends StatefulWidget {
  @override
  AddDiscussionScreenState createState() => AddDiscussionScreenState();
}

class AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final TextEditingController _discussionNameController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<FilterOption> _filterOptions = [];
  bool isSearchBarFocused = false;

  List<Contact> allContacts = [];
  List<Contact> filteredContacts = [];
  List<Contact> selectedContacts = [];

  void _createDiscussion(BuildContext context) {
    String discussionName = _discussionNameController.text.trim();
    if (discussionName.isNotEmpty &&
        (_filterOptions.isNotEmpty || selectedContacts.isNotEmpty)) {
      final discussionService =
          Provider.of<DiscussionService>(context, listen: false);

      discussionService
          .createDiscussion(
        discussionName,
        _filterOptions,
        selectedContacts.map((contact) => contact.id).toList(),
      )
          .then((id) {
        if (mounted) {
          Navigator.pop(context, {'id': id, 'name': discussionName});
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Entrez un nom de discussion et sélectionnez des contacts'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToGroupSelection(BuildContext context) async {
    final selectedGroups = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              GroupSelectionScreen(filterOptions: _filterOptions)),
    );

    if (selectedGroups != null) {
      setState(() {
        _filterOptions = selectedGroups;
      });
    }
  }

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nouvelle Discussion',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _createDiscussion(context),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            child: Text('Créer'),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSearchBarFocused) ...[
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  width: double.infinity,
                  child: TextField(
                    controller: _discussionNameController,
                    decoration: InputDecoration(
                      labelText: 'Nom de la discussion',
                      focusColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                if (_filterOptions.isNotEmpty) displaySelectedGroups(),
                LargeInkWellButton(
                    theme: theme,
                    title: 'Ajouter des groupes',
                    subtitle: 'Sélectionner des groupes pour la discussion',
                    icon: Icon(Icons.arrow_forward_sharp),
                    callback: () => _navigateToGroupSelection(context)),
                SizedBox(height: 6.0),
              ],
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
        ],
      ),
    );
  }

  SingleChildScrollView displaySelectedGroups() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            children: _filterOptions.map((option) {
              return GroupChip(
                option: option,
                onDelete: (option) {
                  setState(() => _filterOptions.remove(option));
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class GroupChip extends StatelessWidget {
  const GroupChip({
    Key? key,
    required this.option,
    required this.onDelete,
  }) : super(key: key);

  final FilterOption option;
  final Function(FilterOption) onDelete;

  @override
  Widget build(BuildContext context) {
    var color = (option.state == TriCheckboxEnum.checked)
        ? Colors.blue
        : (option.state == TriCheckboxEnum.excluded)
            ? Colors.orange
            : Colors.red;
    return InputChip(
      label: Text(option.name, style: TextStyle(color: color)),
      onDeleted: () => onDelete(option),
      deleteIconColor: color,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(color: color),
      ),
    );
  }
}
