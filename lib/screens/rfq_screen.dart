import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RfqScreen extends StatefulWidget {
  const RfqScreen({super.key});

  @override
  State<RfqScreen> createState() => _RfqScreenState();
}

class _RfqScreenState extends State<RfqScreen> {
  final _formKey = GlobalKey<FormState>();
  final _buyerController = TextEditingController();
  final _emailController = TextEditingController();
  final _productController = TextEditingController();
  final _qtyController = TextEditingController(text: '100');
  final _targetController = TextEditingController();
  final _countryController = TextEditingController();
  final _notesController = TextEditingController();

  late Future<List<Map<String, dynamic>>> _rfqs;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _rfqs = ApiService.fetchRfqs();
  }

  @override
  void dispose() {
    _buyerController.dispose();
    _emailController.dispose();
    _productController.dispose();
    _qtyController.dispose();
    _targetController.dispose();
    _countryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitRfq() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final ok = await ApiService.submitRfq({
      'buyerName': _buyerController.text.trim(),
      'email': _emailController.text.trim(),
      'productName': _productController.text.trim(),
      'quantity': int.tryParse(_qtyController.text.trim()) ?? 1,
      'targetPrice': double.tryParse(_targetController.text.trim()),
      'destinationCountry': _countryController.text.trim(),
      'notes': _notesController.text.trim(),
    });

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _rfqs = ApiService.fetchRfqs();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'RFQ submitted.' : 'Failed to submit RFQ.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request for Quotation (RFQ)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(controller: _buyerController, decoration: const InputDecoration(labelText: 'Buyer Name *'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email *'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _productController, decoration: const InputDecoration(labelText: 'Product Name *'), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _qtyController, decoration: const InputDecoration(labelText: 'Quantity *'), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextFormField(controller: _targetController, decoration: const InputDecoration(labelText: 'Target Price (optional)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextFormField(controller: _countryController, decoration: const InputDecoration(labelText: 'Destination Country')),
                  const SizedBox(height: 8),
                  TextFormField(controller: _notesController, minLines: 3, maxLines: 5, decoration: const InputDecoration(labelText: 'Notes')),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submitRfq,
                    child: _submitting ? const Text('Submitting...') : const Text('Submit RFQ'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('Latest RFQs', style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _rfqs,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final items = snapshot.data!;
                if (items.isEmpty) return const Text('No RFQs yet.');
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final rfq = items[i];
                    return Card(
                      child: ListTile(
                        title: Text('${rfq['productName']} • Qty: ${rfq['quantity']}'),
                        subtitle: Text('${rfq['buyerName']} • ${rfq['destinationCountry'] ?? 'N/A'}'),
                        trailing: Text('${rfq['status'] ?? 'open'}'.toUpperCase()),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
