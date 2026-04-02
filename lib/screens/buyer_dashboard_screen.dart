import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BuyerDashboardScreen extends StatefulWidget {
  const BuyerDashboardScreen({super.key});

  @override
  State<BuyerDashboardScreen> createState() => _BuyerDashboardScreenState();
}

class _BuyerDashboardScreenState extends State<BuyerDashboardScreen> {
  late Future<List<Map<String, dynamic>>> _orders;
  late Future<List<Map<String, dynamic>>> _rfqs;

  @override
  void initState() {
    super.initState();
    _orders = ApiService.fetchOrders();
    _rfqs = ApiService.fetchRfqs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _metricCard('My Orders', _orders)),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('My RFQs', _rfqs)),
              ],
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                Chip(label: Text('Create RFQ')),
                Chip(label: Text('Contact Supplier')),
                Chip(label: Text('Track Order')),
                Chip(label: Text('Saved Suppliers')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, Future<List<Map<String, dynamic>>> future) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('$count', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }
}
