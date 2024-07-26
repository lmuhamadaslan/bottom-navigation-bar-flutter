import 'package:flutter/material.dart';

import 'basic_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme:
            ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        // home: const BasicBottomNavbar());
        // home: const PreservingNav());
        // home: const WithTabbar());
        home: const HideNavigationBar());
  }
}
