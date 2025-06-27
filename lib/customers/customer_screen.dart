import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/customers/providers/customer_provider.dart';
import 'package:ufad/customers/widget/add_customer_dialog.dart';
import 'package:ufad/customers/widget/customer_filters.dart';
import 'package:ufad/customers/widget/customer_table.dart';

class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087)),
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/dashboard', (route) => false);
          },
        ),
        title: const Text(
          'Customer Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF21C087),
          ),
        ),
        centerTitle: false,
      ),

      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CustomerFilters(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Customers',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AddCustomerDialog(
                            onAdd: (customer) {
                              context.read<CustomerProvider>().addCustomer(
                                customer,
                              );
                            },
                          ),
                    );
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 2.0,
                    ), // For better text alignment
                    child: Text(
                      'Add Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF21C087),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    minimumSize: const Size(160, 46), // width, height
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Pill-like shape
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Expanded(child: CustomerTable()),
          ],
        ),
      ),
    );
  }
}
