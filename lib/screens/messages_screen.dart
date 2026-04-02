import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _senderController = TextEditingController();
  final _receiverController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  late Future<List<Map<String, dynamic>>> _messages;

  @override
  void initState() {
    super.initState();
    _messages = ApiService.fetchMessages();
  }

  @override
  void dispose() {
    _senderController.dispose();
    _receiverController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final ok = await ApiService.sendMessage({
      'senderName': _senderController.text.trim(),
      'receiverName': _receiverController.text.trim(),
      'subject': _subjectController.text.trim(),
      'body': _bodyController.text.trim(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? 'Message sent.' : 'Failed to send message.')),
    );
    if (ok) {
      setState(() => _messages = ApiService.fetchMessages());
      _subjectController.clear();
      _bodyController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _senderController, decoration: const InputDecoration(labelText: 'Sender Name')),
            const SizedBox(height: 8),
            TextField(controller: _receiverController, decoration: const InputDecoration(labelText: 'Receiver Name')),
            const SizedBox(height: 8),
            TextField(controller: _subjectController, decoration: const InputDecoration(labelText: 'Subject')),
            const SizedBox(height: 8),
            TextField(controller: _bodyController, minLines: 2, maxLines: 4, decoration: const InputDecoration(labelText: 'Message')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _send, child: const Text('Send')),
            const Divider(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _messages,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final messages = snapshot.data!;
                  if (messages.isEmpty) return const Center(child: Text('No messages yet.'));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      return ListTile(
                        title: Text(m['subject']?.toString() ?? 'No subject'),
                        subtitle: Text('${m['senderName'] ?? ''} → ${m['receiverName'] ?? ''}\n${m['body'] ?? ''}'),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
