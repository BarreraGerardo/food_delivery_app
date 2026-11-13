import 'package:flutter/material.dart';
import '../models/product_model.dart';

class FoodCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Expanded(
              child: product.imageUrl.isEmpty
                  ? const Icon(Icons.fastfood, size: 60)
                  : Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            Text(product.name),
            Text('\$${product.price.toStringAsFixed(2)} MXN'),
          ],
        ),
      ),
    );
  }
}
