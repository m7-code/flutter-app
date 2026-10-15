import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final AsyncValue<List<Product>> products;
  final String emptyText;
  final bool manage;

  const ProductGrid({
    super.key,
    required this.products,
    required this.emptyText,
    this.manage = false,
  });

  @override
  Widget build(BuildContext context) {
    return products.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Text(emptyText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (_, i) => ProductCard(product: list[i], manage: manage),
        );
      },
    );
  }
}