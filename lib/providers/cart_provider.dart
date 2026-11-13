import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {};

  Map<String, int> get items => Map.unmodifiable(_items);

  void add(Product product) {
    _items.update(
      product.id,
      (quantity) => quantity + 1,
      ifAbsent: () => 1,
    );
    notifyListeners();
  }

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void changeQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
    } else {
      _items[productId] = quantity;
      notifyListeners();
    }
  }

  int get totalItems =>
      _items.values.fold(0, (sum, quantity) => sum + quantity);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
