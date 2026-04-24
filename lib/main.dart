import 'package:flutter/material.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/loading_screen.dart';
import 'package:millio/features/cart/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: const MyApp(),
    ),
    );
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