import 'package:flutter/material.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';

class StockStats extends StatelessWidget {
  final StockProvider stock;
  const StockStats({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double cWidth = w < 800 ? (w - 60) / 2 : 220;
    return Wrap(
      runSpacing: 16,
      spacing: 16,
      children: [
        StatCard(
          label: "Total Paid",
          value: "GHS ${stock.totalPaid.toStringAsFixed(2)}",
          width: cWidth,
        ),
        StatCard(
          label: "Total Unpaid",
          value: "GHS ${stock.totalUnpaid.toStringAsFixed(2)}",
          width: cWidth,
        ),
        StatCard(
          label: "Balance to be Paid",
          value: "GHS ${stock.balanceToBePaid.toStringAsFixed(2)}",
          width: cWidth,
        ),
        StatCard(
          label: "Current Stock Value",
          value: "GHS ${stock.currentStockValue.toStringAsFixed(2)}",
          width: cWidth,
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double width;
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
