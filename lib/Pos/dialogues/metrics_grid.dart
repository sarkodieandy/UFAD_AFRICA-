import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/provider/pos_provider.dart';

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final posProvider = Provider.of<PosProvider>(context);

    final metrics = [
      {
        "title": "Sales",
        "value": "GHS ${posProvider.totalSales.toStringAsFixed(2)}",
        "icon": Icons.bar_chart,
        "color": Colors.teal.shade100,
      },
      {
        "title": "Paid",
        "value": "GHS ${posProvider.totalPaid.toStringAsFixed(2)}",
        "icon": Icons.payments,
        "color": Colors.green.shade100,
      },
      {
        "title": "Debtors",
        "value": "${posProvider.totalDebtors}",
        "icon": Icons.group,
        "color": Colors.orange.shade100,
      },
      {
        "title": "Debt Owed",
        "value": "GHS ${posProvider.totalBalance.toStringAsFixed(2)}",
        "icon": Icons.money_off,
        "color": Colors.red.shade100,
      },
      {
        "title": "Debt Balance",
        "value": "GHS ${(posProvider.totalBalance).toStringAsFixed(2)}",
        "icon": Icons.account_balance_wallet,
        "color": Colors.amber.shade100,
      },
    ];

    // Responsive columns
    int crossAxisCount = 2;
    final width = MediaQuery.of(context).size.width;
    if (width > 900) {
      crossAxisCount = 4;
    } else if (width > 600) {
      crossAxisCount = 3;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.15, // Tighter card look
      ),
      itemBuilder: (context, i) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 450 + i * 80),
          curve: Curves.easeOutBack,
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) {
            // Clamp opacity for extra safety
            final opacity = value.clamp(0.0, 1.0);
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Material(
            color: metrics[i]['color'] as Color,
            elevation: 0,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.teal.shade200.withOpacity(0.2),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 19,
                      child: Icon(
                        metrics[i]['icon'] as IconData,
                        color: Colors.teal.shade400,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            metrics[i]['title'] as String,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 13.2,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            metrics[i]['value'] as String,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
