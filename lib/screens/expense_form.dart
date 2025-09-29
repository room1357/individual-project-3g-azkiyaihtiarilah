import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  List<Expense> expenses = ExpenseManager.expenses;

  // Controller untuk form
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedCategory = 'Makanan';

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pengeluaran'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['Makanan', 'Transportasi', 'Utilitas', 'Hiburan', 'Pendidikan']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                final newExpense = Expense(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  amount: double.tryParse(amountController.text) ?? 0,
                  category: selectedCategory,
                  date: DateTime.now(),
                  description: descController.text,
                );
                setState(() {
                  ExpenseManager.expenses.add(newExpense); // hanya satu list!
                  // Jangan tambahkan ke expenses.add(newExpense);
                });
                titleController.clear();
                amountController.clear();
                descController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengeluaran'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        itemCount: ExpenseManager.expenses.length,
        itemBuilder: (context, index) {
          final expense = ExpenseManager.expenses[index];
          return ListTile(
            title: Text(expense.title),
            subtitle: Text('${expense.category} - ${expense.date.toLocal()}'.split(' ')[0]),
            trailing: Text('Rp${expense.amount.toStringAsFixed(0)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddExpenseDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}