import 'package:flutter/material.dart';

class LargeInkWellButton extends StatelessWidget {
  const LargeInkWellButton({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.callback,
    this.icon,
  });

  final ThemeData theme;
  final String title;
  final String subtitle;
  final Function callback;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: theme.colorScheme.onBackground,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: theme.colorScheme.secondary,
          fontSize: 12.0,
          fontStyle: FontStyle.italic,
        ),
      ),
      trailing: icon,
      onTap: () => callback(),
    );
  }
}
