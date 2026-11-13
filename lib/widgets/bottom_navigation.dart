import 'package:flutter/material.dart';

class FoodNavigation extends StatefulWidget {
  const FoodNavigation({super.key});

  @override
  State<FoodNavigation> createState() =>
      _FoodNavigationState();
}

class _FoodNavigationState extends State<FoodNavigation> {
  int selectedIndex = 0;

  final pages = const [
    Center(child: Text('Inicio')),
    Center(child: Text('Favoritos')),
    Center(child: Text('Carrito')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
