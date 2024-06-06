import 'package:flutter/material.dart';
import 'package:namer_app/models/contact.dart';

class SelectedContactsScrollContainer extends StatelessWidget {
  final List<Contact> selectedContacts;
  final ScrollController scrollController;

  SelectedContactsScrollContainer({
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
