import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/food_card.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final categories = cartProvider.categories;

    final filteredItems = cartProvider.catalog.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final name = item['name'].toString().toLowerCase();
      final desc = item['description'].toString().toLowerCase();
      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty || name.contains(query) || desc.contains(query);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Menú Completo')),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar hamburguesa, papas, sushi, frappé...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final catName = categories[index]['name']!;
                final selected = _selectedCategory == catName;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(catName),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _selectedCategory = catName),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text('No hay platillos que coincidan con tu búsqueda'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final data = filteredItems[index];
                      return FoodCard(
                        id: data['id'] as String,
                        name: data['name'] as String,
                        description: data['description'] as String,
                        price: (data['price'] as num).toDouble(),
                        imageUrl: data['imageUrl'] as String,
                        fallbackUrl: data['fallbackUrl'] as String?,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/product_details',
                          arguments: {'id': data['id'], 'data': data},
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}