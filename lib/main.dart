import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
// import 'screens/contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';

// Utils
// import 'utils/file_helper.dart';

// Models
// import 'package:namer_app/models/contact_groups.dart';

// Widgets
// import 'widgets/header.dart';
import 'widgets/navigation.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2F80ED),
    background: Color(0xFFFCFCFC),
    onBackground: Color(0xFF4F5E7B),
    secondary: Color(0xFFA7AFBE),
  ),
  primaryColor: Color(0xFF2F80ED),
  scaffoldBackgroundColor: Color(0xFFFCFCFC),
  iconTheme: IconThemeData(
    color: Color(0xFF2F80ED),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4F5E7B)),
    bodyMedium: TextStyle(color: Color(0xFF4F5E7B)),
  ),
  fontFamily: 'Roboto',
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Color.fromRGBO(48, 150, 207, 1),
    background: Color(0xFF121212),
    onBackground: Colors.white,
    secondary: Colors.grey,
  ),
  primaryColor: Color.fromRGBO(48, 150, 207, 1),
  scaffoldBackgroundColor: Color(0xFF121212),
  iconTheme: IconThemeData(
    color: Color.fromRGBO(48, 150, 207, 1),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  fontFamily: 'Roboto',
);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'SMS Manager',
            theme: appState.isDarkTheme ? darkTheme : lightTheme,
            home: MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  int _selectedIndex = 0;
  String filePath = '';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  int get selectedIndex => _selectedIndex;
  // ContactGroup contactList = ContactGroup();
  // ContactGroup filteredContactList = ContactGroup([]);

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void clearContactList() {
    // contactList.clear();
    notifyListeners();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      filePath = file.path;
      // contactList = FileHelper.getContactList(filePath);
      // filteredContactList = ContactList(contactList.persons);
      notifyListeners();
    }
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
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
        page = HomeScreen();

        // page = ContactsScreen();
        break;
      case 2:
        page = SettingsScreen();
        break;
      default:
        throw UnimplementedError('no widget for $appState.selectedIndex');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          // Header(primaryColor: Theme.of(context).primaryColor),
          Expanded(child: Container(child: page)),
          Navigation(),
        ],
      ),
    );
  }
}
