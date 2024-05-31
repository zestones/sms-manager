import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';

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
