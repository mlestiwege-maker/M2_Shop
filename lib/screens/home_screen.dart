import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../services/api_service.dart';

import '../widgets/product_card.dart';

import '../models/product.dart';

import 'cart_screen.dart';

import '../providers/cart_provider.dart';

import '../providers/auth_provider.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

const HomeScreen({super.key});

@override

State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

late Future<List<Product>> _productsFuture;

List<Product> _allProducts = [];

List<Product> _displayedProducts = [];

String _searchQuery = '';

String _selectedCategory = 'All';

final List<String> _categories = ['All', 'Electronics', 'Clothing', 'Books', 'Toys'];

@override

void initState() {

super.initState();

_productsFuture = ApiService.fetchProducts().then((products) {

  _allProducts = products;

  _displayedProducts = List.from(_allProducts);

  return products;

});

}

void _filterProducts() {

setState(() {

  _displayedProducts = _allProducts.where((product) {

    final matchesCategory = _selectedCategory == 'All' || product.category == _selectedCategory;

    final matchesSearch = product.name.toLowerCase().contains(_searchQuery.toLowerCase());

    return matchesCategory && matchesSearch;

  }).toList();

});

}

Future<void> _refreshProducts() async {

final products = await ApiService.fetchProducts();

setState(() {

  _allProducts = products;

  _filterProducts();

});

}

@override

Widget build(BuildContext context) {

final auth = Provider.of<AuthProvider>(context, listen: false);



return Scaffold(

  backgroundColor: Colors.grey[900],

  appBar: AppBar(

    backgroundColor: Colors.black87,

    title: const Text(

      '🛍️ M2 Shop',

      style: TextStyle(color: Colors.white),

    ),

    centerTitle: true,

    actions: [

      Consumer<CartProvider>(

        builder: (context, cart, _) => Stack(

          children: [

            IconButton(

              icon: const Icon(Icons.shopping_cart, color: Colors.white),

              onPressed: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(builder: (_) => const CartScreen()),

                );

              },

            ),

            if (cart.itemCount > 0)

              Positioned(

                right: 7,

                top: 7,

                child: CircleAvatar(

                  radius: 10,

                  backgroundColor: Colors.red,

                  child: Text(

                    cart.itemCount.toString(),

                    style: const TextStyle(

                      fontSize: 12,

                      color: Colors.white,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ),

              ),

          ],

        ),

      ),

      IconButton(

        icon: const Icon(Icons.logout, color: Colors.white),

        tooltip: 'Logout',

        onPressed: () async {

          final confirm = await showDialog<bool>(

            context: context,

            builder: (_) => AlertDialog(

              backgroundColor: Colors.grey[850],

              title: const Text(

                'Logout',

                style: TextStyle(color: Colors.white),

              ),

              content: const Text(

                'Are you sure you want to log out of M2 Shop?',

                style: TextStyle(color: Colors.white70),

              ),

              actions: [

                TextButton(

                  onPressed: () => Navigator.pop(context, false),

                  child: const Text('Cancel'),

                ),

                ElevatedButton(

                  onPressed: () => Navigator.pop(context, true),

                  child: const Text('Logout'),

                ),

              ],

            ),

          );



          if (confirm ?? false) {

            await auth.logout();

            if (mounted) {

              Navigator.pushReplacement(

                context,

                MaterialPageRoute(builder: (_) => const LoginScreen()),

              );

            }

          }

        },

      ),

    ],

  ),

  body: RefreshIndicator(

    onRefresh: _refreshProducts,

    color: Colors.deepPurpleAccent,

    child: Column(

      children: [

        // Search Field

        Padding(

          padding: const EdgeInsets.all(8.0),

          child: TextField(

            style: const TextStyle(color: Colors.white),

            decoration: InputDecoration(

              hintText: 'Search products...',

              hintStyle: TextStyle(color: Colors.white70),

              prefixIcon: const Icon(Icons.search, color: Colors.white),

              filled: true,

              fillColor: Colors.grey[800],

              border: OutlineInputBorder(

                borderRadius: BorderRadius.circular(12),

                borderSide: BorderSide.none,

              ),

            ),

            onChanged: (value) {

              _searchQuery = value;

              _filterProducts();

            },

          ),

        ),

        // Category Filter

        SizedBox(

          height: 40,

          child: ListView.builder(

            scrollDirection: Axis.horizontal,

            itemCount: _categories.length,

            itemBuilder: (context, index) {

              final category = _categories[index];

              final isSelected = _selectedCategory == category;

              return Padding(

                padding: const EdgeInsets.symmetric(horizontal: 6),

                child: ChoiceChip(

                  label: Text(category, style: TextStyle(color: isSelected ? Colors.white : Colors.white70)),

                  selected: isSelected,

                  backgroundColor: Colors.grey[800],

                  selectedColor: Colors.deepPurpleAccent,

                  onSelected: (_) {

                    _selectedCategory = category;

                    _filterProducts();

                  },

                ),

              );

            },

          ),

        ),

        const SizedBox(height: 8),

        // Product Grid

        Expanded(

          child: _displayedProducts.isEmpty

              ? const Center(

                  child: Text(

                    'No products found',

                    style: TextStyle(color: Colors.white70),

                  ),

                )

              : Padding(

                  padding: const EdgeInsets.all(8.0),

                  child: GridView.builder(

                    itemCount: _displayedProducts.length,

                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                      crossAxisCount: 2,

                      childAspectRatio: 0.7,

                      crossAxisSpacing: 10,

                      mainAxisSpacing: 10,

                    ),

                    itemBuilder: (context, index) {

                      return ProductCard(product: _displayedProducts[index]);

                    },

                  ),

                ),

        ),

      ],

    ),

  ),

);

}

} 