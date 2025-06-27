import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/payment_provider.dart'; // <-- Your PaymentProvider here
import 'widgets/add_deposit_dialog.dart';
import 'widgets/add_account_dialog.dart';
import 'widgets/pay_supplier_dialog.dart';
import 'widgets/transfer_funds_dialog.dart';
import 'widgets/add_expense_dialog.dart';

class PaymentManagementScreen extends StatefulWidget {
  const PaymentManagementScreen({super.key});

  @override
  State<PaymentManagementScreen> createState() =>
      _PaymentManagementScreenState();
}

class _PaymentManagementScreenState extends State<PaymentManagementScreen> {
  String? selectedType = 'all';
  String? selectedAccount = 'all';
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate =
        isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now());
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
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
      selectedType = 'all';
      selectedAccount = 'all';
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF21C087),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF21C087)),
          onPressed:
              () => Navigator.of(context).pushReplacementNamed('/dashboard'),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AccountCard(balance: provider.totalBalance),
            const SizedBox(height: 12),
            _PaymentActionButtons(),
            const SizedBox(height: 12),
            _PaymentFilters(
              selectedType: selectedType,
              selectedAccount: selectedAccount,
              startDate: startDate,
              endDate: endDate,
              onTypeChanged: (v) => setState(() => selectedType = v),
              onAccountChanged: (v) => setState(() => selectedAccount = v),
              onStartDateTap: () => _pickDate(context, true),
              onEndDateTap: () => _pickDate(context, false),
              onClear: _clearFilters,
            ),
            const SizedBox(height: 16),
            Expanded(child: _PaymentTable(transactions: provider.transactions)),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  final double balance;
  const _AccountCard({required this.balance});
  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 4,
    color: const Color(0xFF2563EB),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Primary Account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Icon(Icons.credit_card, color: Colors.white, size: 28),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Momo",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            "GHS ${balance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    ),
  );
}

class _PaymentActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PayActionBtn(
          icon: Icons.add,
          label: "Deposit",
          color: Colors.green,
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (_) => AddDepositDialog(
                      onAdd:
                          (txn) => context
                              .read<PaymentProvider>()
                              .addTransaction(txn),
                    ),
              ),
        ),
        _PayActionBtn(
          icon: Icons.account_balance,
          label: "Add Account",
          color: Colors.green,
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (_) => AddAccountDialog(
                      onAdd: (name, type, desc) {
                        // context.read<PaymentProvider>().addAccount(name, type, desc);
                      },
                    ),
              ),
        ),
        _PayActionBtn(
          icon: Icons.payments,
          label: "Pay Supplier",
          color: Colors.green,
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (_) => PaySupplierDialog(
                      onPay: (purchase, account, amount, desc) {
                        // context.read<PaymentProvider>().paySupplier(...);
                      },
                    ),
              ),
        ),
        _PayActionBtn(
          icon: Icons.compare_arrows,
          label: "Transfer",
          color: Colors.green,
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (_) => TransferFundsDialog(
                      onTransfer: (from, to, amount, desc) {
                        // context.read<PaymentProvider>().transferFunds(...);
                      },
                    ),
              ),
        ),
        _PayActionBtn(
          icon: Icons.money_off,
          label: "Expense",
          color: Colors.green,
          onTap:
              () => showDialog(
                context: context,
                builder:
                    (_) => AddExpenseDialog(
                      onAdd: (account, amount, desc) {
                        // context.read<PaymentProvider>().addExpense(...);
                      },
                    ),
              ),
        ),
      ],
    );
  }
}

class _PayActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _PayActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 160,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onTap ?? () {},
    ),
  );
}

// Filter Widget with calendar support
class _PaymentFilters extends StatelessWidget {
  final String? selectedType;
  final String? selectedAccount;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onAccountChanged;
  final VoidCallback onStartDateTap;
  final VoidCallback onEndDateTap;
  final VoidCallback onClear;

  const _PaymentFilters({
    required this.selectedType,
    required this.selectedAccount,
    required this.startDate,
    required this.endDate,
    required this.onTypeChanged,
    required this.onAccountChanged,
    required this.onStartDateTap,
    required this.onEndDateTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Transactions",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All Types')),
                      DropdownMenuItem(
                        value: 'Deposit',
                        child: Text('Deposit'),
                      ),
                      DropdownMenuItem(
                        value: 'Expense',
                        child: Text('Expense'),
                      ),
                      DropdownMenuItem(
                        value: 'Transfer',
                        child: Text('Transfer'),
                      ),
                      DropdownMenuItem(
                        value: 'Payment',
                        child: Text('Payment'),
                      ),
                    ],
                    onChanged: onTypeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedAccount,
                    decoration: const InputDecoration(
                      labelText: 'Account',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Accounts'),
                      ),
                      DropdownMenuItem(value: 'Momo', child: Text('Momo')),
                      DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                    ],
                    onChanged: onAccountChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onStartDateTap,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Start Date",
                          border: const OutlineInputBorder(),
                          isDense: true,
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        controller: TextEditingController(
                          text:
                              startDate == null
                                  ? ""
                                  : dateFormat.format(startDate!),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onEndDateTap,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "End Date",
                          border: const OutlineInputBorder(),
                          isDense: true,
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                        controller: TextEditingController(
                          text:
                              endDate == null
                                  ? ""
                                  : dateFormat.format(endDate!),
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Clear Filters'),
                onPressed: onClear,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF7B8593),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTable extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  const _PaymentTable({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFFF3F6F9)),
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Account')),
            DataColumn(label: Text('Secondary Account')),
            DataColumn(label: Text('Supplier')),
            DataColumn(label: Text('Purchase')),
            DataColumn(label: Text('Amount (GHS)')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date')),
          ],
          rows: List<DataRow>.generate(transactions.length, (index) {
            final t = transactions[index];
            return DataRow(
              cells: [
                DataCell(Text(t["type"]?.toString() ?? 'N/A')),
                DataCell(Text(t["account"]?.toString() ?? 'N/A')),
                DataCell(Text(t["secondaryAccount"]?.toString() ?? 'N/A')),
                DataCell(Text(t["supplier"]?.toString() ?? 'N/A')),
                DataCell(Text(t["purchase"]?.toString() ?? 'N/A')),
                DataCell(
                  Text(
                    t["amount"] is double
                        ? (t["amount"] as double).toStringAsFixed(2)
                        : (t["amount"]?.toString() ?? 'N/A'),
                  ),
                ),
                DataCell(Text(t["description"]?.toString() ?? 'N/A')),
                DataCell(Text(t["date"]?.toString() ?? 'N/A')),
              ],
            );
          }),
        ),
      ),
    );
  }
}
