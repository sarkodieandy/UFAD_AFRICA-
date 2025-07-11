import 'package:flutter/material.dart';
import 'package:ufad/products/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit, onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: child,
        ),
      ),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.teal.shade50,
                  child: Icon(product.category.icon, color: Colors.teal, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.category.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'GHS ${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blueAccent),
                  onPressed: onEdit,
                  tooltip: "Edit",
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                  onPressed: onDelete,
                  tooltip: "Delete",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
