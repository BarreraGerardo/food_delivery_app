import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage =
      FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.jpg';

    final reference = storage
        .ref()
        .child('products')
        .child(fileName);

    final snapshot = await reference.putFile(file);

    return await snapshot.ref.getDownloadURL();
  }
}