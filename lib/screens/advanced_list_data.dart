import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'expense_form.dart';
import 'dart:io' show File;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'dart:html' as html;

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = ExpenseService.expenses;
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredExpenses = expenses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7FF),
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Daftar Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4BA3E3),
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            onSelected: (value) {
              if (value == 'csv') {
                kIsWeb
                    ? _exportToCSVWeb(filteredExpenses)
                    : _exportToCSV(context, filteredExpenses);
              } else if (value == 'pdf') {
                kIsWeb
                    ? _exportToPDFWeb(filteredExpenses)
                    : _exportToPDF(context, filteredExpenses);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'csv', child: Text('Export ke CSV')),
              const PopupMenuItem(value: 'pdf', child: Text('Export ke PDF')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Judul Dashboard-style
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dashboard Pengeluaran',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kelola dan analisis data pengeluaran Anda:',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Cari pengeluaran...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (_) => _filterExpenses(),
              ),
              const SizedBox(height: 16),

              // Filter kategori
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: ['Semua', ...ExpenseService.categoryNames.values]
                      .map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        selectedColor: const Color(0xFF4BA3E3),
                        labelStyle: TextStyle(
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            selectedCategory = category;
                            _filterExpenses();
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Statistik ringkas
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      Icons.summarize,
                      'Total',
                      'Rp ${_getTotal(filteredExpenses).toStringAsFixed(0)}',
                    ),
                    _buildStatCard(
                      Icons.list_alt,
                      'Jumlah',
                      '${filteredExpenses.length} item',
                    ),
                    _buildStatCard(
                      Icons.bar_chart,
                      'Rata-rata',
                      'Rp ${ExpenseService.getAverageDaily(filteredExpenses).toStringAsFixed(0)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Daftar pengeluaran
              filteredExpenses.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Tidak ada pengeluaran ditemukan',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Column(
                      children: filteredExpenses.map((expense) {
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _getCategoryColor(expense.category),
                              child: Icon(
                                _getCategoryIcon(expense.category),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              expense.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${expense.category} • ${expense.formattedDate}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            trailing: Text(
                              expense.formattedAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600],
                              ),
                            ),
                            onTap: () => _showExpenseDetails(context, expense),
                          ),
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4BA3E3),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ======== UI Helper ========
  Widget _buildStatCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4BA3E3)),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Colors.orange;
      case 'transportasi':
        return Colors.green;
      case 'utilitas':
        return Colors.purple;
      case 'hiburan':
        return Colors.pink;
      case 'pendidikan':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.restaurant;
      case 'transportasi':
        return Icons.directions_car;
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

  // ======== FILTER & EXPORT ========
  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        bool matchesSearch = searchController.text.isEmpty ||
            expense.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
        bool matchesCategory =
            selectedCategory == 'Semua' || expense.category == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  

  double _getTotal(List<Expense> expenses) {
    final totals = ExpenseService.getTotalByCategory(expenses);
    return totals.values.fold(0, (sum, value) => sum + value);
  }

  Future<void> _exportToCSV(
      BuildContext context, List<Expense> expenses) async {
    final csv = StringBuffer();
    csv.writeln('Judul,Nominal,Kategori,Tanggal,Deskripsi');
    for (var e in expenses) {
      csv.writeln(
          '"${e.title}",${e.amount},"${e.category}","${e.formattedDate}","${e.description}"');
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/pengeluaran.csv';
    final file = File(path);
    await file.writeAsString(csv.toString());
    await Share.shareXFiles([XFile(path)], text: 'Export Data Pengeluaran');
  }

  Future<void> _exportToCSVWeb(List<Expense> expenses) async {
    final csv = StringBuffer();
    csv.writeln('Judul,Nominal,Kategori,Tanggal,Deskripsi');
    for (var e in expenses) {
      csv.writeln(
          '"${e.title}",${e.amount},"${e.category}","${e.formattedDate}","${e.description}"');
    }

    final bytes = utf8.encode(csv.toString());
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'pengeluaran.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  Future<void> _exportToPDF(
      BuildContext context, List<Expense> expenses) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Center(
          child: pw.Text('Laporan Pengeluaran',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['Judul', 'Nominal', 'Kategori', 'Tanggal', 'Deskripsi'],
          data: expenses
              .map((e) => [
                    e.title,
                    'Rp ${e.amount.toStringAsFixed(0)}',
                    e.category,
                    e.formattedDate,
                    e.description
                  ])
              .toList(),
        )
      ],
    ));

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/laporan_pengeluaran.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(path)], text: 'Export Data Pengeluaran PDF');
  }

  Future<void> _exportToPDFWeb(List<Expense> expenses) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
      build: (context) => [
        pw.Center(
          child: pw.Text('Laporan Pengeluaran',
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['Judul', 'Nominal', 'Kategori', 'Tanggal', 'Deskripsi'],
          data: expenses
              .map((e) => [
                    e.title,
                    'Rp ${e.amount.toStringAsFixed(0)}',
                    e.category,
                    e.formattedDate,
                    e.description
                  ])
              .toList(),
        )
      ],
    ));

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'laporan_pengeluaran.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(expense.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jumlah: ${expense.formattedAmount}'),
            Text('Kategori: ${expense.category}'),
            Text('Tanggal: ${expense.formattedDate}'),
            Text('Deskripsi: ${expense.description}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
