import 'package:flutter/foundation.dart';
import '../models/product_model.dart'; // Import the Product model

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // Update quantity
      _items.update(
        product.id,
            (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      // Add new item
      _items.putIfAbsent(
        product.id,
            () => CartItem(product: product),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int change) {
    if (!_items.containsKey(productId)) return;

    final newQuantity = _items[productId]!.quantity + change;
    if (newQuantity <= 0) {
      removeItem(productId);
    } else {
      _items.update(
        productId,
            (existingItem) => CartItem(
          product: existingItem.product,
          quantity: newQuantity,
        ),
      );
    }
    notifyListeners();
  }

  // Clear cart method
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}