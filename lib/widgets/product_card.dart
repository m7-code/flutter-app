import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/providers.dart';
import '../services/product_service.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final bool manage;
  const ProductCard({super.key, required this.product, this.manage = false});

  Future<void> _editPrice(BuildContext context, WidgetRef ref) async {
    final c = TextEditingController(text: product.price.toStringAsFixed(0));
    final newPrice = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Price badlo'),
        content: TextField(
          controller: c,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Price (Rs)'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, double.tryParse(c.text.trim())),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newPrice != null) {
      await ref.read(productServiceProvider).updatePrice(product.id, newPrice);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text(product.title),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('No')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(productServiceProvider).deleteProduct(product.id);
    }
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(left: 6),
        child: GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(icon, size: 18, color: Colors.black),
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favIds = ref.watch(favoriteIdsProvider).value ?? <String>{};
    final isFav = favIds.contains(product.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEDEDED)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                product.imageUrl.isEmpty
                    ? _placeholder()
                    : Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                      ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: manage
                      ? Row(children: [
                          _circleBtn(Icons.edit_outlined,
                              () => _editPrice(context, ref)),
                          _circleBtn(Icons.delete_outline,
                              () => _delete(context, ref)),
                        ])
                      : _circleBtn(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          () => ref
                              .read(productServiceProvider)
                              .toggleFavorite(product.id, isFav),
                        ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Rs ${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text('by ${product.sellerName}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
        color: const Color(0xFFF5F5F7),
        child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
      );
}