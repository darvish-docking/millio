import 'package:flutter/material.dart';
import 'package:millio/features/auth/presentation/screens/loading_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food & Beverage App',

      /// 🔹 App Theme (basic for now)
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      /// 🔹 First Screen
      home: const LoadingScreen(),
    );
  }
}