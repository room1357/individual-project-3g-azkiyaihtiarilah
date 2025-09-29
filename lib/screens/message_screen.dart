import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {
        'sender': 'Admin',
        'content': 'Selamat datang di aplikasi pengelola pengeluaran!',
        'time': '09:00'
      },
      {
        'sender': 'Support',
        'content': 'Jangan lupa cek fitur statistik terbaru.',
        'time': '10:15'
      },
      {
        'sender': 'Admin',
        'content': 'Kategori pengeluaran bisa ditambah di menu kategori.',
        'time': '11:30'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(msg['sender']![0]),
                backgroundColor: Colors.teal[200],
              ),
              title: Text(msg['sender'] ?? ''),
              subtitle: Text(msg['content'] ?? ''),
              trailing: Text(msg['time'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}