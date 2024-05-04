import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

class ContactsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: appState.persons.length,
              itemBuilder: (context, index) {
                var person = appState.persons[index];
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
