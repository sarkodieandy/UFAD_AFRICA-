import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/payments_management/widgets/account_card.dart';
import 'package:ufad/payments_management/widgets/account_metric.dart';
import 'package:ufad/payments_management/widgets/add_deposit_dialog.dart';
import 'package:ufad/payments_management/widgets/add_account_dialog.dart';
import 'package:ufad/payments_management/widgets/pay_supplier_dialog.dart';
import 'package:ufad/payments_management/widgets/payment_filter_bar.dart';
import 'package:ufad/payments_management/widgets/transaction_table.dart';
import '../provider/payment_provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  void _showModal(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: SingleChildScrollView(child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentProvider>(context);
    final accounts = provider.accounts;
    final transactions = provider.transactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors: [Color(0xFF0D9488), Color(0xFF3B82F6)],
            ).createShader(bounds);
          },
          child: const Text(
            'Payment Management',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          final isSmall = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🟩 Main Account Card + Metric (Stacked Vertically)
                Hero(
                  tag: 'main-account',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountCard(account: accounts.first, isPrimary: true),
                      const SizedBox(height: 16),
                      AccountMetric(
                        label: "Total Balance",
                        value: "GHS ${provider.totalBalance.toStringAsFixed(2)}",
                        highlight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 🟦 Additional Accounts
                if (accounts.length > 1)
                  GridView.count(
                    crossAxisCount: isWide ? 3 : 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 14,
                    childAspectRatio: 2.8,
                    children: accounts
                        .skip(1)
                        .map((a) => AccountMetric(
                              label: "${a.name} (${a.type})",
                              value: "GHS ${a.balance.toStringAsFixed(2)}",
                              highlight: false,
                            ))
                        .toList(),
                  ),

                const SizedBox(height: 28),

                // 🟨 Action Buttons
                isSmall
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _ActionButton(
                                icon: Icons.add,
                                label: "Deposit",
                                color: Colors.green,
                                onTap: () => _showModal(context, const AddDepositDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.account_balance,
                                label: "Add Account",
                                color: Colors.blue,
                                onTap: () => _showModal(context, const AddAccountDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.monetization_on_outlined,
                                label: "Pay Supplier",
                                color: Colors.teal,
                                onTap: () => _showModal(context, const PaySupplierDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.compare_arrows_rounded,
                                label: "Transfer",
                                color: Colors.orange,
                                onTap: () {
                                  // TODO: Transfer dialog
                                },
                              ),
                              _ActionButton(
                                icon: Icons.remove,
                                label: "Expense",
                                color: Colors.red,
                                onTap: () {
                                  // TODO: Expense dialog
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transactions",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                          Wrap(
                            spacing: 10,
                            children: [
                              _ActionButton(
                                icon: Icons.add,
                                label: "Deposit",
                                color: Colors.green,
                                onTap: () => _showModal(context, const AddDepositDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.account_balance,
                                label: "Add Account",
                                color: Colors.blue,
                                onTap: () => _showModal(context, const AddAccountDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.monetization_on_outlined,
                                label: "Pay Supplier",
                                color: Colors.teal,
                                onTap: () => _showModal(context, const PaySupplierDialog()),
                              ),
                              _ActionButton(
                                icon: Icons.compare_arrows_rounded,
                                label: "Transfer",
                                color: Colors.orange,
                                onTap: () {
                                  // TODO: Transfer dialog
                                },
                              ),
                              _ActionButton(
                                icon: Icons.remove,
                                label: "Expense",
                                color: Colors.red,
                                onTap: () {
                                  // TODO: Expense dialog
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(height: 20),

                // 🟥 Filter Bar + Transactions Table
                PaymentFilterBar(onClear: () {}),
                const SizedBox(height: 20),
                TransactionTable(transactions: transactions),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 🔵 Action Button Widget
class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: _hover ? widget.color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: widget.color.withOpacity(0.3)),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.color.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.color, size: 20),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.color,
                  fontWeight: _hover ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}