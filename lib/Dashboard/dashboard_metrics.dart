import 'package:flutter/material.dart';

const kGreen = Color(0xFF21C087);

class DashboardMetrics extends StatelessWidget {
  const DashboardMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6, // LOWERED TO PREVENT OVERFLOW
      children: const [
        MetricCard(
          icon: Icons.attach_money,
          label: 'Total Expenses',
          value: 'GHS 4,800.00',
          valueColor: kGreen,
        ),
        MetricCard(
          icon: Icons.trending_up,
          label: 'Total Profit',
          value: 'GHS 10,500.00',
          valueColor: kGreen,
        ),
        MetricCard(
          icon: Icons.star,
          label: 'Credit Score',
          value: '638 (Bronze)',
          valueColor: kGreen,
        ),
        MetricCard(
          icon: Icons.shopping_cart,
          label: 'Total Sales',
          value: 'GHS 38,000.00',
          valueColor: kGreen,
        ),
        MetricCard(
          icon: Icons.warning,
          label: 'Unpaid Sales',
          value: 'GHS 0.00',
          valueColor: Colors.orange,
        ),
        MetricCard(
          icon: Icons.people_outline,
          label: 'Top Debtors',
          value: 'N/A',
          valueColor: Colors.red,
        ),
        MetricCard(
          icon: Icons.notifications_active,
          label: 'Loan Qualification',
          value: 'Eligible',
          valueColor: kGreen,
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const MetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: kGreen.withOpacity(0.12),
              child: Icon(icon, color: kGreen, size: 22),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      color: valueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
