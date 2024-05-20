import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/logo.png',
              height: 90,
              width: 90,
            ),
            SizedBox(height: 5),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onBackground,
              ),
            ),
            SizedBox(height: 10),
            Divider(
              color: theme.colorScheme.onBackground,
              thickness: 1,
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 150,
        backgroundColor: theme.colorScheme.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.brightness_6,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Dark Theme',
              style: TextStyle(
                color: theme.colorScheme.onBackground,
              ),
            ),
            trailing: Switch(
              value: appState.isDarkTheme,
              onChanged: (bool value) {
                appState.toggleTheme();
              },
              activeColor: theme.colorScheme.primary,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Account',
              style: TextStyle(
                color: theme.colorScheme.onBackground,
              ),
            ),
            onTap: () {
              // Navigator.pushNamed(context, '/language');
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onBackground,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.storage,
              color: theme.colorScheme.primary,
            ),
            title: Text(
              'Data & Storage',
              style: TextStyle(
                color: theme.colorScheme.onBackground,
              ),
            ),
            onTap: () {
              // Navigator.pushNamed(context, '/storage');
            },
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
