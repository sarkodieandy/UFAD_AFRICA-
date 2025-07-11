import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/styles.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Map<String, bool> _expandedMenus = {
    'finances': false,
    'loan': false,
  };

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.teal600,
            ),
            child: const Text(
              'UFAD Portal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildMenuItem(
            Icons.home, 
            'Dashboard', 
            () => _navigateTo(context, '/dashboard')
          ),
          _buildMenuItem(
            Icons.inventory, 
            'Products', 
            () => _navigateTo(context, '/products')
          ),
          _buildMenuItem(
            Icons.warehouse, 
            'Stock', 
            () => _navigateTo(context, '/stocks')
          ),
          _buildMenuItem(
            Icons.people, 
            'Customers', 
            () => _navigateTo(context, '/customers')
          ),
          _buildMenuItem(
            Icons.local_shipping, 
            'Suppliers', 
            () => _navigateTo(context, '/suppliers')
          ),
          _buildMenuItem(
            Icons.point_of_sale, 
            'POS', 
            () => _navigateTo(context, '/pos')
          ),
          _buildMenuItem(
            Icons.credit_card, 
            'Payments', 
            () => _navigateTo(context, '/payments')
          ),
          _buildExpandableMenu(
            Icons.savings,
            'Finances',
            [
              _buildSubMenuItem(
                Icons.mobile_friendly, 
                'MoMo Statements', 
                () => _navigateWithParams(context, '/finances', {'type': 'momo'})
              ),
              _buildSubMenuItem(
                Icons.account_balance, 
                'Bank Statements', 
                () => _navigateWithParams(context, '/finances', {'type': 'bank'})
              ),
              _buildSubMenuItem(
                Icons.money, 
                'Expenses', 
                () => _navigateWithParams(context, '/finances', {'type': 'expenses'})
              ),
            ],
            'finances',
          ),
          _buildExpandableMenu(
            Icons.money,
            'Loan',
            [
              _buildSubMenuItem(
                Icons.description, 
                'Apply Loan', 
                () => _navigateWithParams(context, '/loan', {'type': 'apply'})
              ),
              _buildSubMenuItem(
                Icons.payments, 
                'Repay Loan', 
                () => _navigateWithParams(context, '/loan', {'type': 'repay'})
              ),
            ],
            'loan',
          ),
          _buildMenuItem(
            Icons.sms, 
            'Buy SMS Credit', 
            () => _showComingSoon(context)
          ),
          const Divider(),
          _buildMenuItem(
            Icons.logout, 
            'Logout', 
            () => _handleLogout(context)
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(context, route);
  }

  void _navigateWithParams(BuildContext context, String route, Object params) {
    Navigator.pop(context); // Close drawer
    Navigator.pushNamed(
      context, 
      route,
      arguments: params
    );
  }

  void _showComingSoon(BuildContext context) {
    Navigator.pop(context); // Close drawer
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This feature is coming soon!'))
    );
  }

  void _handleLogout(BuildContext context) {
    Navigator.pop(context); // Close drawer
    // Simple logout - just navigate to login screen and clear stack
    Navigator.pushNamedAndRemoveUntil(
      context, 
      '/login', 
      (route) => false
    );
    
    // Optional: Show logout confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully'))
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.teal600),
      title: Text(title, style: Styles.drawerItemStyle),
      onTap: onTap,
    );
  }

  Widget _buildSubMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        leading: Icon(icon, color: AppColors.teal600, size: 20),
        title: Text(title, style: Styles.drawerItemStyle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildExpandableMenu(
    IconData icon,
    String title,
    List<Widget> children,
    String menuKey,
  ) {
    return ExpansionTile(
      leading: Icon(icon, color: AppColors.teal600),
      title: Text(title, style: Styles.drawerItemStyle),
      initiallyExpanded: _expandedMenus[menuKey] ?? false,
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedMenus[menuKey] = expanded;
        });
      },
      children: children,
    );
  }
}