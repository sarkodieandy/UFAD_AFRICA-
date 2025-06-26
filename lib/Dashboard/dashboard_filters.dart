import 'package:flutter/material.dart';

class DashboardFilters extends StatelessWidget {
  const DashboardFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: 'Today',
            items: const [
              DropdownMenuItem(value: 'Today', child: Text('Today')),
              DropdownMenuItem(value: 'Week', child: Text('This Week')),
              DropdownMenuItem(value: 'Month', child: Text('This Month')),
            ],
            onChanged: (v) {},
            decoration: const InputDecoration(
              labelText: 'Period',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: 'All Sectors',
            items: const [
              DropdownMenuItem(
                value: 'All Sectors',
                child: Text('All Sectors'),
              ),
              DropdownMenuItem(value: 'Retail', child: Text('Retail')),
              DropdownMenuItem(
                value: 'Agriculture',
                child: Text('Agriculture'),
              ),
            ],
            onChanged: (v) {},
            decoration: const InputDecoration(
              labelText: 'Sector',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
