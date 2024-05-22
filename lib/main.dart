import 'dart:io';

import 'package:namer_app/service/contact_list_service.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// Services
import 'package:namer_app/service/load_csv_contact_list_service.dart';
import 'package:namer_app/service/local_notification_service.dart';

// Screens
// import 'screens/contacts_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/home_screen.dart';

import 'package:namer_app/repositories/contact_list_repository.dart';
import 'package:namer_app/repositories/contact_repository.dart';
import 'package:namer_app/repositories/group_repository.dart';

// Utils
import 'package:namer_app/utils/database_helper.dart';

// Widgets
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.init();

  final databaseHelper = DatabaseHelper();
  await databaseHelper.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ContactListRepository>(
            create: (_) => ContactListRepository(databaseHelper)),
        Provider<ContactRepository>(
            create: (_) => ContactRepository(databaseHelper)),
        Provider<GroupRepository>(
            create: (_) => GroupRepository(databaseHelper)),

        // Initialize the services, depending on repositories
        ProxyProvider<ContactListRepository, ContactListService>(
          update: (context, contactListRepository, _) =>
              ContactListService(contactListRepository),
        ),
        ProxyProvider<ContactRepository, ContactService>(
          update: (context, contactRepository, _) =>
              ContactService(contactRepository),
        ),
        ProxyProvider<GroupRepository, GroupService>(
          update: (context, groupRepository, _) =>
              GroupService(groupRepository),
        ),

        ProxyProvider3<ContactListRepository, ContactRepository,
            GroupRepository, LoadCSVContactListService>(
          update: (
            context,
            contactListRepository,
            contactRepository,
            groupRepository,
            _,
          ) =>
              LoadCSVContactListService(
            contactListRepository,
            contactRepository,
            groupRepository,
          ),
        ),
      ],
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

  void setIndex(int index) {
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
