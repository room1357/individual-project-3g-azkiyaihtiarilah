import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'home_screen.dart'; // Pastikan file ini ada dan sesuai dengan nama class home kamu

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Expense> expenses = [
      Expense(
        id: '1',
        title: 'Belanja Bulanan',
        amount: 150000,
        category: 'Makanan',
        date: DateTime(2024, 9, 15),
        description: 'Belanja kebutuhan bulanan di supermarket',
      ),
      Expense(
        id: '2',
        title: 'Bensin Motor',
        amount: 50000,
        category: 'Transportasi',
        date: DateTime(2024, 9, 14),
        description: 'Isi bensin motor untuk transportasi',
      ),
      Expense(
        id: '3',
        title: 'Kopi di Cafe',
        amount: 25000,
        category: 'Makanan',
        date: DateTime(2024, 9, 14),
        description: 'Ngopi pagi dengan teman',
      ),
      Expense(
        id: '4',
        title: 'Tagihan Internet',
        amount: 300000,
        category: 'Utilitas',
        date: DateTime(2024, 9, 13),
        description: 'Tagihan internet bulanan',
      ),
      Expense(
        id: '5',
        title: 'Tiket Bioskop',
        amount: 100000,
        category: 'Hiburan',
        date: DateTime(2024, 9, 12),
        description: 'Nonton film weekend bersama keluarga',
      ),
      Expense(
        id: '6',
        title: 'Beli Buku',
        amount: 75000,
        category: 'Pendidikan',
        date: DateTime(2024, 9, 11),
        description: 'Buku pemrograman untuk belajar',
      ),
      Expense(
        id: '7',
        title: 'Makan Siang',
        amount: 35000,
        category: 'Makanan',
        date: DateTime(2024, 9, 11),
        description: 'Makan siang di restoran',
      ),
      Expense(
        id: '8',
        title: 'Ongkos Bus',
        amount: 10000,
        category: 'Transportasi',
        date: DateTime(2024, 9, 10),
        description: 'Ongkos perjalanan harian ke kampus',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0288D1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          tooltip: 'Kembali ke Home',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            tooltip: 'Export ke CSV',
            onPressed: () => _exportToCSV(context, expenses),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4FC3F7), Color(0xFF0288D1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Total Pengeluaran Box
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Pengeluaran',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      _calculateTotal(expenses),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ListView
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final expense = expenses[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundColor:
                                _getCategoryColor(expense.category),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            expense.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${expense.category} • ${expense.formattedDate}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          trailing: Text(
                            expense.formattedAmount,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === FUNCTION EXPORT CSV ===
  Future<void> _exportToCSV(BuildContext context, List<Expense> expenses) async {
    final csv = StringBuffer();
    csv.writeln('Judul,Nominal,Kategori,Tanggal,Deskripsi');
    for (var e in expenses) {
      csv.writeln(
        '"${e.title}",${e.amount},"${e.category}","${e.formattedDate}","${e.description}"',
      );
    }

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/pengeluaran.csv';
    final file = File(path);
    await file.writeAsString(csv.toString());

    await Share.shareXFiles([XFile(path)], text: 'Export Data Pengeluaran');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data diekspor ke CSV')),
    );
  }

  // === FUNCTION TAMBAHAN ===
  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Colors.orangeAccent;
      case 'transportasi':
        return Colors.green;
      case 'utilitas':
        return Colors.purple;
      case 'hiburan':
        return Colors.pinkAccent;
      case 'pendidikan':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant;
      case 'transportasi':
        return Icons.directions_bus;
      case 'utilitas':
        return Icons.home;
      case 'hiburan':
        return Icons.movie;
      case 'pendidikan':
        return Icons.school;
      default:
        return Icons.attach_money;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF9FAFC),
        title: Text(
          expense.title,
          style: const TextStyle(
            color: Color(0xFF0288D1),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah: ${expense.formattedAmount}'),
            const SizedBox(height: 8),
            Text('Kategori: ${expense.category}'),
            const SizedBox(height: 8),
            Text('Tanggal: ${expense.formattedDate}'),
            const SizedBox(height: 8),
            Text('Deskripsi: ${expense.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Tutup',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
