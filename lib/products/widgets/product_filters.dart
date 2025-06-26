import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/provider/product_provider.dart';

class ProductFilters extends StatelessWidget {
  const ProductFilters({super.key, required ProductProvider provider});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<int?>(
                      value: provider.selectedCategoryId, // FIXED HERE
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        DropdownMenuItem(value: 4, child: Text('Electronics')),
                        DropdownMenuItem(
                          value: 5,
                          child: Text('Food & Beverages'),
                        ),
                      ],
                      onChanged:
                          (cat) => provider.filterProducts(categoryId: cat),
                    ),
                  ),
                  const SizedBox(width: 24),
                  const Text(
                    'Sort by Price',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      value: provider.sortBy,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'recent',
                          child: Text('Default (Recent)'),
                        ),
                        DropdownMenuItem(
                          value: 'price-asc',
                          child: Text('Price (Low to High)'),
                        ),
                        DropdownMenuItem(
                          value: 'price-desc',
                          child: Text('Price (High to Low)'),
                        ),
                      ],
                      onChanged:
                          (sort) => provider.filterProducts(sortBy: sort),
                    ),
                  ),
                  const SizedBox(width: 24),
                  OutlinedButton.icon(
                    onPressed: () => provider.clearFilters(),
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
