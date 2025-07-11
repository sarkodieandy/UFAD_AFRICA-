import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/products/product_categories.dart';
import 'package:ufad/provider/product_provider.dart';


class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    return Row(
      children: [
        // Category filter
        Expanded(
          child: DropdownButtonFormField<int>(
            decoration: InputDecoration(labelText: 'Category'),
            value: prov.categoryFilter,
            onChanged: (val) => prov.setCategoryFilter(val),
            items: [
              DropdownMenuItem(value: null, child: Text('All')),
              ...allCategories.map((cat) => DropdownMenuItem(
                value: cat.id, child: Text(cat.name),
              )),
            ],
          ),
        ),
        SizedBox(width: 8),
        // Price Sort
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Sort by Price'),
            value: prov.priceSort.isEmpty ? null : prov.priceSort,
            onChanged: (val) => prov.setPriceSort(val ?? ''),
            items: [
              DropdownMenuItem(value: '', child: Text('Default')),
              DropdownMenuItem(value: 'asc', child: Text('Lowest to Highest')),
              DropdownMenuItem(value: 'desc', child: Text('Highest to Lowest')),
            ],
          ),
        ),
        SizedBox(width: 8),
        OutlinedButton(
          onPressed: () => prov.clearFilters(),
          child: Text('Clear'),
        ),
      ],
    );
  }
}
