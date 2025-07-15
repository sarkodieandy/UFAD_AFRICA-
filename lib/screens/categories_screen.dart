import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ufad/screens/products_screen.dart';
import '../../core/constants/colors.dart';
import '../../providers/category_provider.dart';
import '../../widgets/loader.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: AppColors.green,
        foregroundColor: Colors.white,
      ),
      body: categoryProvider.loading
          ? const Loader()
          : categoryProvider.error != null
              ? Center(child: Text(categoryProvider.error!))
              : ListView.builder(
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (_, index) {
                    final category = categoryProvider.categories[index];
                    return ListTile(
                      title: Text(category.name),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductScreen(categoryId: category.id, categoryName: category.name),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
