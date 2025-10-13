// import 'package:flutter/material.dart';
// import '../models/expense.dart';
// import '../services/expense_service.dart';
// import 'expense_form.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

// class AdvancedExpenseListScreen extends StatefulWidget {
//   const AdvancedExpenseListScreen({super.key});

//   @override
//   _AdvancedExpenseListScreenState createState() =>
//       _AdvancedExpenseListScreenState();
// }

// class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
//   // Gunakan data dari ExpenseService
//   List<Expense> expenses = ExpenseService.expenses;
//   List<Expense> filteredExpenses = [];
//   String selectedCategory = 'Semua';
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     filteredExpenses = expenses;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pengeluaran Advanced'),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             tooltip: 'Export ke CSV',
//             onPressed: () => _exportToCSV(context, expenses),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search bar
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: TextField(
//               controller: searchController,
//               decoration: const InputDecoration(
//                 hintText: 'Cari pengeluaran...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) {
//                 _filterExpenses();
//               },
//             ),
//           ),

//           // Category filter
//           SizedBox(
//             height: 50,
//             child: ListView(
//               scrollDirection: Axis.horizontal,
//               children:
//                   ['Semua', ...ExpenseService.categories]
//                       .map(
//                         (category) => FilterChip(
//                           label: Text(category),
//                           selected: selectedCategory == category,
//                           onSelected: (selected) {
//                             setState(() {
//                               selectedCategory = category;
//                               _filterExpenses();
//                             });
//                           },
//                         ),
//                       )
//                       .toList(),
//             ),
//           ),

//           // Statistics summary
//           Container(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildStatCard(
//                   'Total',
//                   'Rp ${_getTotal(filteredExpenses).toStringAsFixed(0)}',
//                 ),
//                 _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
//                 _buildStatCard(
//                   'Rata-rata',
//                   'Rp ${ExpenseService.getAverageDaily(filteredExpenses).toStringAsFixed(0)}',
//                 ),
//               ],
//             ),
//           ),

//           // Expense list
//           Expanded(
//             child:
//                 filteredExpenses.isEmpty
//                     ? const Center(
//                       child: Text('Tidak ada pengeluaran ditemukan'),
//                     )
//                     : ListView.builder(
//                       itemCount: filteredExpenses.length,
//                       itemBuilder: (context, index) {
//                         final expense = filteredExpenses[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 4,
//                           ),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: _getCategoryColor(
//                                 expense.category,
//                               ),
//                               child: Icon(
//                                 _getCategoryIcon(expense.category),
//                                 color: Colors.white,
//                               ),
//                             ),
//                             title: Text(expense.title),
//                             subtitle: Text(
//                               '${expense.category} • ${expense.formattedDate}',
//                             ),
//                             trailing: Text(
//                               expense.formattedAmount,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.red[600],
//                               ),
//                             ),
//                             onTap: () => _showExpenseDetails(context, expense),
//                           ),
//                         );
//                       },
//                     ),
//           ),
//           FloatingActionButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const ExpenseFormScreen(),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//         backgroundColor: Colors.pinkAccent,
//       ),
//     );
//   }

//   Future<void> _exportToCSV(
//     BuildContext context,
//     List<Expense> expenses,
//   ) async {
//     final csv = StringBuffer();
//     csv.writeln('Judul,Nominal,Kategori,Tanggal,Deskripsi');
//     for (var e in expenses) {
//       csv.writeln(
//         '"${e.title}",${e.amount},"${e.category}","${e.formattedDate}","${e.description}"',
//       );
//     }

//     final directory = await getTemporaryDirectory();
//     final path = '${directory.path}/pengeluaran.csv';
//     final file = File(path);
//     await file.writeAsString(csv.toString());

//     await Share.shareXFiles([XFile(path)], text: 'Export Data Pengeluaran');
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('Data diekspor ke CSV')));
//   }

//   // Detail pengeluaran + tombol hapus & edit
//   void _showExpenseDetails(BuildContext context, Expense expense) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: Text(expense.title),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Jumlah: ${expense.formattedAmount}'),
//                 const SizedBox(height: 8),
//                 Text('Kategori: ${expense.category}'),
//                 const SizedBox(height: 8),
//                 Text('Tanggal: ${expense.formattedDate}'),
//                 const SizedBox(height: 8),
//                 Text('Deskripsi: ${expense.description}'),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Tutup'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _showEditExpenseDialog(expense);
//                 },
//                 child: const Text('Edit', style: TextStyle(color: Colors.blue)),
//               ),
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     ExpenseService.expenses.remove(expense);
//                     _filterExpenses();
//                   });
//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Pengeluaran dihapus')),
//                   );
//                 },
//                 child: const Text('Hapus', style: TextStyle(color: Colors.red)),
//               ),
//             ],
//           ),
//     );
//   }

//   // Dialog edit pengeluaran
//   void _showEditExpenseDialog(Expense expense) {
//     final titleController = TextEditingController(text: expense.title);
//     final amountController = TextEditingController(
//       text: expense.amount.toString(),
//     );
//     final descController = TextEditingController(text: expense.description);
//     String selectedCategory = expense.category;

//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Edit Pengeluaran'),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextField(
//                     controller: titleController,
//                     decoration: const InputDecoration(labelText: 'Judul'),
//                   ),
//                   TextField(
//                     controller: amountController,
//                     decoration: const InputDecoration(labelText: 'Jumlah'),
//                     keyboardType: TextInputType.number,
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: selectedCategory,
//                     items:
//                         [
//                               'Makanan',
//                               'Transportasi',
//                               'Utilitas',
//                               'Hiburan',
//                               'Pendidikan',
//                             ]
//                             .map(
//                               (cat) => DropdownMenuItem(
//                                 value: cat,
//                                 child: Text(cat),
//                               ),
//                             )
//                             .toList(),
//                     onChanged: (value) {
//                       selectedCategory = value!;
//                     },
//                     decoration: const InputDecoration(labelText: 'Kategori'),
//                   ),
//                   TextField(
//                     controller: descController,
//                     decoration: const InputDecoration(labelText: 'Deskripsi'),
//                   ),
//                 ],
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Batal'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (titleController.text.isNotEmpty &&
//                       amountController.text.isNotEmpty) {
//                     final editedExpense = Expense(
//                       id: expense.id,
//                       title: titleController.text,
//                       amount: double.tryParse(amountController.text) ?? 0,
//                       category: selectedCategory,
//                       date: expense.date,
//                       description: descController.text,
//                     );
//                     setState(() {
//                       int idx = ExpenseService.expenses.indexOf(expense);
//                       if (idx != -1) {
//                         ExpenseService.expenses[idx] = editedExpense;
//                         _filterExpenses();
//                       }
//                     });
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Pengeluaran berhasil diedit')),
//                     );
//                   }
//                 },
//                 child: const Text('Simpan'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _filterExpenses() {
//     setState(() {
//       filteredExpenses =
//           expenses.where((expense) {
//             bool matchesSearch =
//                 searchController.text.isEmpty ||
//                 expense.title.toLowerCase().contains(
//                   searchController.text.toLowerCase(),
//                 ) ||
//                 expense.description.toLowerCase().contains(
//                   searchController.text.toLowerCase(),
//                 );

//             bool matchesCategory =
//                 selectedCategory == 'Semua' ||
//                 expense.category == selectedCategory;

//             return matchesSearch && matchesCategory;
//           }).toList();
//     });
//   }

//   Widget _buildStatCard(String label, String value) {
//     return Column(
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   // Total pengeluaran (semua item)
//   double _getTotal(List<Expense> expenses) {
//     // Gunakan getTotalByCategory lalu jumlahkan semua kategori
//     final totals = ExpenseService.getTotalByCategory(expenses);
//     return totals.values.fold(0, (sum, value) => sum + value);
//   }

//   // Warna kategori
//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'makanan':
//         return Colors.orange;
//       case 'transportasi':
//         return Colors.green;
//       case 'utilitas':
//         return Colors.purple;
//       case 'hiburan':
//         return Colors.pink;
//       case 'pendidikan':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   // Icon kategori
//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'makanan':
//         return Icons.restaurant;
//       case 'transportasi':
//         return Icons.directions_car;
//       case 'utilitas':
//         return Icons.home;
//       case 'hiburan':
//         return Icons.movie;
//       case 'pendidikan':
//         return Icons.school;
//       default:
//         return Icons.attach_money;
//     }
//   }
// }
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';
import 'expense_form.dart';
import 'dart:io' show File; // tetap untuk mobile
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'dart:html' as html; // untuk web

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
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'csv') {
                if (kIsWeb) {
                  _exportToCSVWeb(filteredExpenses);
                } else {
                  _exportToCSV(context, filteredExpenses);
                }
              } else if (value == 'pdf') {
                if (kIsWeb) {
                  _exportToPDFWeb(filteredExpenses);
                } else {
                  _exportToPDF(context, filteredExpenses);
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'csv',
                child: Text('Export ke CSV'),
              ),
              const PopupMenuItem(
                value: 'pdf',
                child: Text('Export ke PDF'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🏷️ Category filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['Semua', ...ExpenseService.categoryNames.values]
                  .map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(category),
                    selected: selectedCategory == category,
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

          // 📊 Statistik singkat
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  'Total',
                  'Rp ${_getTotal(filteredExpenses).toStringAsFixed(0)}',
                ),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                  'Rata-rata',
                  'Rp ${ExpenseService.getAverageDaily(filteredExpenses).toStringAsFixed(0)}',
                ),
              ],
            ),
          ),

          // 📋 Daftar pengeluaran
          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(
                    child: Text('Tidak ada pengeluaran ditemukan'),
                  )
                : ListView.builder(
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
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
                          title: Text(expense.title),
                          subtitle: Text(
                            '${expense.category} • ${expense.formattedDate}',
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
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseFormScreen()),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }

  // Filter
  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        bool matchesSearch = searchController.text.isEmpty ||
            expense.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            expense.description
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
        bool matchesCategory =
            selectedCategory == 'Semua' || expense.category == selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  // Statistik
  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  double _getTotal(List<Expense> expenses) {
    final totals = ExpenseService.getTotalByCategory(expenses);
    return totals.values.fold(0, (sum, value) => sum + value);
  }

  // UI Helper
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

  // Export ke CSV (Mobile)
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
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil export ke CSV')));
  }

  // Export ke CSV (Web)
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

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'pengeluaran.csv')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  // Export ke PDF (Mobile)
  Future<void> _exportToPDF(
      BuildContext context, List<Expense> expenses) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Center(
            child: pw.Text('Laporan Pengeluaran',
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold))),
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
          border: pw.TableBorder.all(),
        )
      ];
    }));

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/laporan_pengeluaran.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles([XFile(path)], text: 'Export Data Pengeluaran PDF');
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Berhasil export ke PDF')));
  }

  // Export ke PDF (Web)
  Future<void> _exportToPDFWeb(List<Expense> expenses) async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Center(
            child: pw.Text('Laporan Pengeluaran',
                style: pw.TextStyle(
                    fontSize: 20, fontWeight: pw.FontWeight.bold))),
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
          border: pw.TableBorder.all(),
        )
      ];
    }));

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'laporan_pengeluaran.pdf')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  // Detail
  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.title),
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
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}       
