import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Admin Panel'),
        backgroundColor: Colors.orange,
      ),
      drawer: const Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Text(
                'FOOD ADMIN',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.restaurant_menu),
              title: Text('Productos'),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag),
              title: Text('Pedidos'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text('Usuarios'),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Panel de administración',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
