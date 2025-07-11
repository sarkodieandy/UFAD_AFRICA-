import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Ensures proper height for DropdownButtonFormField
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Category",
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.07),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("All", style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 4, child: Text("Electronics", style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) {},
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Status",
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.07),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("All", style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: "Paid", child: Text("Paid", style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: "Unpaid", child: Text("Unpaid", style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) {},
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  labelText: "Supplier",
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.07),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  labelStyle: const TextStyle(fontSize: 12),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text("All", style: TextStyle(fontSize: 12))),
                  DropdownMenuItem(value: 6, child: Text("Test Supplier", style: TextStyle(fontSize: 12))),
                ],
                onChanged: (val) {},
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.teal, size: 22),
              onPressed: () {},
              tooltip: "Apply",
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.grey, size: 21),
              onPressed: () {},
              tooltip: "Clear",
            ),
          ],
        ),
      ),
    );
  }
}
