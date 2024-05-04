import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:namer_app/utils/file_helper.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your settings here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                FileHelper.getFileName(appState.filePath),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: ElevatedButton(
                onPressed: appState.pickFile,
                child: Text('Import File'),
              ),
            ),
            Divider(),
            // Add a button to clear the list of persons
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: appState.clearContactList,
                child: Text('Clear Persons'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
