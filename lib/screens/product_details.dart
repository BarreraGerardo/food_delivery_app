import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _addToCart() async {
    final price = (widget.productData['price'] ?? 0).toDouble();
    await _firebaseService.addToCart({
      'productId': widget.productId,
      'name': widget.productData['name'],
      'price': price,
      'quantity': _quantity,
      'totalPrice': price * _quantity,
      'imageUrl': widget.productData['imageUrl'] ?? '',
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agregado al carrito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.productData['name'] ?? 'Detalle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.productData['imageUrl'] ?? '',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                // ignore: unnecessary_underscores
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.fastfood, size: 80),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.productData['name'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${widget.productData['price'] ?? 0}',
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.productData['description'] ?? 'Sin descripción disponible.',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (_quantity > 1) setState(() => _quantity--);
                  },
                ),
                Text('$_quantity',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al Carrito',
                    style: TextStyle(fontSize: 16)),
                onPressed: _addToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}