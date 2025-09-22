import 'package:flutter/material.dart';
import 'about_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 0,
            ), // Hilangkan padding kiri-kanan
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.info), SizedBox(width: 8), Text('About')],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          // Tambahkan opsi pengaturan lainnya di sini
        ],
      ),
    );
  }
}
