import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';

class ContactTile extends StatelessWidget {
  const ContactTile({
    Key? key,
    required this.contact,
    this.onLongPress,
    this.onTap,
  }) : super(key: key);

  final Contact contact;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      splashColor: theme.colorScheme.primary.withOpacity(0.2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor,
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
        subtitle: Text(
          contact.phoneNumber,
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontSize: 12.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
