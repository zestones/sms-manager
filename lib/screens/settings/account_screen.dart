import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compte',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
          ),
        ),
        backgroundColor: theme.colorScheme.background,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
      ),
      body: Center(
        child: Text(
          'Details about Account',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
