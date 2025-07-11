// lib/widgets/activity_list.dart
import 'package:flutter/material.dart';
import 'package:ufad/dashboad/widget/activity.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;

  const ActivityList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Username', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Action', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Date/Time', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: activities.map((activity) {
          return DataRow(cells: [
            DataCell(Text(activity.username)),
            DataCell(Text(activity.action)),
            DataCell(Text(activity.timestamp)), // Using raw timestamp to match HTML
          ]);
        }).toList(),
      ),
    );
  }
}