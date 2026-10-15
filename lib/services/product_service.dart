import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductService {
  final _db = FirebaseFirestore.instance;

  Future<void> toggleFavorite(String productId, bool isFav) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final ref =
        _db.collection('users').doc(uid).collection('favorites').doc(productId);
    if (isFav) {
      await ref.delete();
    } else {
      await ref.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> deleteProduct(String id) =>
      _db.collection('products').doc(id).delete();

  Future<void> updatePrice(String id, double price) =>
      _db.collection('products').doc(id).update({'price': price});
}

final productServiceProvider = Provider<ProductService>((ref) => ProductService());