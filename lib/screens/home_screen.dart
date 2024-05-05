import 'package:flutter/material.dart';
import 'package:namer_app/utils/sms_helper.dart';
import 'package:provider/provider.dart';

import 'package:filter_list/filter_list.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedCategories = [];
  String message = '';

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => openFilterDialog(context, appState),
            tooltip: 'Filter Messages',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(),
          SelectedCategoriesDisplay(
            selectedCategories: selectedCategories,
            onCategoryRemoved: (category) {
              setState(() => selectedCategories.remove(category));
            },
          ),
          Divider(),
          TextArea(onTextChanged: (text) {
            setState(() {
              message = text; // Update the message when text changes
            });
          }),
          SendButton(message: message),
        ],
      ),
    );
  }

  void openFilterDialog(BuildContext context, MyAppState appState) async {
    await FilterListDialog.display<String>(
      context,
      listData: appState.contactList.categories.toList(),
      selectedListData: selectedCategories,
      height: MediaQuery.of(context).size.height * 0.8,
      headlineText: "Select Categories",
      choiceChipLabel: (item) => item,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (category, query) {
        return category.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() => selectedCategories = List.from(list!));
        Navigator.pop(context);

        var filteredContacts = appState.contactList.persons.where((person) {
          return person.categories
              .any((category) => selectedCategories.contains(category));
        }).toList();

        appState.filteredContactList.persons = filteredContacts;
      },
    );
  }
}

class SendButton extends StatelessWidget {
  final String message;

  const SendButton({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {
          SmsHelper.sendSms(
              message,
              appState.filteredContactList.persons
                  .map((person) => person.phoneNumber)
                  .toList());
        },
        child: Text('Send Message'),
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  final ValueChanged<String> onTextChanged; // Callback to notify text changes

  const TextArea({
    required this.onTextChanged, // Require the callback parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          onChanged: onTextChanged, // Call the callback when text changes
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Type your message here',
            alignLabelWithHint: true,
          ),
          maxLines: null, // Allow unlimited lines
          minLines: 6, // Adjust minimum lines for better usability
        ),
      ),
    );
  }
}

class SelectedCategoriesDisplay extends StatefulWidget {
  final List<String> selectedCategories;
  final Function(String) onCategoryRemoved;

  SelectedCategoriesDisplay({
    required this.selectedCategories,
    required this.onCategoryRemoved,
  });

  @override
  State<SelectedCategoriesDisplay> createState() =>
      _SelectedCategoriesDisplayState();
}

class _SelectedCategoriesDisplayState extends State<SelectedCategoriesDisplay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300), // Adjust duration as needed
      height: _isExpanded ? 50 : 0,
      child: _isExpanded
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.selectedCategories.map((category) {
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: Chip(
                    label: Text(category),
                    deleteIconColor: Colors.red,
                    onDeleted: () {
                      // Call the callback function to remove the category
                      widget.onCategoryRemoved(category);
                    },
                  ),
                );
              }).toList(),
            )
          : null,
    );
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.selectedCategories.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant SelectedCategoriesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isExpanded = widget.selectedCategories.isNotEmpty;
  }
}
