import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/payment_provider.dart';

class PaymentFilterBar extends StatefulWidget {
  final Function()? onClear;

  const PaymentFilterBar({super.key, this.onClear});

  @override
  State<PaymentFilterBar> createState() => _PaymentFilterBarState();
}

class _PaymentFilterBarState extends State<PaymentFilterBar>
    with SingleTickerProviderStateMixin {
  String? _selectedType = '';
  String? _selectedAccount = '';
  DateTime? _startDate;
  DateTime? _endDate;

  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = isStart ? _startDate ?? now : _endDate ?? now;
    final first = DateTime(now.year - 5);
    final last = DateTime(now.year + 5);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.teal,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _selectedType = '';
      _selectedAccount = '';
      _startDate = null;
      _endDate = null;
    });
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);
    final accounts = provider.accounts;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 600;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
            child: isSmall
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Type"),
                        value: _selectedType,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(value: '', child: Text('All Types')),
                          ...["Deposit", "Payment", "Transfer", "Expense"].map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          ),
                        ],
                        onChanged: (val) => setState(() => _selectedType = val ?? ''),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Account"),
                        value: _selectedAccount,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(value: '', child: Text('All Accounts')),
                          ...accounts.map(
                            (a) => DropdownMenuItem(
                              value: a.id,
                              child: Text(a.name),
                            ),
                          ),
                        ],
                        onChanged: (val) => setState(() => _selectedAccount = val ?? ''),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "Start Date"),
                        readOnly: true,
                        controller: TextEditingController(
                            text: _startDate == null
                                ? ''
                                : "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}"),
                        onTap: () => _pickDate(isStart: true),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(labelText: "End Date"),
                        readOnly: true,
                        controller: TextEditingController(
                            text: _endDate == null
                                ? ''
                                : "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}"),
                        onTap: () => _pickDate(isStart: false),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: _clearFilters,
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: "Type"),
                            value: _selectedType,
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(value: '', child: Text('All Types')),
                              ...["Deposit", "Payment", "Transfer", "Expense"].map(
                                (c) => DropdownMenuItem(value: c, child: Text(c)),
                              ),
                            ],
                            onChanged: (val) => setState(() => _selectedType = val ?? ''),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 170,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(labelText: "Account"),
                            value: _selectedAccount,
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(value: '', child: Text('All Accounts')),
                              ...accounts.map(
                                (a) => DropdownMenuItem(
                                  value: a.id,
                                  child: Text(a.name),
                                ),
                              ),
                            ],
                            onChanged: (val) => setState(() => _selectedAccount = val ?? ''),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 140,
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: "Start Date"),
                            readOnly: true,
                            controller: TextEditingController(
                                text: _startDate == null
                                    ? ''
                                    : "${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-${_startDate!.day.toString().padLeft(2, '0')}"),
                            onTap: () => _pickDate(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 140,
                          child: TextFormField(
                            decoration: const InputDecoration(labelText: "End Date"),
                            readOnly: true,
                            controller: TextEditingController(
                                text: _endDate == null
                                    ? ''
                                    : "${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-${_endDate!.day.toString().padLeft(2, '0')}"),
                            onTap: () => _pickDate(isStart: false),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: const Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black87,
                          ),
                          onPressed: _clearFilters,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}