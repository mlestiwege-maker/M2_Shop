import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: cart.itemCount == 0
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List of items
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items.values.toList()[index];
                        final product = item['product'];
                        final quantity = item['quantity'] as int;
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                          title: Text(
                            product.name,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          subtitle: Text(
                            '$quantity x \$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.tealAccent),
                          ),
                          trailing: Text(
                            '\$${(product.price * quantity).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(color: Colors.white54),
                  const SizedBox(height: 8),

                  // Total price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            backgroundColor: Colors.grey[850],
                            title: const Text(
                              'Confirm Purchase',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              'Proceed to pay \$${cart.totalPrice.toStringAsFixed(2)}?',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );

                        if (confirm ?? false) {
                          await Future.delayed(const Duration(seconds: 1)); // Simulate delay
                          if (context.mounted) {
                            cart.clearCart();
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                backgroundColor: Colors.grey[850],
                                title: const Text(
                                  'Payment Successful 🎉',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Your order has been placed successfully!',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        'Confirm Payment',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
