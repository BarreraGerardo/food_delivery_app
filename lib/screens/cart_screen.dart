import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/confirmation_dialog.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();
    final uid = firebaseService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Carrito')),
      body: uid == null
          ? const Center(child: Text('Inicia sesión para ver tu carrito'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('cart')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!.docs;
                if (items.isEmpty) {
                  return const Center(child: Text('Tu carrito está vacío'));
                }

                double totalAmount = 0;
                for (var doc in items) {
                  totalAmount += (doc['totalPrice'] ?? 0).toDouble();
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final data =
                              items[index].data() as Map<String, dynamic>;
                          return ListTile(
                            leading: Image.network(
                              data['imageUrl'] ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              // ignore: unnecessary_underscores
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.fastfood),
                            ),
                            title: Text(data['name'] ?? ''),
                            subtitle: Text(
                                'Cantidad: ${data['quantity']} x \$${data['price']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => ConfirmationDialog(
                                    title: 'Eliminar producto',
                                    message:
                                        '¿Quitar ${data['name']} del carrito?',
                                    onConfirm: () => firebaseService
                                        .removeFromCart(data['productId']),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 6)
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/checkout',
                                arguments: totalAmount,
                              );
                            },
                            child: const Text('Continuar al Pago'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}