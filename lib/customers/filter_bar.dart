import 'package:flutter/material.dart';

class CustomerFilterBar extends StatelessWidget {
  const CustomerFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width for dynamic sizing
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate width for dropdowns based on screen size
    double dropdownWidth = screenWidth > 500 ? 180 : (screenWidth / 2) - 36;
    dropdownWidth = dropdownWidth.clamp(120, 200);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: dropdownWidth,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Category",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "", child: Text("All Categories")),
                DropdownMenuItem(value: "Clothing", child: Text("Clothing")),
                DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
                // ...add more
              ],
              onChanged: (v) {},
            ),
          ),
          SizedBox(
            width: dropdownWidth,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Account Type",
                isDense: true,
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "", child: Text("All Types")),
                DropdownMenuItem(value: "individual", child: Text("Individual")),
                DropdownMenuItem(value: "business", child: Text("Business")),
              ],
              onChanged: (v) {},
            ),
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.close, size: 16),
              label: const Text("Clear", style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.teal,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
