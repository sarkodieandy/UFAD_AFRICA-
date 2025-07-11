import 'package:flutter/material.dart';
import 'package:ufad/stocks/widget/filter_bar.dart';
import 'package:ufad/stocks/widget/metric_card.dart';
import 'package:ufad/stocks/widget/stock_table.dart';
import 'package:ufad/stocks/widget/add_purchase_sheet.dart';

class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  void _showAddPurchaseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // ignore: deprecated_member_use
      barrierColor: Colors.black.withOpacity(0.15),
      backgroundColor: Colors.transparent,
      builder: (ctx) => const AddPurchaseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we can pop (i.e. there's a previous screen)
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            if (canPop) {
              // If possible, show back button
              return IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
              );
            } else {
              // Else, show menu for drawer
              return IconButton(
                icon: const Icon(Icons.menu, color: Colors.teal),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: 'Menu',
              );
            }
          },
        ),
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Colors.teal, Colors.teal.shade200],
                ).createShader(bounds);
              },
              child: const Icon(Icons.warehouse, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              "Stock Management",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontSize: 18,
                letterSpacing: .1,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircleAvatar(
              backgroundColor: Colors.teal.shade50,
              child: IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.teal,
                  size: 26,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        // ignore: deprecated_member_use
        backgroundColor: Colors.white.withOpacity(0.97),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.teal.shade200],
                ),
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'UFAD Portal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            ...[
              {'icon': Icons.dashboard, 'label': "Dashboard"},
              {'icon': Icons.shopping_bag, 'label': "Products"},
              {'icon': Icons.warehouse, 'label': "Stock", 'selected': true},
            ].map(
              (nav) => ListTile(
                leading: Icon(nav['icon'] as IconData, color: Colors.teal),
                title: Text(
                  nav['label'] as String,
                  style: const TextStyle(fontSize: 14),
                ),
                selected: nav['label'] == "Stock",
                // ignore: deprecated_member_use
                selectedTileColor: Colors.teal.withOpacity(0.06),
                onTap: () {},
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text("Logout", style: TextStyle(fontSize: 14)),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Soft background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 70, 18, 16),
            children: [
              // Animated Metrics Row
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    MetricCard(
                      label: "Total Paid",
                      value: "GHS 30,000.00",
                      index: 0,
                    ),
                    MetricCard(
                      label: "Total Unpaid",
                      value: "GHS 3,500.00",
                      index: 1,
                    ),
                    MetricCard(
                      label: "Balance to be Paid",
                      value: "GHS 3,500.00",
                      index: 2,
                    ),
                    MetricCard(
                      label: "Current Stock Value",
                      value: "GHS 11,000.00",
                      index: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Purchases Bar + Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Stock Purchases",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add", style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 8,
                      ),
                      elevation: 2,
                      minimumSize: const Size(10, 38),
                    ),
                    onPressed: () => _showAddPurchaseModal(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Modern Filter Bar
              Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.teal.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: const FilterBar(),
              ),
              const SizedBox(height: 14),
              // Purchases Table
              const StockTable(),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
