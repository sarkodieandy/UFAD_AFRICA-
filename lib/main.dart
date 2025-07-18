import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/SuppliersProvider.dart';

// Providers
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/providers/dashboard_provider.dart';
import 'package:ufad/providers/category_provider.dart';
import 'package:ufad/providers/product_provider.dart';

import 'package:ufad/providers/loan_provider.dart';
import 'package:ufad/providers/repayment_provider.dart';
import 'package:ufad/providers/pos_provider.dart';
import 'package:ufad/providers/inventory_provider.dart';
import 'package:ufad/providers/payment_provider.dart';
import 'package:ufad/screens/AddSupplierScreen.dart';
import 'package:ufad/screens/add_onscreen/EditSupplierScreen.dart';
import 'package:ufad/screens/add_onscreen/SupplierListScreen.dart';
import 'package:ufad/screens/add_onscreen/add_inventory_screen.dart';
import 'package:ufad/screens/add_onscreen/add_loan_screen.dart';
import 'package:ufad/screens/add_onscreen/add_payment_screen.dart';
import 'package:ufad/screens/add_onscreen/add_pos_screen.dart';
import 'package:ufad/screens/add_onscreen/add_product_screen.dart';
import 'package:ufad/screens/add_onscreen/add_repayment_screen.dart';

// Screens
import 'package:ufad/screens/splash.dart';
import 'package:ufad/screens/login_screen.dart';
import 'package:ufad/screens/registration_screen.dart';
import 'package:ufad/screens/home_screen.dart';
import 'package:ufad/screens/profile_screen.dart';
import 'package:ufad/screens/dashboard_screen.dart';
import 'package:ufad/screens/categories_screen.dart';

void main() {
  runApp(const UFADApp());
}

class UFADApp extends StatelessWidget {
  const UFADApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),

        /// ✅ ADD THIS:
        ChangeNotifierProvider(create: (_) => SupplierProvider()),

        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => RepaymentProvider()),
        ChangeNotifierProvider(create: (_) => PosProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UFAD Portal',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.green),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (_) => const SplashScreen());
            case '/login':
              return MaterialPageRoute(builder: (_) => const LoginScreen());
            case '/register':
              return MaterialPageRoute(
                builder: (_) => const RegistrationScreen(),
              );
            case '/dashboard':
              return MaterialPageRoute(builder: (_) => const DashboardScreen());
            case '/profile':
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            case '/categories':
              return MaterialPageRoute(builder: (_) => const CategoryScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/products':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder:
                    (_) => AddProductScreen(
                      categoryId: args['categoryId'] ?? 0,
                      categoryName: args['categoryName'] ?? '',
                    ),
              );
            case '/suppliers':
              return MaterialPageRoute(
                builder: (_) => const SupplierListScreen(),
              );
            case '/suppliers/add':
              return MaterialPageRoute(
                builder: (_) => const AddSupplierScreen(),
              );
            case '/suppliers/edit':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => EditSupplierScreen(supplier: args['supplier']),
              );
            case '/loans':
              return MaterialPageRoute(builder: (_) => const AddLoanScreen());
            case '/repayments':
              return MaterialPageRoute(
                builder: (_) => const AddRepaymentScreen(),
              );
            case '/pos':
              return MaterialPageRoute(builder: (_) => const AddPosScreen());
            case '/inventory':
              return MaterialPageRoute(
                builder: (_) => const AddInventoryScreen(),
              );
            case '/payments':
              return MaterialPageRoute(
                builder: (_) => const AddPaymentScreen(),
              );
            default:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
    );
  }
}
