import 'package:flutter/material.dart';

class LargeInkWellButton extends StatelessWidget {
  const LargeInkWellButton({
    super.key,
    required this.theme,
    required this.title,
    required this.subtitle,
    required this.callback,
  });

  final ThemeData theme;
  final String title;
  final String subtitle;
  final Function callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.colorScheme.background,
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
