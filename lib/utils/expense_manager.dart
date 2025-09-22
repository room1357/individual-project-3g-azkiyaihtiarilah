import '../models/expense.dart';

class Looping {
  //hanya digunakan latihan 
  static List<Expense> expenses = [
    Expense(
      id: '1',
      title: 'Sarapan Nasi Uduk',
      amount: 15000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 7, 30),
      description: 'Sarapan nasi uduk + teh hangat',
    ),
    Expense(
      id: '2',
      title: 'Ngopi Pagi',
      amount: 20000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 9, 0),
      description: 'Kopi latte di kedai dekat kampus',
    ),
    Expense(
      id: '3',
      title: 'Makan Siang Nasi Padang',
      amount: 30000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 12, 30),
      description: 'Nasi padang lauk ayam goreng + sayur',
    ),
    Expense(
      id: '4',
      title: 'Cemilan Sore',
      amount: 10000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 16, 0),
      description: 'Gorengan dan es teh',
    ),
    Expense(
      id: '5',
      title: 'Makan Malam Ayam Geprek',
      amount: 25000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 19, 0),
      description: 'Ayam geprek level pedas + nasi',
    ),
    Expense(
      id: '6',
      title: 'Ngemil Tengah Malam',
      amount: 12000,
      category: 'Makanan',
      date: DateTime(2024, 9, 15, 23, 30),
      description: 'Indomie goreng + teh botol',
    ),
  ];

  // Menghitung total per kategori (for loop)
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (int i = 0; i < expenses.length; i++) {
      var expense = expenses[i];
      result[expense.category] =
          (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // Total semua pengeluaran
  static double getTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Cari pengeluaran terbesar
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }
}


class ExpenseManager {
  static List<Expense> expenses = [/* data expenses */];

  // 1. Mendapatkan total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // 2. Mendapatkan pengeluaran tertinggi
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  // 3. Mendapatkan pengeluaran bulan tertentu
  static List<Expense> getExpensesByMonth(List<Expense> expenses, int month, int year) {
    return expenses.where((expense) => 
      expense.date.month == month && expense.date.year == year
    ).toList();
  }

  // 4. Mencari pengeluaran berdasarkan kata kunci
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    String lowerKeyword = keyword.toLowerCase();
    return expenses.where((expense) =>
      expense.title.toLowerCase().contains(lowerKeyword) ||
      expense.description.toLowerCase().contains(lowerKeyword) ||
      expense.category.toLowerCase().contains(lowerKeyword)
    ).toList();
  }

  // 5. Mendapatkan rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    
    // Hitung jumlah hari unik
    Set<String> uniqueDays = expenses.map((expense) => 
      '${expense.date.year}-${expense.date.month}-${expense.date.day}'
    ).toSet();
    
    return total / uniqueDays.length;
  }

  // 6. Mendapatkan total semua pengeluaran
  static double getTotal(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}