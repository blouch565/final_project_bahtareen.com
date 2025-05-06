import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class WishlistProvider with ChangeNotifier {
  Map<String, Product> _items = {};

  Map<String, Product> get items => {..._items};

  int get itemCount => _items.length;

  bool isInWishlist(String id) {
    return _items.containsKey(id);
  }

  void toggleWishlist(Product product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
    } else {
      _items.putIfAbsent(product.id, () => product);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
