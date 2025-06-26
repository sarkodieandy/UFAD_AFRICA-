import 'package:flutter/material.dart';

const kGreen = Color(0xFF1BAEA6);

class DashboardDrawer extends StatelessWidget {
  final String? currentRoute;
  const DashboardDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kGreen,
      child: ListView(
        padding: const EdgeInsets.only(top: 40),
        children: [
          const ListTile(
            title: Text(
              'UFAD Portal',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _DrawerItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
            selected: currentRoute == '/dashboard',
          ),
          _DrawerItem(
            icon: Icons.shopping_bag_outlined,
            label: 'Products',
            route: '/products',
            selected: currentRoute == '/products',
          ),
          _DrawerItem(
            icon: Icons.warehouse_outlined,
            label: 'Stock',
            route: '/stock-management', // Updated
            selected: currentRoute == '/stock-management',
          ),
          _DrawerItem(
            icon: Icons.people,
            label: 'Customers',
            route: '/customer-management', // Updated
            selected: currentRoute == '/customer-management',
          ),
          _DrawerItem(
            icon: Icons.local_shipping,
            label: 'Suppliers',
            route: '/suppliers',
            selected: currentRoute == '/suppliers',
          ),
          _DrawerItem(
            icon: Icons.point_of_sale,
            label: 'POS',
            route: '/point-of-sale', // Updated
            selected: currentRoute == '/point-of-sale',
          ),
          _DrawerItem(
            icon: Icons.payment,
            label: 'Payment',
            route: '/payment-management', // Updated
            selected: currentRoute == '/payment-management',
          ),
          ExpansionTile(
            title: const Text(
              'Finances',
              style: TextStyle(color: Colors.white),
            ),
            leading: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
            ),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            children: [
              _DrawerItem(
                icon: Icons.receipt_long,
                label: 'MoMo Statements',
                route: '/momo-statements',
                dense: true,
                selected: currentRoute == '/momo-statements',
              ),
              _DrawerItem(
                icon: Icons.account_balance,
                label: 'Bank Statements',
                route: '/bank-statements',
                dense: true,
                selected: currentRoute == '/bank-statements',
              ),
              _DrawerItem(
                icon: Icons.money_off,
                label: 'Expenses',
                route: '/expenses',
                dense: true,
                selected: currentRoute == '/expenses',
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Loan', style: TextStyle(color: Colors.white)),
            leading: const Icon(Icons.request_quote, color: Colors.white),
            collapsedIconColor: Colors.white,
            iconColor: Colors.white,
            children: [
              _DrawerItem(
                icon: Icons.add,
                label: 'Apply Loan',
                route: '/apply-loan',
                dense: true,
                selected: currentRoute == '/apply-loan',
              ),
              _DrawerItem(
                icon: Icons.history,
                label: 'Repay Loan',
                route: '/repay-loan',
                dense: true,
                selected: currentRoute == '/repay-loan',
              ),
            ],
          ),
          _DrawerItem(
            icon: Icons.sms,
            label: 'Buy SMS Credit',
            route: '/buy-sms-credit',
            selected: currentRoute == '/buy-sms-credit',
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool selected;
  final bool dense;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.route,
    this.selected = false,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      selected: selected,
      selectedTileColor: Colors.white24,
      dense: dense,
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
