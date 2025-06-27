import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/app_route.dart';
import 'package:ufad/setup_business/provider/product_provider.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';
import 'package:ufad/providers/api_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Add other providers for the new screens as needed
      ],
      child: const UFADAfricaApp(),
    ),
  );
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
          primary: Color(0xFF1BAEA6), // Brand green
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
      initialRoute: '/', // Start with splash
    );
  }
}
