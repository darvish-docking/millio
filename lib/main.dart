import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/loading_screen.dart';
import 'package:millio/features/cart/presentation/providers/cart_provider.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TabProvider(),
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