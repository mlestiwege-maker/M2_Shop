import 'package:flutter/foundation.dart';
import 'package:m2/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, Map<String, dynamic>> _items = {};

  Map<int, Map<String, dynamic>> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += (item['product'].price ?? 0.0) * (item['quantity'] ?? 1);
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!['quantity'] += 1;
    } else {
      _items[product.id] = {
        'product': product,
        'quantity': 1,
      };
    }
    notifyListeners();
  }

  void removeSingleItem(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!['quantity'] > 1) {
        _items[productId]!['quantity'] -= 1;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
