import 'package:flutter/material.dart';
import '../models/customer.dart';

class EditCustomerDialog extends StatefulWidget {
  final Customer? customer;
  final Function(Customer) onSave;

  const EditCustomerDialog({super.key, this.customer, required this.onSave});

  @override
  State<EditCustomerDialog> createState() => _EditCustomerDialogState();
}

class _EditCustomerDialogState extends State<EditCustomerDialog> {
  late TextEditingController name;
  late TextEditingController businessName;
  late TextEditingController phone;
  late TextEditingController mobile;
  late TextEditingController location;
  String accountType = 'Individual';
  String category = 'Clothing';

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.customer?.name ?? '');
    businessName = TextEditingController(
      text: widget.customer?.businessName ?? '',
    );
    phone = TextEditingController(text: widget.customer?.phone ?? '');
    mobile = TextEditingController(text: widget.customer?.mobile ?? '');
    location = TextEditingController(text: widget.customer?.location ?? '');
    accountType = widget.customer?.accountType ?? 'Individual';
    category = widget.customer?.category ?? 'Clothing';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Edit Customer",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.green),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: accountType,
                decoration: const InputDecoration(
                  labelText: "Account Type",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Individual",
                    child: Text("Individual"),
                  ),
                  DropdownMenuItem(value: "Business", child: Text("Business")),
                ],
                onChanged:
                    (v) => setState(() => accountType = v ?? 'Individual'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Clothing", child: Text("Clothing")),
                  DropdownMenuItem(
                    value: "Electronics",
                    child: Text("Electronics"),
                  ),
                ],
                onChanged: (v) => setState(() => category = v ?? 'Clothing'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: mobile,
                decoration: const InputDecoration(
                  labelText: "Mobile Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: location,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(120, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(140, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      widget.onSave(
                        Customer(
                          name: name.text,
                          accountType: accountType,
                          businessName: businessName.text,
                          category: category,
                          phone: phone.text,
                          mobile: mobile.text,
                          location: location.text,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text("Update Customer"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
