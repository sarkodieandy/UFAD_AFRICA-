import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/customers/model.dart';
import '../provider/customer_provider.dart';


class AddCustomerSheet extends StatefulWidget {
  final Customer? editCustomer;
  const AddCustomerSheet({super.key, this.editCustomer});

  @override
  State<AddCustomerSheet> createState() => _AddCustomerSheetState();
}

class _AddCustomerSheetState extends State<AddCustomerSheet> {
  final _formKey = GlobalKey<FormState>();
  String accountType = "";
  String name = "";
  String businessName = "";
  String category = "";
  String phone = "";
  String mobile = "";
  String location = "";

  @override
  void initState() {
    super.initState();
    if (widget.editCustomer != null) {
      final c = widget.editCustomer!;
      accountType = c.accountType;
      name = c.name;
      businessName = c.businessName ?? "";
      category = c.category;
      phone = c.phone;
      mobile = c.mobile;
      location = c.location;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 160),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                widget.editCustomer == null ? "Add Customer" : "Edit Customer",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: accountType.isEmpty ? null : accountType,
                decoration: const InputDecoration(labelText: "Account Type"),
                items: [
                  DropdownMenuItem(value: "individual", child: Text("Individual")),
                  DropdownMenuItem(value: "business", child: Text("Business")),
                ],
                onChanged: (val) => setState(() => accountType = val!),
                validator: (val) => val == null || val.isEmpty ? "Select account type" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (v) => name = v,
                validator: (v) => v == null || v.isEmpty ? "Name required" : null,
              ),
              if (accountType == "business")
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    initialValue: businessName,
                    decoration: const InputDecoration(labelText: "Business Name"),
                    onChanged: (v) => businessName = v,
                    validator: (v) => accountType == "business" && (v == null || v.isEmpty) ? "Business name required" : null,
                  ),
                ),
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: category.isEmpty ? null : category,
                decoration: const InputDecoration(labelText: "Category"),
                items: [
                  // You can map from your actual categories
                  DropdownMenuItem(value: "Clothing", child: Text("Clothing")),
                  DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
                  // ... more categories
                ],
                onChanged: (val) => setState(() => category = val!),
                validator: (val) => val == null || val.isEmpty ? "Select category" : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: "Phone"),
                onChanged: (v) => phone = v,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: mobile,
                decoration: const InputDecoration(labelText: "Mobile Number"),
                onChanged: (v) => mobile = v,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: location,
                decoration: const InputDecoration(labelText: "Location"),
                onChanged: (v) => location = v,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(widget.editCustomer == null ? "Add" : "Update"),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final provider = context.read<CustomerProvider>();
                        if (widget.editCustomer == null) {
                          provider.addCustomer(Customer(
                            id: DateTime.now().millisecondsSinceEpoch,
                            accountType: accountType,
                            name: name,
                            businessName: accountType == "business" ? businessName : null,
                            category: category,
                            phone: phone,
                            mobile: mobile,
                            location: location,
                            categoryIcon: "fa-tshirt",
                          ));
                        } else {
                          provider.editCustomer(Customer(
                            id: widget.editCustomer!.id,
                            accountType: accountType,
                            name: name,
                            businessName: accountType == "business" ? businessName : null,
                            category: category,
                            phone: phone,
                            mobile: mobile,
                            location: location,
                            categoryIcon: "fa-tshirt",
                          ));
                        }
                        Navigator.pop(context);
                      }
                    },
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
