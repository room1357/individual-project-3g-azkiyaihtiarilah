import 'package:flutter/material.dart';
import '../utils/expense_manager.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = ExpenseManager.expenses;
    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final perCategory = <String, double>{};
    for (var cat in ExpenseManager.categories) {
      perCategory[cat] = expenses
          .where((e) => e.category == cat)
          .fold<double>(0, (sum, e) => sum + e.amount);
    }
    final average = expenses.isEmpty ? 0 : total / expenses.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.indigo,
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
                trailing: Text('Rp ${total.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Card(
              color: Colors.indigo[50],
              child: ListTile(
                title: const Text('Rata-rata Pengeluaran'),
                trailing: Text('Rp ${average.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengeluaran per Kategori',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: perCategory.length,
                itemBuilder: (context, index) {
                  final cat = perCategory.keys.elementAt(index);
                  final amount = perCategory[cat]!;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(cat[0]),
                      backgroundColor: Colors.indigo[100],
                    ),
                    title: Text(cat),
                    trailing: Text('Rp ${amount.toStringAsFixed(0)}'),
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