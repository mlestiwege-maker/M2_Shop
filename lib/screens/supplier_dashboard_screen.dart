import 'package:flutter/material.dart';

class SupplierDashboardScreen extends StatelessWidget {
  const SupplierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supplier Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            _DashTile(title: 'Open RFQs', value: '12'),
            _DashTile(title: 'Pending Quotes', value: '4'),
            _DashTile(title: 'New Messages', value: '8'),
            _DashTile(title: 'Active Orders', value: '6'),
          ],
        ),
      ),
    );
  }
}

class _DashTile extends StatelessWidget {
  final String title;
  final String value;

  const _DashTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(title),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
    );
  }
}
