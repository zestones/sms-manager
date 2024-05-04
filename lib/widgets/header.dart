import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.primaryColor,
  });

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'SMS Manager',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: primaryColor,
      toolbarHeight: 75,
      elevation: 6, // Add elevation for box shadow
      shadowColor: Colors.grey, // Set shadow color
    );
  }
}
