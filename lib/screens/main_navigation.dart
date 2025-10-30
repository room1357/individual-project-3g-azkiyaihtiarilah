import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'profile_screen.dart';
import 'advanced_list_data.dart';
import 'category_screen.dart';
import 'statistics_screen.dart';
import 'home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2; // Home di tengah

  final List<Widget> _screens = const [
    AdvancedExpenseListScreen(),
    StatisticScreen(),
    HomeScreen(), // dipindah ke tengah
    CategoryScreen(),
    ProfileScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
