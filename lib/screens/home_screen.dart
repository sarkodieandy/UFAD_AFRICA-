import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/core/constants/colors.dart';
import 'package:ufad/providers/SuppliersProvider.dart';
import 'package:ufad/providers/auth_provider.dart';
import 'package:ufad/screens/AddSupplierScreen.dart';
import 'package:ufad/screens/add_onscreen/SupplierListScreen.dart';

// Screens
import 'package:ufad/screens/dashboard_screen.dart';
import 'package:ufad/screens/category_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SupplierListScreen(),
    CategoryListScreen(),
  ];

  void _onSelectDrawerItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context); // close drawer
  }

  void _onFabPressed() {
    if (kDebugMode) print('➕ FAB pressed on index $_selectedIndex');

    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddSupplierScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("ℹ️ Action not available for this section"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SupplierProvider>(context, listen: false);
      provider.fetchSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user;

    if (auth.loading || user == null) {
      if (!auth.loading) {
        Future.microtask(() {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.username}'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppColors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 50,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.username,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _onSelectDrawerItem(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Suppliers'),
              onTap: () => _onSelectDrawerItem(1),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Products'),
              onTap: () => _onSelectDrawerItem(2),
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton:
          _selectedIndex == 1
              ? FloatingActionButton(
                heroTag: 'fab_supplier',
                onPressed: _onFabPressed,
                backgroundColor: AppColors.green,
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
