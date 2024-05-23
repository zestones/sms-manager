import 'dart:io';

import 'package:namer_app/service/service_injection.dart';
import 'package:namer_app/screens/contacts_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// Services
import 'package:namer_app/service/load_csv_contact_list_service.dart';
import 'package:namer_app/service/local_notification_service.dart';

// Screens
import 'screens/settings/main_settings_screen.dart';
import 'screens/home_screen.dart';

// Utils
import 'package:namer_app/utils/database_helper.dart';
import 'package:namer_app/utils/themes.dart';

// Widgets
import 'widgets/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();

  final databaseHelper = DatabaseHelper();
  await databaseHelper.init();

  runApp(
    MultiProvider(
      providers: ServiceInjection.inject(databaseHelper),
      child: MyApp(),
    ),
  );
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
  String storagePath = '';

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  int get selectedIndex => _selectedIndex;
  bool _isImportingFile = false;
  bool get isImportingFile => _isImportingFile;

  void setImportingFile(bool value) {
    _isImportingFile = value;
    notifyListeners();
  }

  Future<void> insertContactsIntoDb(
      LoadCSVContactListService loadCSVContactListService, File file) async {
    setImportingFile(true);

    try {
      // Call the service to load contacts from the CSV file
      await loadCSVContactListService.call(file.path);

      // Notify success (Optional: Use notifications or other methods)
      await LocalNotificationService.showNotification(
        title: 'Importation terminée',
        body: 'Tous les contacts ont été importés avec succès.',
        payload: 'contacts_imported',
      );
    } catch (e) {
      print('Error importing contacts: $e');

      // Handle errors (Optional: Use notifications or other methods)
      await LocalNotificationService.showNotification(
        title: 'Erreur d\'importation',
        body: 'Une erreur s\'est produite lors de l\'importation des contacts.',
        payload: 'contacts_import_error',
      );
    } finally {
      setImportingFile(false);
    }
  }

  void updateActivePageIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void clearContactList() {
    // contactList.clear();
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void updateStoragePath(String path) {
    storagePath = path;
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
        page = ContactsScreen();
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
        ],
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
