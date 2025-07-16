// 📁 lib/screens/home_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/providers/sale_provider.dart';
import 'package:ufad/providers/transaction_provider.dart';
import 'package:ufad/providers/suppliers_provider.dart';
import 'package:ufad/screens/dashboard_screen.dart';
import 'package:ufad/screens/sales_list_screen.dart';
import 'package:ufad/screens/transactions_list_screen.dart';
import 'package:ufad/screens/supplier_list_screen.dart';
import 'package:ufad/screens/add_sale_screen.dart';
import 'package:ufad/screens/add_transaction_screen.dart';
import 'package:ufad/screens/add_supplier_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SalesListScreen(),
    TransactionsListScreen(),
    SupplierListScreen(),
  ];

  void _onTabTapped(int index) {
    if (kDebugMode) print('🔁 Tab tapped: $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    if (kDebugMode) print('➕ FAB pressed on index $_selectedIndex');
    switch (_selectedIndex) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddSaleScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddSupplierScreen()),
        );
        break;
      default:
        if (kDebugMode) print('ℹ️ No FAB action for tab index $_selectedIndex');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final saleProvider = context.read<SaleProvider>();
      final transactionProvider = context.read<TransactionProvider>();
      final suppliersProvider = context.read<SuppliersProvider>();

      if (kDebugMode) print('📦 Fetching initial data...');
      await Future.wait([
        saleProvider.fetchSales(),
        transactionProvider.fetchTransactions(),
        suppliersProvider.fetchSuppliers(),
      ]);
      if (kDebugMode) print('✅ Data fetched.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (auth.loading) {
      if (kDebugMode) print('⏳ Auth loading...');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user == null) {
      if (kDebugMode) print('❌ User is null, redirecting to login...');
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (kDebugMode) {
      print('✅ Logged in as: ${user.username}, Selected tab: $_selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              if (kDebugMode) print('🚪 Logging out...');
              await auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton:
          _selectedIndex == 0
              ? null
              : FloatingActionButton(
                heroTag:
                    'fab_$_selectedIndex', // ✅ give unique tag to avoid conflicts
                onPressed: _onFabPressed,
                backgroundColor: AppColors.green,
                child: const Icon(Icons.add),
              ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: 'Sales'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Suppliers'),
        ],
      ),
    );
  }
}
