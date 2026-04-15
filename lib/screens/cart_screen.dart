import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:m2/providers/cart_provider.dart';
import 'package:m2/utils/category_image_resolver.dart';

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
                      leading: product.imageUrl.isEmpty
                          ? SvgPicture.asset(
                              CategoryImageResolver.byCategoryAsset(product.category),
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              product.imageUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => SvgPicture.asset(
                                CategoryImageResolver.byCategoryAsset(product.category),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
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
