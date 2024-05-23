import 'package:flutter/material.dart';
import 'package:namer_app/screens/settings/account_screen.dart';
import 'package:namer_app/screens/settings/data_storage_screen.dart';
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
              'Thème Sombre',
              style: TextStyle(color: theme.colorScheme.onBackground),
            ),
            trailing: Switch(
              value: appState.isDarkTheme,
              onChanged: (bool value) => appState.toggleTheme(),
              activeColor: theme.colorScheme.primary,
            ),
          ),
          SettingOption(
            theme: theme,
            pageRoute: AccountScreen(),
            title: 'Compte',
            icon: Icons.account_circle,
          ),
          SettingOption(
            theme: theme,
            pageRoute: DataStorageScreen(),
            title: 'Données & Stockage',
            icon: Icons.storage,
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}

class SettingOption extends StatelessWidget {
  const SettingOption({
    super.key,
    required this.theme,
    required this.pageRoute,
    required this.title,
    required this.icon,
  });

  final ThemeData theme;
  final Widget pageRoute;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: theme.colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onBackground,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageRoute),
        );
      },
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: theme.colorScheme.onBackground,
        size: 20,
      ),
    );
  }
}
