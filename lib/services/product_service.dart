import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Fetch all products
  Future<List<Product>> getProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the ID to the data map
        return Product.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Get products as a stream for real-time updates
  Stream<List<Product>> getProductsStream() {
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
    });
  }

  // Get products filtered by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Get a specific product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(productId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching product by ID: $e');
      return null;
    }
  }

  // Search products by name
  Future<List<Product>> searchProducts(String query) async {
    try {
      // Get all products (in a real app, you might want to use a proper search solution)
      QuerySnapshot snapshot = await _firestore.collection(_collection).get();

      List<Product> products = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();

      // Filter locally (this is simplified - consider using Algolia or similar for production)
      return products.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get featured/trending products
  Future<List<Product>> getTrendingProducts({int limit = 5}) async {
    try {
      // In a real app, you might have a 'trending' field to sort by
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching trending products: $e');
      return [];
    }
  }
}