import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final suppliers = snapshot.data!;
          if (suppliers.isEmpty) {
            return const Center(child: Text('No suppliers available yet.'));
          }

          return ListView.separated(
            itemCount: suppliers.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final s = suppliers[index];
              final rating = (s['rating'] is num) ? (s['rating'] as num).toDouble() : 0.0;
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${s['name'] ?? 'S'}'.substring(0, 1).toUpperCase()),
                ),
                title: Text(s['name']?.toString() ?? 'Unknown Supplier'),
                subtitle: Text(
                  '${s['country'] ?? 'N/A'} • ${s['category'] ?? 'General'}\nMOQ: ${s['minOrderQty'] ?? '-'} • ${s['yearsInBusiness'] ?? 0} years',
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(rating.toStringAsFixed(1)),
                      ],
                    ),
                    if (s['verified'] == true)
                      const Text('Verified', style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
