import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2F80ED),
    background: Color(0xFFFCFCFC),
    onBackground: Color(0xFF4F5E7B),
    secondary: Color(0xFFA7AFBE),
    tertiary: Color(0xFFE9F1FC),
  ),
  primaryColor: Color(0xFF2F80ED),
  scaffoldBackgroundColor: Color(0xFFFCFCFC),
  iconTheme: IconThemeData(
    color: Color(0xFF2F80ED),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4F5E7B)),
    bodyMedium: TextStyle(color: Color(0xFF4F5E7B)),
  ),
  fontFamily: 'Roboto',
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: Color.fromRGBO(48, 150, 207, 1),
    background: Color(0xFF121212),
    onBackground: Colors.white,
    secondary: Colors.grey,
    tertiary: Color(0xFF1E1E1E),
  ),
  primaryColor: Color.fromRGBO(48, 150, 207, 1),
  scaffoldBackgroundColor: Color(0xFF121212),
  iconTheme: IconThemeData(
    color: Color.fromRGBO(48, 150, 207, 1),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
  ),
  fontFamily: 'Roboto',
);
