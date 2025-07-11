import 'package:flutter/material.dart';
import 'package:ufad/suppliers/supplier_model.dart';

class SupplierForm extends StatefulWidget {
  final Supplier? supplier;
  final ValueChanged<Supplier> onSave;

  const SupplierForm({super.key, this.supplier, required this.onSave});

  @override
  State<SupplierForm> createState() => _SupplierFormState();
}

class _SupplierFormState extends State<SupplierForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name;
  String type = 'Individual';
  late TextEditingController business;
  String category = 'Electronics';
  late TextEditingController phone;
  late TextEditingController mobile;
  late TextEditingController location;

  late AnimationController _anim;
  late Animation<double> _slideAnim, _fadeAnim;

  final _fieldNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.supplier?.name ?? '');
    type = widget.supplier?.type ?? 'Individual';
    business = TextEditingController(text: widget.supplier?.business ?? '');
    category = widget.supplier?.category ?? 'Electronics';
    phone = TextEditingController(text: widget.supplier?.phone ?? '');
    mobile = TextEditingController(text: widget.supplier?.mobile ?? '');
    location = TextEditingController(text: widget.supplier?.location ?? '');

    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    _slideAnim = Tween<double>(begin: 60, end: 0).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutQuart));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    name.dispose();
    business.dispose();
    phone.dispose();
    mobile.dispose();
    location.dispose();
    for (var n in _fieldNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _trySave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave(
        Supplier(
          name: name.text,
          type: type,
          business: business.text,
          category: category,
          phone: phone.text,
          mobile: mobile.text,
          location: location.text,
        ),
      );
    } else {
      // Find the first invalid field and scroll/focus to it.
      Future.delayed(const Duration(milliseconds: 150), () {
        for (var i = 0; i < _fieldNodes.length; i++) {
          if (!_fieldNodes[i].hasFocus) {
            _fieldNodes[i].requestFocus();
            break;
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBusiness = type == "Business";
    final allCategories = [
      "Automotive Parts", "Baby Products", "Beauty Products", "Books", "Cleaning Supplies", "Clothing",
      "Crafts & Hobbies", "Electronics", "Food & Beverages", "Furniture", "Gardening Tools",
      "Health Products", "Home Appliances", "Jewelry", "Musical Instruments", "Outdoor Gear",
      "Pet Supplies", "Sports Equipment", "Stationery", "Toys & Games",
    ];

    return AnimatedBuilder(
      animation: _anim,
      builder: (ctx, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: Opacity(
            opacity: _fadeAnim.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          top: 22,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 14,
        ),
        child: Form(
          key: _formKey,
          child: Material(
            color: Colors.white,
            elevation: 3,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.supplier == null ? "Add Supplier" : "Edit Supplier",
                      style: theme.textTheme.titleMedium!.copyWith(
                        color: Colors.teal[700],
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Account Type
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      child: DropdownButtonFormField<String>(
                        value: type,
                        focusNode: _fieldNodes[0],
                        decoration: _formDeco("Account Type", Icons.person_outline),
                        items: ["Individual", "Business"]
                            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                            .toList(),
                        onChanged: (val) => setState(() => type = val ?? 'Individual'),
                      ),
                    ),

                    const SizedBox(height: 12),
                    // Name
                    TextFormField(
                      controller: name,
                      focusNode: _fieldNodes[1],
                      decoration: _formDeco("Name", Icons.person),
                      validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
                    ),

                    // Business Name
                    AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      child: isBusiness
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: TextFormField(
                                controller: business,
                                focusNode: _fieldNodes[2],
                                decoration: _formDeco("Business Name", Icons.business),
                                validator: (val) => isBusiness && (val == null || val.isEmpty)
                                    ? "Enter business name"
                                    : null,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 12),
                    // Category
                    DropdownButtonFormField<String>(
                      value: category,
                      focusNode: _fieldNodes[3],
                      decoration: _formDeco("Category", Icons.category_outlined),
                      items: allCategories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (val) => setState(() => category = val ?? 'Electronics'),
                    ),

                    const SizedBox(height: 12),
                    // Phone
                    TextFormField(
                      controller: phone,
                      focusNode: _fieldNodes[4],
                      decoration: _formDeco("Phone", Icons.phone),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 12),
                    // Mobile Number
                    TextFormField(
                      controller: mobile,
                      focusNode: _fieldNodes[5],
                      decoration: _formDeco("Mobile Number", Icons.phone_android),
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 12),
                    // Location
                    TextFormField(
                      controller: location,
                      decoration: _formDeco("Location", Icons.location_on_outlined),
                    ),

                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.teal.shade400,
                          ),
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          ),
                          icon: const Icon(Icons.save_alt, size: 19),
                          label: const Text("Save", style: TextStyle(fontWeight: FontWeight.w700)),
                          onPressed: _trySave,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _formDeco(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal.shade300),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(13)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade600, width: 2),
        borderRadius: BorderRadius.circular(13),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.teal.withOpacity(.035),
    );
  }
}
