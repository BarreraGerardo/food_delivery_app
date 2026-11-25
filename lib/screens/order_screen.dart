import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseService().currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Pedidos')),
      body: uid == null
          ? const Center(child: Text('Inicia sesión para ver tus pedidos'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('orderedBy', isEqualTo: uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final orders = snapshot.data!.docs;
                if (orders.isEmpty) {
                  return const Center(child: Text('Aún no tienes pedidos'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final doc = orders[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.receipt_long,
                            color: Colors.orange),
                        title: Text('Pedido #${doc.id.substring(0, 6)}'),
                        subtitle:
                            Text('Estado: ${data['status'] ?? 'En proceso'}'),
                        trailing: Text(
                          '\$${data['totalAmount'] ?? 0}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}