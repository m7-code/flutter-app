import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../widgets/product_grid.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ProductGrid(
        products: ref.watch(favoriteProductsProvider),
        emptyText: 'Abhi koi favorite nahi.\nHeart dabao to yahan aayega.',
      ),
    );
  }
}