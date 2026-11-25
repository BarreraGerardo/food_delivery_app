import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('No hay productos en esta categoría'));
          }

          final products = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final doc = products[index];
              final data = doc.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  leading: Image.network(
                    data['imageUrl'] ?? '',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    // ignore: unnecessary_underscores
                    errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                  ),
                  title: Text(data['name'] ?? ''),
                  subtitle: Text('\$${data['price'] ?? 0}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product_details',
                      arguments: {'id': doc.id, 'data': data},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}