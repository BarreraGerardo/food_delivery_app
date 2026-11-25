import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/category_card.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final user = _firebaseService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Delivery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      drawer: Sidebar(
        userName: user?.displayName ?? 'Usuario',
        userEmail: user?.email ?? 'usuario@correo.com',
        userPhotoUrl: user?.photoURL,
        onLogout: () {
          showDialog(
            context: context,
            builder: (_) => ConfirmationDialog(
              title: 'Cerrar Sesión',
              message: '¿Deseas salir de tu cuenta?',
              onConfirm: () async {
                await _firebaseService.signOut();
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 55,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      final name = data['categoryName'] ?? '';
                      return CategoryCard(
                        categoryName: name,
                        imageUrl: data['thumbnailUrl'] ?? '',
                        isSelected: _selectedCategory == name,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == name ? '' : name;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Restaurantes Populares',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('restaurants')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final restaurants = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final doc = restaurants[index];
                    final data = doc.data() as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Image.network(
                          data['imageUrl'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          // ignore: unnecessary_underscores
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.restaurant, size: 40),
                        ),
                        title: Text(data['name'] ?? 'Restaurante'),
                        subtitle: Text(data['address'] ?? 'Dirección'),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/restaurant',
                            arguments: {'id': doc.id, 'data': data},
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}