import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';

// Providers
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/providers/dashboard_provider.dart';
import 'package:ufad/providers/category_provider.dart';
import 'package:ufad/providers/product_provider.dart';
import 'package:ufad/providers/sale_provider.dart';
import 'package:ufad/providers/transaction_provider.dart';
import 'package:ufad/providers/suppliers_provider.dart';

// Screens
import 'package:ufad/screens/add_sale_screen.dart';
import 'package:ufad/screens/add_supplier_screen.dart';
import 'package:ufad/screens/add_transaction_screen.dart';
import 'package:ufad/screens/edit_sale_screen.dart';
import 'package:ufad/screens/edit_transaction.dart';
import 'package:ufad/screens/edit_supplier_screen.dart';
import 'package:ufad/screens/home_screen.dart';
import 'package:ufad/screens/sales_list_screen.dart';
import 'package:ufad/screens/splash.dart';
import 'package:ufad/screens/login_screen.dart';
import 'package:ufad/screens/registration_screen.dart';
import 'package:ufad/screens/dashboard_screen.dart';
import 'package:ufad/screens/profile_screen.dart';
import 'package:ufad/screens/categories_screen.dart';
import 'package:ufad/screens/products_screen.dart';
import 'package:ufad/screens/supplier_list_screen.dart';
import 'package:ufad/screens/transactions_list_screen.dart';

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
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SuppliersProvider()),
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
              return MaterialPageRoute(builder: (_) => const RegistrationScreen());
            case '/dashboard':
              return MaterialPageRoute(builder: (_) => const DashboardScreen());
            case '/profile':
              return MaterialPageRoute(builder: (_) => const ProfileScreen());
            case '/categories':
              return MaterialPageRoute(builder: (_) => const CategoryScreen());
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeScreen());
            case '/products':
              final categoryId = settings.arguments as int? ?? 0;
              return MaterialPageRoute(
                builder: (_) => ProductScreen(categoryId: categoryId, categoryName: ''),
              );
            case '/sales':
              return MaterialPageRoute(builder: (_) => const SalesListScreen());
            case '/sales/add':
              return MaterialPageRoute(builder: (_) => const AddSaleScreen());
            case '/sales/edit':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => EditSaleScreen(sale: args['sale']),
              );
            case '/transactions':
              return MaterialPageRoute(builder: (_) => const TransactionsListScreen());
            case '/transactions/add':
              return MaterialPageRoute(builder: (_) => const AddTransactionScreen());
            case '/transactions/edit':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => EditTransactionScreen(transaction: args['transaction']),
              );
            case '/suppliers':
              return MaterialPageRoute(builder: (_) => const SupplierListScreen());
            case '/suppliers/add':
              return MaterialPageRoute(builder: (_) => const AddSupplierScreen());
            case '/suppliers/edit':
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (_) => EditSupplierScreen(supplier: args['supplier']),
              );
            default:
              return MaterialPageRoute(builder: (_) => const SplashScreen());
          }
        },
      ),
    );
  }
}
