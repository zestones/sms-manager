import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';

class ContactsSelectionContainer extends StatelessWidget {
  final List<Contact> filteredContacts;
  final List<Contact> selectedContacts;
  final Function(Contact) onContactTap;
  final Function(Contact, bool) onCheckboxChanged;

  ContactsSelectionContainer({
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
                contact.firstName.isNotEmpty ? contact.firstName[0] : '?',
                style: TextStyle(color: Colors.white),
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${contact.firstName} ${contact.lastName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
