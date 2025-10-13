import '../models/expense.dart';

class ExpenseService {
  static List<Expense> expenses = [/* data expenses */];
  static List<String> categories = [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  static Map<String, String> categoryNames = {
    'food': 'Makanan',
    'transportation': 'Transportasi',
    'utilities': 'Utilitas',
    'entertainment': 'Hiburan',
    'education': 'Pendidikan',
  };

  // Tambahkan fungsi untuk menambah kategori baru
  static void addCategory(String name) {
    if (!categories.contains(name)) {
      categories.add(name);
    }
  }
  
  // Hapus kategori
  static void removeCategory(String name) {
    categories.remove(name);
  }

  // 1. Mendapatkan total pengeluaran per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    final totals = <String, double>{};
    for (var cat in categories) {
      totals[cat] = expenses
          .where((e) => e.category == cat)
          .fold(0, (sum, e) => sum + e.amount);
    }
    return totals;
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
}