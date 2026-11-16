import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            accountName: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(userEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
                  ? NetworkImage(userPhotoUrl!)
                  : null,
              child: (userPhotoUrl == null || userPhotoUrl!.isEmpty)
                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.reorder),
            title: const Text('Mis Pedidos'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a pantalla de pedidos
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a historial
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Mis Direcciones'),
            onTap: () {
              Navigator.pop(context);
              // Navegar a direcciones
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}