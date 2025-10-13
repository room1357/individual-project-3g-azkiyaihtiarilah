import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  List<Expense> expenses = [];
  double total = 0;
  double average = 0;
  Map<String, double> perCategory = {};

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData();
  }

  void _refreshData() {
    final data = ExpenseService.expenses;
    final newTotal = data.fold<double>(0, (sum, e) => sum + e.amount);
    final newPerCategory = <String, double>{};

    for (var cat in ExpenseService.categories) {
      newPerCategory[cat] = data
          .where((e) => e.category == cat)
          .fold<double>(0, (sum, e) => sum + e.amount);
    }

    setState(() {
      expenses = data;
      total = newTotal;
      average = data.isEmpty ? 0 : newTotal / data.length;
      perCategory = newPerCategory;
    });
  }

  // Warna per kategori untuk pie chart
  final Map<String, Color> categoryColors = {
    'Makanan': Colors.orange,
    'Transportasi': Colors.green,
    'Utilitas': Colors.purple,
    'Hiburan': Colors.pink,
    'Pendidikan': Colors.blue,
  };

  @override
  Widget build(BuildContext context) {
    final validData = perCategory.entries.where((e) => e.value > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Perbarui Data',
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.indigo[50],
              child: ListTile(
                title: const Text('Total Pengeluaran'),
                trailing: Text(
                  'Rp ${total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Card(
              color: Colors.indigo[50],
              child: ListTile(
                title: const Text('Rata-rata Pengeluaran'),
                trailing: Text(
                  'Rp ${average.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Distribusi Pengeluaran per Kategori',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // === Pie Chart ===
            Expanded(
              flex: 2,
              child: validData.isEmpty
                  ? const Center(child: Text('Belum ada data pengeluaran'))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        borderData: FlBorderData(show: false),
                        sections: validData.map((entry) {
                          final percentage =
                              total == 0 ? 0 : (entry.value / total * 100);
                          final color = categoryColors[entry.key] ??
                              Colors.grey.shade400;

                          return PieChartSectionData(
                            color: color,
                            value: entry.value,
                            title:
                                '${percentage.toStringAsFixed(1)}%', // tampilkan persentase
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            radius: 80,
                          );
                        }).toList(),
                      ),
                    ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Rincian per Kategori',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            // === List legenda per kategori ===
            Expanded(
              flex: 3,
              child: validData.isEmpty
                  ? const Center(child: Text('Tidak ada data untuk ditampilkan'))
                  : ListView.builder(
                      itemCount: validData.length,
                      itemBuilder: (context, index) {
                        final cat = validData[index].key;
                        final amount = validData[index].value;
                        final color =
                            categoryColors[cat] ?? Colors.grey.shade400;
                        final percentage =
                            total == 0 ? 0 : (amount / total * 100);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              cat[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(cat),
                          subtitle: Text(
                            '${percentage.toStringAsFixed(1)}% dari total',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            'Rp ${amount.toStringAsFixed(0)}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
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
