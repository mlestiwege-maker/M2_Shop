import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m2/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final cartItems = cart.items.values.toList();
        
        return Scaffold(
          appBar: AppBar(title: const Text('Cart')),
          body: cartItems.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    final product = item['product'];
                    final quantity = item['quantity'];

                    return ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)} x $quantity'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => cart.removeSingleItem(product.id),
                      ),
                    );
                  },
                ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total: \$${cart.totalPrice.toStringAsFixed(2)}'),
                ElevatedButton(
                  onPressed: () => cart.clearCart(),
                  child: const Text('Clear Cart'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
