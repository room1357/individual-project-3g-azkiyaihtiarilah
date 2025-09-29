import 'package:flutter/material.dart';
import '../utils/expense_manager.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController categoryController = TextEditingController();

  void _addCategory() {
    final newCategory = categoryController.text.trim();
    if (newCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }
    if (ExpenseManager.categories.contains(newCategory)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori sudah ada')),
      );
      return;
    }
    setState(() {
      ExpenseManager.categories.add(newCategory);
    });
    categoryController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori berhasil ditambahkan')),
    );
  }

  void _deleteCategory(String category) {
    setState(() {
      ExpenseManager.categories.remove(category);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Pengeluaran'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Tambah Kategori Baru',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: ExpenseManager.categories.length,
              itemBuilder: (context, index) {
                final category = ExpenseManager.categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteCategory(category),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}