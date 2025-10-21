import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';
import 'home_screen.dart'; // ✅ ganti sesuai nama baru

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

  void _refreshData() {
  final data = ExpenseService.expenses;
  final newTotal = data.fold<double>(0, (sum, e) => sum + e.amount);

  // Kumpulkan semua kategori dari data yang ada
  final newPerCategory = <String, double>{};
  for (var e in data) {
    newPerCategory[e.category] = (newPerCategory[e.category] ?? 0) + e.amount;
  }

  setState(() {
    expenses = data;
    total = newTotal;
    average = data.isEmpty ? 0 : newTotal / data.length;
    perCategory = newPerCategory;
  });
}


  // Warna per kategori (tetap berwarna-warni)
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'Statistik Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
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
            // === Ringkasan Total & Rata-rata ===
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Total Pengeluaran',
                    value: 'Rp ${total.toStringAsFixed(0)}',
                    icon: Icons.wallet,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'Rata-rata',
                    value: 'Rp ${average.toStringAsFixed(0)}',
                    icon: Icons.analytics,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              'Distribusi Pengeluaran per Kategori',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),

            // === Pie Chart ===
            Expanded(
              flex: 0,
              child:
                  validData.isEmpty
                      ? const Center(child: Text('Belum ada data pengeluaran'))
                      : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 300, // batas maksimum lebar chart
                                maxHeight: 250, // batas maksimum tinggi chart
                                minWidth: 150,
                                minHeight: 150,
                              ),
                              child: AspectRatio(
                                aspectRatio:
                                    1, // supaya tetap lingkaran sempurna
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 4,
                                    centerSpaceRadius: 40,
                                    borderData: FlBorderData(show: false),
                                    sections:
                                        validData.map((entry) {
                                          final percentage =
                                              total == 0
                                                  ? 0
                                                  : (entry.value / total * 100);
                                          final color =
                                              categoryColors[entry.key] ??
                                              Colors.grey.shade400;

                                          return PieChartSectionData(
                                            color: color,
                                            value: entry.value,
                                            title:
                                                '${percentage.toStringAsFixed(1)}%',
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
                            ),
                          ),
                        ),
                      ),
            ),

            const SizedBox(height: 12),
            const Text(
              'Rincian per Kategori',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),

            // === List Kategori ===
            Expanded(
              flex: 3,
              child:
                  validData.isEmpty
                      ? const Center(
                        child: Text('Tidak ada data untuk ditampilkan'),
                      )
                      : ListView.builder(
                        itemCount: validData.length,
                        itemBuilder: (context, index) {
                          final cat = validData[index].key;
                          final amount = validData[index].value;
                          final color =
                              categoryColors[cat] ?? Colors.grey.shade400;
                          final percentage =
                              total == 0 ? 0 : (amount / total * 100);

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 4,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color,
                                child: Text(
                                  cat[0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                cat,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${percentage.toStringAsFixed(1)}% dari total',
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                'Rp ${amount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),

            const SizedBox(height: 8),

            // === Tombol kembali ke HomeScreen ===
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Kembali ke Home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === Widget Kartu Ringkasan ===
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
