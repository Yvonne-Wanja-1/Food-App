import 'package:eat/tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:eat/categories.dart'; // Import the categories.dart file

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    // use fromSeed to generate a color scheme that is based on a seed color
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 203, 26, 188),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const App()); //must always be included to run the app
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const TabScreen(), // Start with the CategoriesScreen
    );
  }
}
  