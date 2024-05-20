import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: appState.selectedIndex,
      onTap: (index) => appState.setIndex(index),
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.secondary,
      backgroundColor: theme.colorScheme.background,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
