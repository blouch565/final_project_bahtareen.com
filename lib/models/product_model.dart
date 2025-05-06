// lib/models/product_model.dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.category,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      rating: map['rating'] ?? 0.0,
      category: map['category'],
    );
  }
}