import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final int index;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [
        Colors.teal.shade500,
        Colors.teal.shade300,
        Colors.tealAccent.shade100,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 320 + 60 * index),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, valueAnim, child) => Opacity(
        opacity: valueAnim,
        child: Transform.translate(
          offset: Offset((1 - valueAnim) * 40, 0),
          child: child,
        ),
      ),
      child: SizedBox(
        width: 125,
        height: 68,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 3,
          shadowColor: Colors.teal.withOpacity(0.15),
          margin: const EdgeInsets.only(right: 12),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.03,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
