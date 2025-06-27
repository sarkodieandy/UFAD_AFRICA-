import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StockFilters extends StatefulWidget {
  const StockFilters({super.key});
  @override
  State<StockFilters> createState() => _StockFiltersState();
}

class _StockFiltersState extends State<StockFilters> {
  String? selectedCategory = 'all';
  String? selectedStatus = 'all';
  String? selectedSupplier = 'all';
  DateTime? startDate;
  DateTime? endDate;

  String? get _startDateStr =>
      startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : null;
  String? get _endDateStr =>
      endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : null;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate = (isStart ? startDate : endDate) ?? DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        if (isStart) {
          startDate = newDate;
        } else {
          endDate = newDate;
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      selectedCategory = 'all';
      selectedStatus = 'all';
      selectedSupplier = 'all';
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final smallText = const TextStyle(fontSize: 13);

    return Column(
      children: [
        // FIRST ROW: CATEGORY & STATUS
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 10,
                  ),
                  labelStyle: smallText,
                ),
                style: smallText,
                items: const [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text(
                      'All Categories',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Electronics',
                    child: Text('Electronics', style: TextStyle(fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: 'Food',
                    child: Text('Food', style: TextStyle(fontSize: 13)),
                  ),
                ],
                onChanged: (v) => setState(() => selectedCategory = v),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Payment Status',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 10,
                  ),
                  labelStyle: smallText,
                ),
                style: smallText,
                items: const [
                  DropdownMenuItem(
                    value: 'all',
                    child: Text('All Statuses', style: TextStyle(fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: 'Paid',
                    child: Text('Paid', style: TextStyle(fontSize: 13)),
                  ),
                  DropdownMenuItem(
                    value: 'Unpaid',
                    child: Text('Unpaid', style: TextStyle(fontSize: 13)),
                  ),
                ],
                onChanged: (v) => setState(() => selectedStatus = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // SECOND ROW: SUPPLIER, START/END DATE
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 130,
                child: DropdownButtonFormField<String>(
                  value: selectedSupplier,
                  decoration: InputDecoration(
                    labelText: 'Supplier',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 10,
                    ),
                    labelStyle: smallText,
                  ),
                  style: smallText,
                  items: const [
                    DropdownMenuItem(
                      value: 'all',
                      child: Text(
                        'All Suppliers',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Test Supplier',
                      child: Text(
                        'Test Supplier',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedSupplier = v),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: TextEditingController(text: _startDateStr ?? ''),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    labelStyle: smallText,
                  ),
                  style: smallText,
                  onTap: () => _pickDate(context, true),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 120,
                child: TextFormField(
                  controller: TextEditingController(text: _endDateStr ?? ''),
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'End Date',
                    border: const OutlineInputBorder(),
                    isDense: true,
                    suffixIcon: const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                    ),
                    labelStyle: smallText,
                  ),
                  style: smallText,
                  onTap: () => _pickDate(context, false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.clear, size: 17),
            label: const Text(
              'Clear Filters',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            onPressed: _clearFilters,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF7B8593),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
