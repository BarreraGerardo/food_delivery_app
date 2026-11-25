import 'package:flutter/material.dart';

typedef MenuItemMap = Map<String, dynamic>;

class CartItem {
  final String id;
  final String name;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}

class OrderRecord {
  final String id;
  final double totalAmount;
  final String address;
  final String status;
  final int itemsCount;
  final DateTime createdAt;

  OrderRecord({
    required this.id,
    required this.totalAmount,
    required this.address,
    required this.status,
    required this.itemsCount,
    required this.createdAt,
  });
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final List<dynamic> _localOrders = [];

  final List<dynamic> categories = [
    {'name': 'All', 'image': 'assets/images/burger.png'},
    {'name': 'Burger', 'image': 'assets/images/burger.png'},
    {'name': 'Pizza', 'image': 'assets/images/pizza.png'},
    {'name': 'Sandwich', 'image': 'assets/images/sandwich.png'},
    {'name': 'Fries', 'image': 'assets/images/fries.png'},
    {'name': 'Sushi', 'image': 'assets/images/sushi.png'},
    {'name': 'Frappe', 'image': 'assets/images/frappe_mocha.png'},
  ];

  final List<MenuItemMap> catalog = [
    // --- HAMBURGUESAS ---
    {
      'id': 'b1',
      'name': 'Classic Smash Burger',
      'category': 'Burger',
      'description': 'Doble carne, queso americano, cebolla y pepinillos',
      'price': 9.99,
      'imageUrl': 'assets/images/burger.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800&auto=format&fit=crop',
    },
    {
      'id': 'b2',
      'name': 'Double Cheese Burger',
      'category': 'Burger',
      'description': 'Extra queso cheddar fundido y aderezo de la casa',
      'price': 10.99,
      'imageUrl': 'assets/images/burger_cheese.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&auto=format&fit=crop',
    },
    {
      'id': 'b3',
      'name': 'Crispy Bacon Burger',
      'category': 'Burger',
      'description': 'Tocino ahumado crujiente, lechuga fresca y salsa BBQ',
      'price': 11.49,
      'imageUrl': 'assets/images/burger_bacon.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?w=800&auto=format&fit=crop',
    },

    // --- PIZZAS ---
    {
      'id': 'pz1',
      'name': 'Pepperoni Feast Pizza',
      'category': 'Pizza',
      'description': 'Masa artesanal, queso mozzarella y abundante pepperoni',
      'price': 12.99,
      'imageUrl': 'assets/images/pizza.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800&auto=format&fit=crop',
    },
    {
      'id': 'pz2',
      'name': 'Classic Margherita Pizza',
      'category': 'Pizza',
      'description': 'Salsa de tomate natural, mozzarella fresca y albahaca',
      'price': 11.50,
      'imageUrl': 'assets/images/pizza_margherita.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800&auto=format&fit=crop',
    },
    {
      'id': 'pz3',
      'name': 'Smoky BBQ Chicken Pizza',
      'category': 'Pizza',
      'description': 'Pollo a la parrilla, cebolla morada, cilantro y salsa BBQ',
      'price': 13.75,
      'imageUrl': 'assets/images/pizza_bbq.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800&auto=format&fit=crop',
    },

    // --- SÁNDWICHES ---
    {
      'id': 'sw1',
      'name': 'Classic Club Sandwich',
      'category': 'Sandwich',
      'description': 'Tres niveles de pan tostado, jamón, queso, pollo y lechuga',
      'price': 7.99,
      'imageUrl': 'assets/images/sandwich.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800&auto=format&fit=crop',
    },
    {
      'id': 'sw2',
      'name': 'Grilled Cheese & Ham',
      'category': 'Sandwich',
      'description': 'Pan dorado a la mantequilla con mezcla de quesos y jamón',
      'price': 6.75,
      'imageUrl': 'assets/images/sandwich_grilled.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1553909489-cd47e0907980?w=800&auto=format&fit=crop',
    },
    {
      'id': 'sw3',
      'name': 'Crispy Chicken Sandwich',
      'category': 'Sandwich',
      'description': 'Pechuga empanizada crujiente, pepinillos y mayonesa especiada',
      'price': 8.50,
      'imageUrl': 'assets/images/sandwich_chicken.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1606755962773-d324e0a13086?w=800&auto=format&fit=crop',
    },

    // --- PAPAS ---
    {
      'id': 'p1',
      'name': 'Crispy Golden Fries',
      'category': 'Fries',
      'description': 'Papas corte clásico doradas y crujientes con sal de mar',
      'price': 4.49,
      'imageUrl': 'assets/images/fries.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=800&auto=format&fit=crop',
    },
    {
      'id': 'p2',
      'name': 'Cheesy Loaded Fries',
      'category': 'Fries',
      'description': 'Papas bañadas en salsa de queso cheddar y trozos de tocino',
      'price': 5.99,
      'imageUrl': 'assets/images/fries_cheese.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1630384060421-cb20d0e0649d?w=800&auto=format&fit=crop',
    },

    // --- SUSHI ---
    {
      'id': 's1',
      'name': 'Salmon Sushi Roll',
      'category': 'Sushi',
      'description': '8 piezas de salmón fresco, aguacate y ajonjolí tostado',
      'price': 11.49,
      'imageUrl': 'assets/images/sushi.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800&auto=format&fit=crop',
    },
    {
      'id': 's2',
      'name': 'Shrimp Tempura Roll',
      'category': 'Sushi',
      'description': 'Camarón tempura crujiente, pepino y salsa de anguila',
      'price': 12.25,
      'imageUrl': 'assets/images/sushi_tempura.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1611143669185-af224c5e3252?w=800&auto=format&fit=crop',
    },

    // --- FRAPPÉS ---
    {
      'id': 'fr1',
      'name': 'Mocha Frappé',
      'category': 'Frappe',
      'description': 'Café espresso helado, chocolate y crema batida',
      'price': 5.49,
      'imageUrl': 'assets/images/frappe_mocha.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=800&auto=format&fit=crop',
    },
    {
      'id': 'fr2',
      'name': 'Chocolate Thick Frappé',
      'category': 'Frappe',
      'description': 'Frappé cremoso de cacao intenso con chispas de chocolate',
      'price': 5.25,
      'imageUrl': 'assets/images/milkshake.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=800&auto=format&fit=crop',
    },
    {
      'id': 'fr3',
      'name': 'Iced Matcha Frappé',
      'category': 'Frappe',
      'description': 'Té matcha ceremonial batido con leche fría y hielo',
      'price': 5.75,
      'imageUrl': 'assets/images/frappe_matcha.png',
      'fallbackUrl':
          'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=800&auto=format&fit=crop',
    },
  ];

  Map<String, CartItem> get items => _items;
  List<dynamic> get localOrders => List<dynamic>.from(_localOrders);

  int get totalItemsCount {
    int total = 0;
    for (final item in _items.values) {
      total += item.quantity;
    }
    return total;
  }

  double get totalAmount {
    double total = 0;
    for (final item in _items.values) {
      total += item.subtotal;
    }
    return total;
  }

  void addItem({
    required String id,
    required String name,
    required double price,
    required String image,
    int quantity = 1,
  }) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity += quantity;
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
        quantity: quantity,
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.quantity > 1) {
      _items[id]!.quantity -= 1;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void addLocalOrder(OrderRecord order) {
    _localOrders.insert(0, order);
    notifyListeners();
  }
}