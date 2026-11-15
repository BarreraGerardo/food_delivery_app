import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db =
      FirebaseFirestore.instance;

  Future<void> addProduct(
    Map<String, dynamic> product,
  ) async {
    await db.collection('products').add({
      ...product,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>
      getProducts() {
    return db.collection('products').snapshots();
  }

  Future<void> updateProduct(
    String id,
    Map<String, dynamic> data,
  ) async {
    await db.collection('products').doc(id).update(data);
  }

  Future<void> deleteProduct(String id) async {
    await db.collection('products').doc(id).delete();
  }
}