import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'screens/contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';

// Utils
import 'utils/file_helper.dart';

// Models
import 'package:namer_app/models/contact_list.dart';

// Widgets
import 'widgets/header.dart';
import 'widgets/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'SMS Manager',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromRGBO(48, 150, 207, 1)),
          fontFamily: 'Roboto',
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int _selectedIndex = 0;
  String filePath = '';

  int get selectedIndex => _selectedIndex;
  ContactList contactList = ContactList([]);

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void clearContactList() {
    contactList.clear();
    notifyListeners();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      filePath = file.path;
      contactList = FileHelper.getContactList(filePath);
      notifyListeners();
    }
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>(); // Watch MyAppState

    Widget page;
    switch (appState.selectedIndex) {
      case 0:
        page = HomeScreen();
        break;
      case 1:
        page = ContactsScreen();
        break;
      case 2:
        page = SettingsScreen();
        break;
      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return Scaffold(
      body: Column(
        children: [
          Header(primaryColor: Theme.of(context).primaryColor),
          Expanded(child: Container(child: page)),
          Navigation(),
        ],
      ),
    );
  }
}
