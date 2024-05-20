import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/main.dart';

class DataStorageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

    void selectStoragePath() async {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        appState.updateStoragePath(selectedDirectory);
      }
    }

    void selectContactFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        appState.filePath = file.path;
        // appState.contactList = FileHelper.getContactList(appState.filePath);
        // appState.filteredContactList = ContactList(appState.contactList.persons);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Données & Stockage',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: theme.colorScheme.background,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonOutline(
              theme: theme,
              appState: appState,
              callback: selectStoragePath,
              title: 'Emplacement de stockage',
              subtitle: 'Aucun chemin de stockage sélectionné'),
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(height: 7.0),
                Text(
                  'Le dossier sélectionné sera utilisé pour les sauvegardes et l\'exportation des contacts.',
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),

          // Container with button to create a backup or to restore a backup
          Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sauvegarde & Restauration',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 16.0,
                  ),
                ),

                // Save and restore buttons
                SizedBox(height: 20.0),
                DoubleButtonOutline(theme: theme),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            width: double.infinity,
            child: Text(
              'Importer des contacts',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontSize: 16.0,
              ),
            ),
          ),
          // Container with button to manage contacts
          ButtonOutline(
              theme: theme,
              appState: appState,
              title: 'Importer des contacts',
              subtitle: 'Aucun fichier de contacts sélectionné',
              callback: selectContactFile),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}

class DoubleButtonOutline extends StatelessWidget {
  const DoubleButtonOutline({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Add your logic for creating a backup
              },
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                bottomLeft: Radius.circular(50.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.onBackground,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Créer une sauvegarde',
                    style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Add your logic for restoring a backup
              },
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.onBackground,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Restaurer une sauvegarde',
                    style: TextStyle(
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonOutline extends StatelessWidget {
  const ButtonOutline({
    super.key,
    required this.theme,
    required this.appState,
    required this.title,
    required this.subtitle,
    required this.callback,
  });

  final ThemeData theme;
  final MyAppState appState;
  final String title;
  final String subtitle;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.surface,
      child: InkWell(
        onTap: () => callback(),
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onBackground,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
