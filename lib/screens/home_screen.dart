import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'expense_list_screen.dart';
import 'profile_screen.dart';
import 'setting_screen.dart';
import 'advanced_list_data.dart';
import 'about_screen.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import 'message_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Daftar visibilitas untuk animasi
  final List<bool> _visibleItems = List.generate(8, (index) => false);

  @override
  void initState() {
    super.initState();
    _startStaggeredAnimation();
  }

  // Fungsi untuk memberi delay animasi antar item
  void _startStaggeredAnimation() async {
    for (int i = 0; i < _visibleItems.length; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _visibleItems[i] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Pengeluaran Advanced',
        'icon': Icons.bar_chart,
        'color': Colors.green,
        'screen': const AdvancedExpenseListScreen(),
      },
      {
        'title': 'Pengeluaran Basic',
        'icon': Icons.attach_money,
        'color': Colors.lightGreen,
        'screen': const ExpenseListScreen(),
      },
      {
        'title': 'Profil',
        'icon': Icons.person,
        'color': Colors.blueAccent,
        'screen': const ProfileScreen(),
      },
      {
        'title': 'Pesan',
        'icon': Icons.message,
        'color': Colors.orangeAccent,
        'screen': const MessageScreen(),
      },
      {
        'title': 'Statistik',
        'icon': Icons.pie_chart,
        'color': Colors.indigoAccent,
        'screen': const StatisticScreen(),
      },
      {
        'title': 'Kategori',
        'icon': Icons.category,
        'color': Colors.teal,
        'screen': const CategoryScreen(),
      },
      {
        'title': 'Tentang',
        'icon': Icons.info_outline,
        'color': Colors.redAccent,
        'screen': const AboutScreen(),
      },
      {
        'title': 'Pengaturan',
        'icon': Icons.settings,
        'color': Colors.purpleAccent,
        'screen': const SettingScreen(),
      },
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Beranda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6dd5ed), Color(0xFF2193b0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pilih menu untuk melanjutkan:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: items.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return AnimatedOpacity(
                        opacity: _visibleItems[index] ? 1 : 0,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOut,
                        child: AnimatedScale(
                          scale: _visibleItems[index] ? 1 : 0.8,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutBack,
                          child: _buildDashboardCard(
                            title: item['title'] as String,
                            icon: item['icon'] as IconData,
                            color: item['color'] as Color,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => item['screen'] as Widget,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
