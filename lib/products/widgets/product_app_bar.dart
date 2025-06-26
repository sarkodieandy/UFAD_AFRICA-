import 'package:flutter/material.dart';

class ProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  const ProductAppBar({super.key, required this.onBack});
  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      toolbarHeight: 85,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF21C087), size: 32),
        onPressed: onBack,
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: 8.0, top: 16),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "Product\n",
                style: TextStyle(
                  color: Color(0xFF21C087),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
              TextSpan(
                text: "Management",
                style: TextStyle(
                  color: Color(0xFF21C087),
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: Icon(
            Icons.account_circle_outlined,
            color: Color(0xFF21C087),
            size: 32,
          ),
        ),
      ],
    );
  }
}
