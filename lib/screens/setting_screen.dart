import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/screens/profile_screen.dart';
import 'about_screen.dart';
// Tambahkan import jika ada screen lain
// import 'account_setting_screen.dart';

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
          // Profil
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.person), SizedBox(width: 8), Text('Profil')],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // About
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
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
          // Pengaturan Akun (contoh fitur tambahan)
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.settings), SizedBox(width: 8), Text('Pengaturan Akun')],
              ),
            ),
            onTap: () {
              // Ganti dengan screen pengaturan akun jika ada
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Fitur Pengaturan Akun segera hadir!')),
              );
            },
          ),
          // Logout
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            title: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(Icons.logout), SizedBox(width: 8), Text('Logout')],
              ),
            ),
            onTap: () {
              // Tambahkan aksi logout sesuai kebutuhan
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}