import 'package:flutter/material.dart';
import 'package:ufad/customers/add_customer_sheet.dart';
import 'package:ufad/customers/customer_table.dart';
import 'package:ufad/customers/filter_bar.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  void _showAddCustomerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCustomerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        automaticallyImplyLeading: canPop,
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
              )
            : null,
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.teal, Colors.teal.shade200],
              ).createShader(bounds),
              child: const Icon(Icons.people_alt, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              "Customer Management",
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
                icon: const Icon(Icons.account_circle, color: Colors.teal, size: 26),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customers",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text("Add", style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Colors.teal.shade400,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                      elevation: 2,
                      minimumSize: const Size(10, 38),
                    ),
                    onPressed: () => _showAddCustomerModal(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: const CustomerFilterBar(),
              ),
              const SizedBox(height: 12),
              const CustomerTable(),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }
}
