import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/models/group.dart';
import 'package:namer_app/service/contact_list_service.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatefulWidget {
  @override
  ContactsScreenState createState() => ContactsScreenState();
}

class ContactsScreenState extends State<ContactsScreen> {
  List<FilterOption> _filterOptions = [];

  Map<String, List<Contact>> groupContactByFirstLetter(List<Contact> contacts) {
    Map<String, List<Contact>> groupedContacts = {};
    for (var contact in contacts) {
      String firstLetter =
          contact.firstName.isNotEmpty ? contact.firstName[0] : '#';
      if (!groupedContacts.containsKey(firstLetter)) {
        groupedContacts[firstLetter] = [];
      }
      groupedContacts[firstLetter]!.add(contact);
    }
    return groupedContacts;
  }

  @override
  Widget build(BuildContext context) {
    final contactService = Provider.of<ContactService>(context, listen: false);
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts',
            style: TextStyle(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ContactSearchDelegate(contactService),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Contact>>(
        future: contactService.getAllContact(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No contacts found.'));
          } else {
            return FutureBuilder<List<Contact>>(
              future: contactService.getAllContact(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No contacts found.'));
                } else {
                  return FutureBuilder<List<Contact>>(
                    future: _applyFilter(),
                    builder: (context, filterSnapshot) {
                      if (filterSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (filterSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${filterSnapshot.error}'));
                      } else {
                        var filteredContacts = filterSnapshot.data!;
                        filteredContacts.sort((a, b) => a.firstName
                            .toLowerCase()
                            .compareTo(b.firstName.toLowerCase()));

                        Map<String, List<Contact>> groupedContacts =
                            groupContactByFirstLetter(filteredContacts);

                        return ListView.builder(
                          itemCount: groupedContacts.length * 2 - 1,
                          itemBuilder: (context, index) {
                            if (index.isOdd) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                              );
                            } else {
                              // Header or ContactTile
                              int headerIndex = index ~/ 2;
                              String letter =
                                  groupedContacts.keys.toList()[headerIndex];
                              return _buildHeaderOrContactTile(
                                  letter, groupedContacts[letter]!);
                            }
                          },
                        );
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildHeaderOrContactTile(String letter, List<Contact> contacts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            letter,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Column(
              children: [
                SizedBox(height: 8),
                ContactTile(contact: contact),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showFilterOptions(BuildContext context) {
    final groupService = Provider.of<GroupService>(context, listen: false);
    var theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: theme.colorScheme.surface,
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => _filterOptions = []);
                        Navigator.pop(context);
                      },
                      child: Text('Réinitialiser'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(
                            () => _filterOptions = _filterOptions.toList());
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            theme.colorScheme.onBackground),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            theme.colorScheme.background),
                      ),
                      child: Text('Filter'),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              FutureBuilder<List<Group>>(
                future: groupService.getAllGroup(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No groups found.'));
                  } else {
                    final groups = snapshot.data!;
                    // Initialize filter options if not initialized yet
                    if (_filterOptions.isEmpty) {
                      _filterOptions = List.generate(groups.length, (index) {
                        return FilterOption(
                          groups[index].name,
                          groups[index].id,
                        );
                      });
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        final filterOption = _filterOptions[index];
                        return TriStateCheckbox(
                          title: group.name,
                          value: filterOption.state,
                          onChanged: (state) =>
                              _filterOptions[index].state = state!,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Contact>> _applyFilter() async {
    final contactListService =
        Provider.of<ContactListService>(context, listen: false);

    for (var filterOption in _filterOptions) {
      print(
          "> : ${filterOption.state} - ${filterOption.id} - ${filterOption.name}");
    }

    List<Contact> filteredContacts =
        await contactListService.getContactListByGroups(_filterOptions);

    contactListService
        .getContactListByGroups(_filterOptions)
        .then((value) => print(value));

    return filteredContacts;
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
  });

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          contact.firstName.isNotEmpty
              ? contact.firstName[0].toUpperCase()
              : '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        '${contact.firstName} ${contact.lastName}',
        style: TextStyle(
          color: theme.colorScheme.onBackground,
        ),
      ),
      subtitle: Text(contact.phoneNumber,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
          )),
    );
  }
}

class ContactSearchDelegate extends SearchDelegate {
  final ContactService contactService;

  ContactSearchDelegate(this.contactService);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: contactService.getAllContact(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No contacts found.'));
        } else {
          final contacts = snapshot.data!;
          final filteredContacts = contacts.where((contact) {
            final fullName =
                '${contact.firstName} ${contact.lastName}'.toLowerCase();
            return fullName.contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: filteredContacts.length,
            itemBuilder: (context, index) {
              final contact = filteredContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    contact.lastName.isNotEmpty
                        ? contact.lastName[0].toUpperCase()
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text('${contact.firstName} ${contact.lastName}'),
                subtitle: Text(contact.phoneNumber),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
