import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  final String restaurantId;
  final Map<String, dynamic> restaurantData;

  const RestaurantScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(restaurantData['name'] ?? 'Restaurante')),
      body: Column(
        children: [
          Image.network(
            restaurantData['imageUrl'] ?? '',
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            // ignore: unnecessary_underscores
            errorBuilder: (_, __, ___) => Container(
              height: 180,
              color: Colors.grey[300],
              child: const Icon(Icons.store, size: 60),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurantData['name'] ?? '',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(restaurantData['address'] ?? '',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('restaurantId', isEqualTo: restaurantId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final doc = items[index];
                    final item = doc.data() as Map<String, dynamic>;
                    return ListTile(
                      leading: Image.network(
                        item['imageUrl'] ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        // ignore: unnecessary_underscores
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood),
                      ),
                      title: Text(item['name'] ?? ''),
                      subtitle: Text(item['description'] ?? ''),
                      trailing: Text('\$${item['price'] ?? 0}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product_details',
                          arguments: {'id': doc.id, 'data': item},
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}