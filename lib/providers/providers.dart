import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

// Login state
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

// Sab products (live)
final allProductsProvider = StreamProvider<List<Product>>((ref) {
  return FirebaseFirestore.instance
      .collection('products')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map(Product.fromDoc).toList());
});

// Mere favorite product ids
final favoriteIdsProvider = StreamProvider<Set<String>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(<String>{});
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('favorites')
      .snapshots()
      .map((s) => s.docs.map((d) => d.id).toSet());
});

// Search text
class SearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final searchQueryProvider =
    NotifierProvider<SearchQuery, String>(SearchQuery.new);

// Home: search laga hua list
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final q = ref.watch(searchQueryProvider).trim().toLowerCase();
  return ref.watch(allProductsProvider).whenData((list) {
    if (q.isEmpty) return list;
    return list.where((p) => p.title.toLowerCase().contains(q)).toList();
  });
});

// Favorites tab
final favoriteProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final ids = ref.watch(favoriteIdsProvider).value ?? <String>{};
  return ref
      .watch(allProductsProvider)
      .whenData((list) => list.where((p) => ids.contains(p.id)).toList());
});

// My Items tab
final myProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  return ref
      .watch(allProductsProvider)
      .whenData((list) => list.where((p) => p.sellerId == uid).toList());
});