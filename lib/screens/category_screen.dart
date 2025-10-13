import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/expense_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});
  

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  List<Category> categories = [
    Category(id: '1', name: 'Makanan', description: 'Pengeluaran makanan'),
    Category(id: '2', name: 'Transportasi', description: 'Biaya transportasi'),
    Category(id: '3', name: 'Utilitas', description: 'Tagihan utilitas'),
    Category(id: '4', name: 'Hiburan', description: 'Kegiatan hiburan'),
    Category(id: '5', name: 'Pendidikan', description: 'Biaya pendidikan'),
  ];

  void _addCategory() {
    final name = nameController.text.trim();
    final desc = descController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama kategori tidak boleh kosong')),
      );
      return;
    }
    if (categories.any((cat) => cat.name.toLowerCase() == name.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori sudah ada')),
      );
      return;
    }
    setState(() {
      categories.add(Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: desc,
      ));
    });
    nameController.clear();
    descController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kategori berhasil ditambahkan')),
    );
  }

  void _deleteCategory(Category category) {
    setState(() {
      categories.remove(category);
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
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kategori',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: ListTile(
                    title: Text(category.name),
                    subtitle: Text(category.description),
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