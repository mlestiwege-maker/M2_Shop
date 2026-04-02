// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:m2/providers/cart_provider.dart';
import 'package:m2/providers/auth_provider.dart';
import 'package:m2/screens/login_screen.dart';
import 'package:m2/screens/main_screen.dart';
import 'package:m2/screens/register_screen.dart';
import 'package:m2/screens/profile_screen.dart';
import 'package:m2/screens/contact_screen.dart';
import 'package:m2/screens/suppliers_screen.dart';
import 'package:m2/screens/rfq_screen.dart';
import 'package:m2/screens/buyer_dashboard_screen.dart';
import 'package:m2/screens/supplier_dashboard_screen.dart';
import 'package:m2/screens/messages_screen.dart';
import 'package:m2/screens/order_tracking_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadToken()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'M2 Shop',
            theme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.black,
              scaffoldBackgroundColor: Colors.black,
              cardColor: Colors.grey[900],
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIconColor: Colors.white70,
              ),
            ),
            // Professional guest-first flow:
            // let users browse first, then authenticate when needed.
            home: const MainScreen(),
            routes: {
              '/login': (_) => const LoginScreen(),
              '/register': (_) => const RegisterScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/main': (_) => const MainScreen(),
              '/contact': (_) => const ContactScreen(),
              '/suppliers': (_) => const SuppliersScreen(),
              '/rfq': (_) => const RfqScreen(),
              '/buyer-dashboard': (_) => const BuyerDashboardScreen(),
              '/supplier-dashboard': (_) => const SupplierDashboardScreen(),
              '/messages': (_) => const MessagesScreen(),
              '/orders': (_) => const OrderTrackingScreen(),
            },
          );
        },
      ),
    );
  }
}
