import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterBar extends StatefulWidget {
  final Function({
    String? dateRange,
    DateTime? startDate,
    DateTime? endDate,
    String? debtor,
    bool? debtorsOnly,
  })? onFilter;

  const FilterBar({super.key, this.onFilter});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> with SingleTickerProviderStateMixin {
  String? dateRange;
  DateTime? startDate;
  DateTime? endDate;
  String? debtor;
  bool debtorsOnly = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context, bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (startDate ?? now) : (endDate ?? now),
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
      helpText: isStart ? 'Select Start Date' : 'Select End Date',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.teal.shade600,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
      _triggerFilter();
    }
  }

  void _triggerFilter() {
    widget.onFilter?.call(
      dateRange: dateRange,
      startDate: startDate,
      endDate: endDate,
      debtor: debtor,
      debtorsOnly: debtorsOnly,
    );
  }

  void _clearFilters() {
    setState(() {
      dateRange = null;
      startDate = null;
      endDate = null;
      debtor = null;
      debtorsOnly = false;
    });
    _triggerFilter();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.12), end: Offset.zero
        ).animate(_fadeAnim),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 156,
                  child: DropdownButtonFormField<String>(
                    value: dateRange,
                    decoration: InputDecoration(
                      labelText: "Date Range",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text("Custom Range", style: TextStyle(color: Colors.grey[500]))),
                      ...["Yesterday", "Today", "This Month", "Last Month", "Quarterly", "Yearly"]
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    ],
                    onChanged: (v) => setState(() {
                      dateRange = v;
                      if (v != null) {
                        startDate = null;
                        endDate = null;
                      }
                      _triggerFilter();
                    }),
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: startDate == null ? "" : DateFormat.yMd().format(startDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: "Start Date",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.calendar_today, size: 18, color: Colors.teal.shade400),
                    ),
                    onTap: () => _pickDate(context, true),
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: endDate == null ? "" : DateFormat.yMd().format(endDate!),
                    ),
                    decoration: InputDecoration(
                      labelText: "End Date",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: Icon(Icons.calendar_today, size: 18, color: Colors.teal.shade400),
                    ),
                    onTap: () => _pickDate(context, false),
                  ),
                ),
                SizedBox(
                  width: 160,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: "Search Debtor",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: Icon(Icons.search, size: 19, color: Colors.teal.shade400),
                    ),
                    onChanged: (v) {
                      debtor = v;
                      _triggerFilter();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Debtors Only", style: TextStyle(fontSize: 13)),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Switch(
                          key: ValueKey(debtorsOnly),
                          value: debtorsOnly,
                          onChanged: (v) => setState(() {
                            debtorsOnly = v;
                            _triggerFilter();
                          }),
                          activeColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 230),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close, size: 19),
                    label: const Text("Clear"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _clearFilters,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
