import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profil'), backgroundColor: Colors.blue),
      body: Center( // Tambahkan Center di sini
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Supaya column tidak memenuhi tinggi layar
            crossAxisAlignment: CrossAxisAlignment.center, // Tengah horizontal
            children: [
              Text(
                'Informasi Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person, size: 40, color: Colors.blue),
                title: Text(
                  'Nama Pengguna',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('username123'),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.email, size: 40, color: Colors.blue),
                title: Text(
                  'Email',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('email123@email.com'),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.phone, size: 40, color: Colors.blue),
                title: Text(
                  'Nomor Telepon',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('+62 812-3456-7890'),
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: Text('KEMBALI KE BERANDA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}