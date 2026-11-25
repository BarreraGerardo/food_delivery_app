import 'package:cloud_firestore/cloud_firestore.dart';

typedef OrderItem = Map<String, dynamic>;

class OrderModel {
  final String orderId;
  final String orderedBy;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String address;
  final Timestamp? orderTime;

  OrderModel({
    required this.orderId,
    required this.orderedBy,
    required this.items,
    required this.totalAmount,
    this.status = 'pendiente',
    this.address = '',
    this.orderTime,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    final rawItems = map['items'];
    final parsedItems = rawItems is List
        ? rawItems
            .whereType()
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
        : <OrderItem>[];

    return OrderModel(
      orderId: documentId,
      orderedBy: map['orderedBy'] ?? '',
      items: parsedItems,
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pendiente',
      address: map['address'] ?? '',
      orderTime: map['orderTime'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderedBy': orderedBy,
      'items': items,
      'totalAmount': totalAmount,
      'status': status,
      'address': address,
      'orderTime': orderTime ?? FieldValue.serverTimestamp(),
    };
  }
}