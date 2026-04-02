import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _personController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _messageController = TextEditingController();
  String _inquiryType = 'general';
  bool _submitting = false;

  @override
  void dispose() {
    _companyController.dispose();
    _personController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    final ok = await ApiService.submitContact({
      'companyName': _companyController.text.trim(),
      'contactPerson': _personController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'country': _countryController.text.trim(),
      'inquiryType': _inquiryType,
      'message': _messageController.text.trim(),
    });

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Inquiry submitted successfully.' : 'Failed to submit inquiry.')),
    );

    if (ok) {
      _formKey.currentState?.reset();
      _messageController.clear();
      _companyController.clear();
      _personController.clear();
      _emailController.clear();
      _phoneController.clear();
      _countryController.clear();
      setState(() => _inquiryType = 'general');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _companyController, decoration: const InputDecoration(labelText: 'Company Name')),
              const SizedBox(height: 10),
              TextFormField(
                controller: _personController,
                decoration: const InputDecoration(labelText: 'Contact Person *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone')),
              const SizedBox(height: 10),
              TextFormField(controller: _countryController, decoration: const InputDecoration(labelText: 'Country')),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: _inquiryType,
                decoration: const InputDecoration(labelText: 'Inquiry Type'),
                items: const [
                  DropdownMenuItem(value: 'general', child: Text('General')),
                  DropdownMenuItem(value: 'bulk-order', child: Text('Bulk Order')),
                  DropdownMenuItem(value: 'partnership', child: Text('Partnership')),
                  DropdownMenuItem(value: 'support', child: Text('Support')),
                ],
                onChanged: (v) => setState(() => _inquiryType = v ?? 'general'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _messageController,
                minLines: 4,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Message *'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Submit Inquiry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
