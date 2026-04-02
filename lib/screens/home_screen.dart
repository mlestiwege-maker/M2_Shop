import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import 'buyer_dashboard_screen.dart';
import 'cart_screen.dart';
import 'contact_screen.dart';
import 'login_screen.dart';
import 'messages_screen.dart';
import 'order_tracking_screen.dart';
import 'rfq_screen.dart';
import 'supplier_dashboard_screen.dart';
import 'suppliers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Electronics', 'Clothing', 'Books', 'Toys'];

  @override
  void initState() {
    super.initState();
    _refreshProducts();
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
    if (!mounted) return;

    setState(() {
      _allProducts = products;
      _displayedProducts = List<Product>.from(_allProducts);
    });
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

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
                  onPressed: () => _openPage(const CartScreen()),
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
          auth.isAuthenticated
              ? IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  tooltip: 'Logout',
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Colors.grey[850],
                        title: const Text('Logout', style: TextStyle(color: Colors.white)),
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

                    if (!(confirm ?? false) || !context.mounted) return;
                    await auth.logout();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('You are now browsing as guest.')),
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.login, color: Colors.white),
                  tooltip: 'Login',
                  onPressed: () => _openPage(const LoginScreen()),
                ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        color: Colors.deepPurpleAccent,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: const TextStyle(color: Colors.white70),
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
                      label: Text(
                        category,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                      ),
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
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Marketplace Features',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _FeatureButton(title: 'Contact', icon: Icons.support_agent, onTap: () => _openPage(const ContactScreen())),
                  _FeatureButton(title: 'Suppliers', icon: Icons.factory, onTap: () => _openPage(const SuppliersScreen())),
                  _FeatureButton(title: 'RFQ', icon: Icons.request_quote, onTap: () => _openPage(const RfqScreen())),
                  _FeatureButton(title: 'Buyer', icon: Icons.dashboard, onTap: () => _openPage(const BuyerDashboardScreen())),
                  _FeatureButton(title: 'Supplier', icon: Icons.store_mall_directory, onTap: () => _openPage(const SupplierDashboardScreen())),
                  _FeatureButton(title: 'Messages', icon: Icons.chat_bubble_outline, onTap: () => _openPage(const MessagesScreen())),
                  _FeatureButton(title: 'Orders', icon: Icons.local_shipping_outlined, onTap: () => _openPage(const OrderTrackingScreen())),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _displayedProducts.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
          ],
        ),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white)),
        onPressed: onTap,
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }
}
