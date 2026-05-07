import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:millio/core/providers/theme_provider.dart';
import 'package:millio/core/theme/dark_theme.dart';
import 'package:millio/core/theme/light_theme.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/loading_screen.dart';
import 'package:millio/features/cart/presentation/providers/cart_provider.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:millio/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Lock Orientation to Portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..setTheme(isDarkMode),
        ),
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

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food & Beverage App',

      theme: lightTheme,      // 🌞 Light theme
      darkTheme: darkTheme,   // 🌙 Dark theme

      themeMode: themeProvider.themeMode, // 👈 THIS LINE

      /// 🔹 App Theme (basic for now)
      // theme: ThemeData(
      //   primarySwatch: Colors.green,
      // ),

      /// 🔹 First Screen
      home: const LoadingScreen(),
    );
  }
}