import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/app_route.dart'; // Your route map
import 'package:ufad/providers/language_provider.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart'; // <-- Add this

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final langProvider = LanguageProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: langProvider),
        ChangeNotifierProvider(
          create: (_) => RegistrationProvider(),
        ), // <-- Add this!
      ],
      child: const UFADAfricaApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      await langProvider.loadSavedLanguage();
    } catch (e) {
      print('Error loading saved language: $e');
    }
  });
}

class UFADAfricaApp extends StatelessWidget {
  const UFADAfricaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return Directionality(
          textDirection:
              langProvider.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: MaterialApp(
            title: 'UFAD Africa',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: const Color(0xFF007BFF),
              scaffoldBackgroundColor: const Color(0xFFF9F9F9),
              fontFamily: 'Arial',
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF007BFF),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF007BFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF007BFF),
                  side: const BorderSide(color: Color(0xFF007BFF)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            locale: langProvider.locale,
            routes: appRoutes,
            initialRoute: '/', // Start with splash
          ),
        );
      },
    );
  }
}
