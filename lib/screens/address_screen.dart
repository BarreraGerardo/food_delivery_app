import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_textfield.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _saveAddress() async {
    if (_streetController.text.isEmpty || _cityController.text.isEmpty) return;

    await _firebaseService.addAddress({
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'street': _streetController.text.trim(),
      'city': _cityController.text.trim(),
    });

    _nameController.clear();
    _phoneController.clear();
    _streetController.clear();
    _cityController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dirección guardada correctamente')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = _firebaseService.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Direcciones')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              data: Icons.person,
              hintText: 'Nombre de quien recibe',
            ),
            CustomTextField(
              controller: _phoneController,
              data: Icons.phone,
              hintText: 'Teléfono de contacto',
              keyboardType: TextInputType.phone,
            ),
            CustomTextField(
              controller: _streetController,
              data: Icons.location_on,
              hintText: 'Calle y número',
            ),
            CustomTextField(
              controller: _cityController,
              data: Icons.location_city,
              hintText: 'Ciudad / Colonia',
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveAddress,
              child: const Text('Guardar Dirección'),
            ),
            const Divider(height: 30),
            Expanded(
              child: uid == null
                  ? const SizedBox()
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('addresses')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final addresses = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            final data = addresses[index].data()
                                as Map<String, dynamic>;
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.home),
                                title: Text(data['street'] ?? ''),
                                subtitle: Text(
                                    '${data['city']} - Tel: ${data['phone']}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}