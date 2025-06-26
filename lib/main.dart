import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/app_route.dart';
import 'package:ufad/providers/language_provider.dart';
import 'package:ufad/setup_business/provider/product_provider.dart';
import 'package:ufad/setup_business/provider/registration_provider.dart';
import 'package:ufad/providers/api_provider.dart';

// You may also want providers for the new screens if you want state management for them.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final langProvider = LanguageProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>.value(value: langProvider),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ApiProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        // Add other providers for the new screens as needed
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
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF50C878),
                surface: Colors.white,
              ),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Arial',
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF50C878),
                foregroundColor: Colors.white,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF50C878),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF50C878),
                  side: const BorderSide(color: Color(0xFF50C878)),
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
