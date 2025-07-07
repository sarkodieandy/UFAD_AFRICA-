import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/app_route.dart';
import 'package:ufad/setup_business/provider/product_provider.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';
import 'package:ufad/providers/api_provider.dart';

void main() {
  // Only use async if you have actual async setup to do.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Add other providers here, but prefer to keep to essentials!
      ],
      child: const UFADAfricaApp(),
    );
  }
  
}

class UFADAfricaApp extends StatelessWidget {
  const UFADAfricaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UFAD Africa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1BAEA6),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1BAEA6),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1BAEA6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1BAEA6),
            side: const BorderSide(color: Color(0xFF1BAEA6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      routes: appRoutes,
      initialRoute: '/', // Splash screen
    );
  }
}
