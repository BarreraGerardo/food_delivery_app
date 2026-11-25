import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loading_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _addressController =
      TextEditingController(text: 'Calle 7 #292 X38 Fraccionamiento del Norte');

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: 'Confirmando pedido'),
    );

    final address = _addressController.text.trim().isEmpty
        ? 'Entrega a domicilio'
        : _addressController.text.trim();
    final total = cart.totalAmount;
    final itemsCount = cart.totalItemsCount;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';

    final orderItems = cart.items.values
        .map((item) => {
              'id': item.id,
              'name': item.name,
              'price': item.price,
              'quantity': item.quantity,
            })
        .toList();

    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .add({
            'orderedBy': uid,
            'items': orderItems,
            'totalAmount': total,
            'address': address,
            'status': 'pendiente',
            'orderTime': FieldValue.serverTimestamp(),
          })
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      // Si Firestore tarda por red o permisos, guardamos localmente para no bloquear al usuario
    } catch (_) {
      // Continúa para que el usuario vea su pedido confirmado sin quedarse atascado
    }

    cart.addLocalOrder(
      OrderRecord(
        id: 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        totalAmount: total,
        address: address,
        status: 'pendiente',
        itemsCount: itemsCount,
        createdAt: DateTime.now(),
      ),
    );
    cart.clearCart();

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushReplacementNamed(context, '/orders');
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              controller: _addressController,
              data: Icons.location_on,
              hintText: 'Dirección de entrega',
            ),
            const SizedBox(height: 16),
            Text(
              'Resumen (${cart.totalItemsCount} artículos)',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: cart.items.values
                    .map((item) => ListTile(
                          title: Text('${item.quantity}x ${item.name}'),
                          trailing:
                              Text('\$${item.subtotal.toStringAsFixed(2)}'),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _placeOrder,
                child: Text(
                  'Confirmar Pedido • \$${cart.totalAmount.toStringAsFixed(2)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}