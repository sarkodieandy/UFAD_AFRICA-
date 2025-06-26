import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Mock Provider
class CustomerProvider extends ChangeNotifier {
  List<Map<String, String>> customers = [
    {
      "icon": "shirt",
      "name": "SOLOMON",
      "accountType": "Individual",
      "businessName": "",
      "category": "Clothing",
      "phone": "0545304660",
      "mobile": "0545304660",
      "location": "KASOA"
    },
    // Add more customers as needed
  ];
}

// Main Entry
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CustomerProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CustomerManagementScreen(),
      ),
    ),
  );
}

// Main Screen
class CustomerManagementScreen extends StatelessWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green[700],
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CustomerFiltersSection(),
            const SizedBox(height: 20),
            AddCustomerButton(),
            const SizedBox(height: 10),
            CustomersList(),
          ],
        ),
      ),
    );
  }
}

// Filters Section
class CustomerFiltersSection extends StatefulWidget {
  const CustomerFiltersSection({super.key});

  @override
  State<CustomerFiltersSection> createState() => _CustomerFiltersSectionState();
}

class _CustomerFiltersSectionState extends State<CustomerFiltersSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ExpansionTile(
        title: const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        onExpansionChanged: (val) => setState(() => _expanded = val),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Category'),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Categories')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: 'Account Type'),
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Types')),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add Customer Button
class AddCustomerButton extends StatelessWidget {
  const AddCustomerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {}, // Add your logic
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

// Customers List
class CustomersList extends StatelessWidget {
  const CustomersList({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: customers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, i) => CustomerCard(customer: customers[i]),
    );
  }
}

// Single Customer Card
class CustomerCard extends StatelessWidget {
  final Map<String, String> customer;
  const CustomerCard({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(customer["name"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(customer["accountType"] ?? "",
                      style: const TextStyle(color: Colors.grey)),
                  if ((customer["businessName"] ?? "").isNotEmpty)
                    Text(customer["businessName"] ?? "",
                        style: const TextStyle(color: Colors.grey)),
                  Text(customer["category"] ?? "",
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text("Phone: ${customer["phone"]}"),
                  Text("Mobile: ${customer["mobile"]}"),
                  Text("Location: ${customer["location"]}"),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () {}, // Edit logic
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {}, // Delete logic
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
