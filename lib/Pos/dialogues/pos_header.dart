import 'package:flutter/material.dart';

class PosHeader extends StatelessWidget {
  const PosHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-30 * (1 - value), 0),
                    child: child,
                  ),
                ),
                child: const Icon(Icons.point_of_sale, size: 38, color: Colors.teal),
              ),
              const SizedBox(width: 10),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - value), 0),
                    child: child,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 600),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                  child: const Text("Point of Sale"),
                ),
              ),
              const SizedBox(width: 12),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                ),
                child: Chip(
                  label: Text(
                    "Credits: 0.00",
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: Colors.green.shade50,
                ),
              ),
              const SizedBox(width: 16),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1100),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: child,
                  ),
                ),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.teal.shade50,
                    child: Icon(Icons.account_circle, color: Colors.teal.shade400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
