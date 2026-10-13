import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final String sellerId;
  final String sellerName;

  Product({
    this.id = '',
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.sellerId,
    required this.sellerName,
  });

  factory Product.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return Product(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      imageUrl: d['imageUrl'] ?? '',
      price: (d['price'] ?? 0).toDouble(),
      sellerId: d['sellerId'] ?? '',
      sellerName: d['sellerName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'createdAt': FieldValue.serverTimestamp(),
      };
}