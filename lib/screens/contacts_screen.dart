import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/contact_list.dart';
import '../models/person.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  Set<String> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contacts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(
                  context, appState.contactList, selectedCategories);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your contacts list',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: appState.contactList.persons.length,
                itemBuilder: (context, index) {
                  var person = appState.contactList.persons[index];
                  bool isInsideSelected = false;
                  for (var category in selectedCategories) {
                    if (person.categories.contains(category)) {
                      isInsideSelected = true;
                      break;
                    }
                  }
                  if (isInsideSelected || selectedCategories.isEmpty) {
                    return Contact(person: person);
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ContactList contactList,
      Set<String> selectedCategories) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter by Category'),
          content: SingleChildScrollView(
            child: Column(
              children: contactList.getCategories().map((category) {
                return CategoryListTile(
                    category: category,
                    selectedCategories: selectedCategories,
                    onChanged: ((value) => setState(() {
                          if (value != null) {
                            if (value) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          }
                        })));
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Filter contacts here using selectedCategories set
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({
    Key? key,
    required this.category,
    required this.selectedCategories,
    required this.onChanged, // Add onChanged callback
  }) : super(key: key);

  final String category;
  final Set<String> selectedCategories;
  final ValueChanged<bool?> onChanged; // Define onChanged callback

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selectedCategories.contains(widget.category);

    return CheckboxListTile(
      title: Text(widget.category),
      value: isSelected,
      onChanged: widget.onChanged, // Use onChanged callback
    );
  }
}

class Contact extends StatelessWidget {
  const Contact({
    super.key,
    required this.person,
  });

  final Person person;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${person.firstName} ${person.lastName}'),
      subtitle: Text(person.phoneNumber),
      trailing: Wrap(
        spacing: 12,
        children: person.categories
            .map((category) => Chip(label: Text(category)))
            .toList(),
      ),
    );
  }
}
