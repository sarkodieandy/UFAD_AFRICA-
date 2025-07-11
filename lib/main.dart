import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ufad/app_route.dart';
import 'package:ufad/provider/customer_provider.dart';
import 'package:ufad/provider/dashboard_provider.dart';
import 'package:ufad/provider/payment_provider.dart';
import 'package:ufad/provider/pos_provider.dart';
import 'package:ufad/provider/product_provider.dart';
import 'package:ufad/provider/registration_provider.dart';
import 'package:ufad/provider/stock_provider.dart';
import 'package:ufad/provider/supplier_provider.dart';
import 'package:ufad/provider/theme_provider.dart';
import 'package:ufad/provider/user_provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add UserProvider here
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => PosProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => RegistrationProvider()),
      ],
      child: const UFADAfricaApp(),
    );
  }
}

class UFADAfricaApp extends StatelessWidget {
  const UFADAfricaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'UFAD Africa',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1BAEA6),
          secondary: Color(0xFF22C55E),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1BAEA6),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1BAEA6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF1BAEA6),
            side: const BorderSide(color: Color(0xFF1BAEA6)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1BAEA6),
          secondary: Color(0xFF22C55E),
          surface: Color(0xFF121212),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1BAEA6),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        // ... other dark theme configurations
      ),
      routes: appRoutes,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // Handle 404 or implement custom routing logic
        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text('Page not found!'))),
        );
      },
    );
  }
}
