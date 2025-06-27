import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/customers/widget/customer_edit.dart';
import '../providers/customer_provider.dart';
import 'delete_customer_dialog.dart';

class CustomerTable extends StatelessWidget {
  const CustomerTable({super.key});

  @override
  Widget build(BuildContext context) {
    final customers = context.watch<CustomerProvider>().customers;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
        columns: const [
          DataColumn(label: Text('Icon', style: TextStyle(fontSize: 14))),
          DataColumn(label: Text('Name', style: TextStyle(fontSize: 14))),
          DataColumn(
            label: Text('Account Type', style: TextStyle(fontSize: 14)),
          ),
          DataColumn(
            label: Text('Business Name', style: TextStyle(fontSize: 14)),
          ),
          DataColumn(label: Text('Category', style: TextStyle(fontSize: 14))),
          DataColumn(label: Text('Phone', style: TextStyle(fontSize: 14))),
          DataColumn(label: Text('Mobile', style: TextStyle(fontSize: 14))),
          DataColumn(label: Text('Location', style: TextStyle(fontSize: 14))),
          DataColumn(label: Text('Actions', style: TextStyle(fontSize: 14))),
        ],
        rows: List.generate(customers.length, (i) {
          final c = customers[i];
          return DataRow(
            cells: [
              const DataCell(
                CircleAvatar(
                  backgroundColor: Color(0xFFF0F0F0),
                  child: Icon(Icons.person, color: Colors.grey),
                ),
              ),
              DataCell(Text(c.name)),
              DataCell(Text(c.accountType)),
              DataCell(Text(c.businessName)),
              DataCell(Text(c.category)),
              DataCell(Text(c.phone)),
              DataCell(Text(c.mobile)),
              DataCell(Text(c.location)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => EditCustomerDialog(
                                customer: c,
                                onSave: (edited) {
                                  context
                                      .read<CustomerProvider>()
                                      .updateCustomer(i, edited);
                                },
                              ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (_) => DeleteCustomerDialog(
                                customer: c,
                                onDelete: () {
                                  context
                                      .read<CustomerProvider>()
                                      .deleteCustomer(i);
                                },
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
