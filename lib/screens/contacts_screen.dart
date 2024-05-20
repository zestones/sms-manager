// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:filter_list/filter_list.dart';

// import '../main.dart';
// import '../models/contact.dart';

// class ContactsScreen extends StatefulWidget {
//   @override
//   State<ContactsScreen> createState() => _ContactsScreenState();
// }

// class _ContactsScreenState extends State<ContactsScreen> {
//   List<String> selectedCategories = [];

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Contacts',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list),
//             onPressed: () => openFilterDialog(context, appState),
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: appState.filteredContactList.persons.length,
//         itemBuilder: (context, index) {
//           var person = appState.filteredContactList.persons[index];
//           return Contact(person: person);
//         },
//       ),
//     );
//   }

//   void openFilterDialog(BuildContext context, MyAppState appState) async {
//     await FilterListDialog.display<String>(
//       context,
//       listData: appState.contactList.categories.toList(),
//       selectedListData: selectedCategories,
//       height: MediaQuery.of(context).size.height * 0.8,
//       headlineText: "Select Categories",
//       choiceChipLabel: (item) => item,
//       validateSelectedItem: (list, val) => list!.contains(val),
//       onItemSearch: (category, query) {
//         return category.toLowerCase().contains(query.toLowerCase());
//       },
//       onApplyButtonClick: (list) {
//         setState(() => selectedCategories = List.from(list!));
//         Navigator.pop(context);

//         var filteredContacts = appState.contactList.persons.where((person) {
//           return person.categories
//               .any((category) => selectedCategories.contains(category));
//         }).toList();

//         appState.filteredContactList.persons = filteredContacts;
//       },
//     );
//   }
// }

// class Contact extends StatelessWidget {
//   const Contact({
//     Key? key,
//     required this.person,
//   }) : super(key: key);

//   final Person person;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text('${person.firstName} ${person.lastName}'),
//       subtitle: Text(person.phoneNumber),
//       trailing: Wrap(
//         spacing: 12,
//         children: person.categories
//             .map((category) => Chip(label: Text(category)))
//             .toList(),
//       ),
//     );
//   }
// }
