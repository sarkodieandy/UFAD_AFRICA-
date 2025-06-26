import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesFilterSection extends StatefulWidget {
  final VoidCallback onNewSale;
  final VoidCallback onPayDebt;

  const SalesFilterSection({
    super.key,
    required this.onNewSale,
    required this.onPayDebt,
  });

  @override
  State<SalesFilterSection> createState() => _SalesFilterSectionState();
}

class _SalesFilterSectionState extends State<SalesFilterSection> {
  final kGreen = const Color(0xFF21C087);

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _pickDate(
    BuildContext context,
    TextEditingController controller,
    DateTime? initialDate,
    ValueChanged<DateTime?> onDatePicked,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
      onDatePicked(picked);
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: "Sales" + Buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sales",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Sale'),
                onPressed: widget.onNewSale,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton.icon(
                icon: const Icon(Icons.attach_money, size: 18),
                label: const Text('Pay Debt'),
                onPressed: widget.onPayDebt,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Date Range Dropdown
          const Text(
            "Date Range",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 370,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              value: "Custom Range",
              items: const [
                DropdownMenuItem(
                  value: "Custom Range",
                  child: Text("Custom Range"),
                ),
                DropdownMenuItem(value: "Today", child: Text("Today")),
                DropdownMenuItem(value: "This Week", child: Text("This Week")),
                DropdownMenuItem(
                  value: "This Month",
                  child: Text("This Month"),
                ),
              ],
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 18),

          // Start Date
          const Text(
            "Start Date",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 370,
            child: TextField(
              controller: _startDateController,
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey[700],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              readOnly: true,
              onTap:
                  () => _pickDate(
                    context,
                    _startDateController,
                    _startDate,
                    (picked) => setState(() => _startDate = picked),
                  ),
            ),
          ),
          const SizedBox(height: 18),

          // End Date
          const Text("End Date", style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          SizedBox(
            width: 370,
            child: TextField(
              controller: _endDateController,
              decoration: InputDecoration(
                hintText: 'mm/dd/yyyy',
                border: const OutlineInputBorder(),
                suffixIcon: Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Colors.grey[700],
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              readOnly: true,
              onTap:
                  () => _pickDate(
                    context,
                    _endDateController,
                    _endDate,
                    (picked) => setState(() => _endDate = picked),
                  ),
            ),
          ),
          const SizedBox(height: 18),

          // Search Debtor
          const Text(
            "Search Debtor",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 370,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by customer name',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Show Debtors Only Checkbox
          Row(
            children: [
              Checkbox(value: false, onChanged: (_) {}),
              const Text("Show Debtors Only"),
            ],
          ),
        ],
      ),
    );
  }
}
