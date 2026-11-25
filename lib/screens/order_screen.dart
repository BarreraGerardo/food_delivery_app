import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_navigation.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localOrders = context.watch<CartProvider>().localOrders;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos')),
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('orderTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          final firestoreDocs = snapshot.hasData ? snapshot.data!.docs : [];

          if (localOrders.isEmpty && firestoreDocs.isEmpty) {
            return const Center(child: Text('Aún no tienes pedidos'));
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              ...localOrders.map(
                (order) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long,
                        color: Color(0xFF2E7D32)),
                    title: Text('Pedido ${order.id}'),
                    subtitle: Text(
                      'Estado: ${order.status} • ${order.itemsCount} art.',
                    ),
                    trailing: Text(
                      '\$${order.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              ...firestoreDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.cloud_done, color: Colors.orange),
                    title: Text('Pedido #${doc.id.substring(0, 6)}'),
                    subtitle: Text('Estado: ${data['status'] ?? 'pendiente'}'),
                    trailing: Text(
                      '\$${((data['totalAmount'] ?? 0) as num).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}