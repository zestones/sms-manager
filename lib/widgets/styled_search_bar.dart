import 'package:flutter/material.dart';

class StyledSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(bool) onFocusChange;

  const StyledSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFocusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 40.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.onBackground),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () => onFocusChange(true),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: theme.colorScheme.secondary),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
            suffixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
          ),
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
      ),
    );
  }
}
