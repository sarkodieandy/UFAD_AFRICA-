import 'package:flutter/material.dart';

class SupplierFilterBar extends StatelessWidget {
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<String?>? onTypeChanged;

  const SupplierFilterBar({
    super.key,
    this.onCategoryChanged,
    this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      "All",
      "Automotive Parts", "Baby Products", "Beauty Products", "Books",
      "Cleaning Supplies", "Clothing", "Crafts & Hobbies", "Electronics",
      "Food & Beverages", "Furniture", "Gardening Tools", "Health Products",
      "Home Appliances", "Jewelry", "Musical Instruments", "Outdoor Gear",
      "Pet Supplies", "Sports Equipment", "Stationery", "Toys & Games",
    ];
    final accountTypes = ["All", "Individual", "Business"];

    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 16.0 * 2; // Assuming horizontal padding

    // If screen width < 400, use vertical column (mobile)
    final isNarrow = screenWidth < 400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: isNarrow
          ? Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: "Category", isDense: true),
                  items: categories
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: onCategoryChanged,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: "Type", isDense: true),
                  items: accountTypes
                      .map((t) =>
                          DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: onTypeChanged,
                ),
              ],
            )
          : Row(
              children: [
                // Each dropdown gets half width, minus spacing
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: "Category", isDense: true),
                    items: categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: onCategoryChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        labelText: "Type", isDense: true),
                    items: accountTypes
                        .map((t) =>
                            DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: onTypeChanged,
                  ),
                ),
              ],
            ),
    );
  }
}
