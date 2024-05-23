import 'package:flutter/material.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';

class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);

    return NavigationBar(
        backgroundColor: theme.colorScheme.background,
        animationDuration: const Duration(milliseconds: 500),
        selectedIndex: appState.selectedIndex,
        onDestinationSelected: (index) => appState.updateActivePageIndex(index),
        indicatorColor: theme.colorScheme.onBackground.withOpacity(0.2),
        destinations: [
          NavigationItem(title: 'Messages', icon: Icons.message),
          NavigationItem(title: 'Contacts', icon: Icons.people),
          NavigationItem(title: 'Settings', icon: Icons.settings),
        ]);
  }
}

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return NavigationDestination(
      icon: Icon(icon, color: theme.colorScheme.secondary),
      selectedIcon: Icon(icon, color: theme.colorScheme.primary),
      label: title,
    );
  }
}
