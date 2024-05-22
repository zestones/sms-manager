import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:namer_app/service/contact_list_service.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:namer_app/service/load_csv_contact_list_service.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/main.dart';

class DataStorageScreen extends StatelessWidget {
  final Key bodyKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    final loadCSVContactListService =
        Provider.of<LoadCSVContactListService>(context, listen: false);

    final contactListService =
        Provider.of<ContactListService>(context, listen: false);

    final contactService = Provider.of<ContactService>(context, listen: false);
    final groupService = Provider.of<GroupService>(context, listen: false);

    void selectStoragePath() async {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      if (selectedDirectory != null) {
        appState.updateStoragePath(selectedDirectory);
      }
    }

    void selectContactFile() async {
      if (appState.isImportingFile) {
        // TODO : move this to a popup widget ?
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Un fichier est déjà en cours d\'importation...'),
          duration: Duration(seconds: 2),
          backgroundColor: theme.colorScheme.primary,
          action: SnackBarAction(
            label: 'Fermer',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ));

        return;
      }

      appState.setImportingFile(true);
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null) {
        try {
          File file = File(result.files.single.path!);
          appState.filePath = file.path;
          await appState.insertContactsIntoDb(loadCSVContactListService, file);
        } finally {
          appState.setImportingFile(false);
        }
      } else {
        appState.setImportingFile(false);
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
        key: bodyKey,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ButtonOutline(
              theme: theme,
              appState: appState,
              callback: selectStoragePath,
              title: 'Emplacement de stockage',
              subtitle: 'Aucun chemin de stockage sélectionné'),
          InfosNote(
            theme: theme,
            text:
                'Le dossier sélectionné sera utilisé pour les sauvegardes et l\'exportation des contacts.',
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
            title: 'Importer un fichier de contacts',
            subtitle: 'Uniquement au format CSV',
            callback: selectContactFile,
          ),

          Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            width: double.infinity,
            child: Text(
              'Base de données',
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
            title: 'Supprimer tous les contacts',
            subtitle: 'Supprime tous les contacts de la base de données',
            callback: () {
              // pop up a dialog to confirm the deletion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Supprimer tous les contacts'),
                    content: Text(
                        'Êtes-vous sûr de vouloir supprimer tous les contacts ?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          // TODO : implement the deletion of all data from the database
                          contactService.deleteAllContact();
                          groupService.deleteAllGroup();
                          contactListService.deleteAllContactList();

                          Navigator.of(context).pop();
                        },
                        child: Text('Confirmer'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}

class InfosNote extends StatelessWidget {
  const InfosNote({
    super.key,
    required this.theme,
    required this.text,
  });

  final ThemeData theme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            text,
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
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
