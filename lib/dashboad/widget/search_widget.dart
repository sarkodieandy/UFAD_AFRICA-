// lib/widgets/search_widget.dart
import 'package:flutter/material.dart';
import 'package:ufad/provider/dashboard_provider.dart';

import 'package:provider/provider.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _showResults = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardProvider = Provider.of<DashboardProvider>(context);

    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              dashboardProvider.searchTransactions(value);
              setState(() => _showResults = true);
            } else {
              setState(() => _showResults = false);
            }
          },
        ),
        if (_showResults) _buildSearchResults(),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Search results will appear here'),
      ),
    );
  }
}