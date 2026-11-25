import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loading_dialog.dart';

class ProductImageUploadScreen extends StatefulWidget {
  const ProductImageUploadScreen({super.key});

  @override
  State<ProductImageUploadScreen> createState() =>
      _ProductImageUploadScreenState();
}

class _ProductImageUploadScreenState extends State<ProductImageUploadScreen> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _uploadProduct() async {
    if (_imageFile == null ||
        _nameController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const LoadingDialog(message: 'Publicando platillo'),
    );

    try {
      String imageUrl =
          await _firebaseService.uploadImage(_imageFile!, 'products');
      await FirebaseFirestore.instance.collection('products').add({
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'category': _categoryController.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al publicar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Platillo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                          Text('Seleccionar foto del platillo'),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _nameController,
              data: Icons.fastfood,
              hintText: 'Nombre del platillo',
            ),
            CustomTextField(
              controller: _descController,
              data: Icons.description,
              hintText: 'Descripción',
            ),
            CustomTextField(
              controller: _priceController,
              data: Icons.attach_money,
              hintText: 'Precio',
              keyboardType: TextInputType.number,
            ),
            CustomTextField(
              controller: _categoryController,
              data: Icons.category,
              hintText: 'Categoría (ej. Pizza, Bebidas)',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _uploadProduct,
                child: const Text('Publicar Platillo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}