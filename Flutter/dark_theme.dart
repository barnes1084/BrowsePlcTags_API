import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,  // Overall brightness of theme (dark mode)

    primaryColor: Color.fromARGB(255, 204, 13, 13),  // Background color for major UI parts like the AppBar

    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 231, 232, 233),  // Text color for floating action buttons, elevated buttons
      surface: Color.fromARGB(255, 56, 100, 136),  // Background color for floating action buttons, elevated buttons
      secondary: Color.fromARGB(255, 236, 238, 238),  // Color for interactive elements (e.g., slider, switches)
      onPrimary: Colors.white,  // Text/icon color on primary color backgrounds
      onSecondary: Color.fromARGB(255, 226, 226, 226),  // Text/icon color on secondary color backgrounds
    ),

    scaffoldBackgroundColor: Color.fromARGB(255, 48, 48, 48),  // Default background color for Scaffold widgets

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 56, 56, 56),  // Background color for AppBars
      elevation: 0,  // No shadow for a flat appearance
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color.fromARGB(255, 56, 56, 56),  // Background color for BottomNavigationBar
      selectedItemColor: Color.fromARGB(255, 238, 241, 241),  // Color for selected item in BottomNavigationBar
      unselectedItemColor: Colors.grey,  // Color for unselected items in BottomNavigationBar
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color.fromARGB(255, 243, 243, 245)),  // Default text color for larger text blocks
      bodyMedium: TextStyle(color: Color.fromARGB(255, 206, 226, 235)),  // Default text color for medium text blocks
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,  // Adapts density based on the platform (desktop vs mobile)
  );
}
