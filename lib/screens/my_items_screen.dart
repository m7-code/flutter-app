import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/product_grid.dart';

class MyItemsScreen extends ConsumerWidget {
  const MyItemsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Items')),
      body: ProductGrid(
        products: ref.watch(myProductsProvider),
        emptyText: 'Aap ne abhi kuch sell ke liye nahi lagaya.',
        manage: true,
      ),
    );
  }
}