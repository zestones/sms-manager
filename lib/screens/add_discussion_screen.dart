import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/screens/group_selection_screen.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/discussion_service.dart';
import 'package:namer_app/widgets/large_ink_well_button.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';
import 'package:provider/provider.dart';

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
    print('Filtering contacts with query: $query');
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
              SearchBar(
                controller: _searchController,
                hintText: 'Rechercher des contacts',
                onChanged: (value) => {},
                onFocusChange: (value) =>
                    setState(() => isSearchBarFocused = value),
              ),
              SelectedContactsView(
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
              ContactsListView(
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
                  print('Removed ${option.name}');
                  setState(() {
                    _filterOptions.remove(option);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SelectedContactsView extends StatelessWidget {
  final List<Contact> selectedContacts;
  final ScrollController scrollController;

  SelectedContactsView({
    required this.selectedContacts,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return selectedContacts.isNotEmpty
        ? Column(
            children: [
              SizedBox(height: 16.0),
              SizedBox(
                height: 80.0,
                child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedContacts.length,
                  itemBuilder: (context, index) {
                    final contact = selectedContacts[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              contact.firstName[0],
                              style:
                                  TextStyle(color: theme.colorScheme.onPrimary),
                            ),
                          ),
                        ),
                        Text(
                          contact.firstName,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}

class ContactsListView extends StatelessWidget {
  final List<Contact> filteredContacts;
  final List<Contact> selectedContacts;
  final Function(Contact) onContactTap;
  final Function(Contact, bool) onCheckboxChanged;

  ContactsListView({
    required this.filteredContacts,
    required this.selectedContacts,
    required this.onContactTap,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          final contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                contact.firstName[0],
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Text('${contact.firstName} ${contact.lastName}'),
                Spacer(),
                Checkbox(
                  value: selectedContacts.contains(contact),
                  onChanged: (bool? value) =>
                      onCheckboxChanged(contact, value!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  checkColor: theme.colorScheme.primary,
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),
            onTap: () => onContactTap(contact),
          );
        },
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(bool) onFocusChange;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFocusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 40.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.onBackground),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () => onFocusChange(true),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: theme.colorScheme.secondary),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
            suffixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
          ),
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
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
