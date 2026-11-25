import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  User? get currentUser => auth.currentUser;

  // Registro de usuario
  Future<UserCredential> registerUser(
      String name, String email, String password) async {
    UserCredential cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await cred.user?.updateDisplayName(name);
    await firestore.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'name': name,
      'email': email,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred;
  }

  // Inicio de sesión
  Future<UserCredential> loginUser(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await auth.signOut();
  }

  // Subir imagen a Firebase Storage
  Future<String> uploadImage(File imageFile, String folder) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = storage.ref().child(folder).child('$fileName.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Guardar dirección
  Future<void> addAddress(Map<String, dynamic> addressData) async {
    if (currentUser == null) return;
    await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('addresses')
        .add(addressData);
  }

  // Agregar al carrito
  Future<void> addToCart(Map<String, dynamic> productData) async {
    if (currentUser == null) return;
    await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .doc(productData['productId'])
        .set(productData);
  }

  // Eliminar del carrito
  Future<void> removeFromCart(String productId) async {
    if (currentUser == null) return;
    await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('cart')
        .doc(productId)
        .delete();
  }
}