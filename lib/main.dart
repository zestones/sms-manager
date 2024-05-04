import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/person.dart';
// import 'screens/settings_screen.dart';
import 'screens/contacts_screen.dart';
import 'screens/home_screen.dart';
import 'screens/settings_screen.dart';
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
  String filename = '';

  int get selectedIndex => _selectedIndex;
  List<Person> persons = [];

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void clearPersons() {
    persons.clear();
    notifyListeners();
  }

  void readPersons(String filePath) {
    try {
      File file = File(filePath);
      List<String> lines = file.readAsLinesSync();

      for (var line in lines) {
        List<dynamic> csvData = line.split(',');
        persons.add(Person.fromCsv(csvData));
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      filePath = result.files.single.path!;
      filename = result.files.single.name;
      readPersons(filePath);
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
