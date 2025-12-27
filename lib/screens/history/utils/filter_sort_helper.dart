import '../../../models/models.dart';
import 'history_helpers.dart';

enum DateFilter { today, thisWeek, thisMonth, all }
enum SortOption { latest, oldest, highestTotal, lowestTotal }

class FilterSortHelper {
  static List<Transaction> filterAndSort({
    required List<Transaction> transactions,
    required DateFilter dateFilter,
    required SortOption sortOption,
    required String searchQuery,
  }) {
    // Filter by search
    var filtered = transactions.where((trx) {
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchId = trx.id.toLowerCase().contains(query);
        final matchCustomer = trx.customerName.toLowerCase().contains(query);
        final matchTotal = HistoryHelpers.toInt(trx.totalAmount)
            .toString()
            .contains(query);
        if (! matchId && !matchCustomer && !matchTotal) return false;
      }

      // Filter by date
      final now = DateTime.now();
      switch (dateFilter) {
        case DateFilter.today:
          return trx.date.year == now.year &&
              trx.date.month == now. month &&
              trx.date.day == now.day;
        case DateFilter.thisWeek:
          final weekAgo = now.subtract(const Duration(days: 7));
          return trx.date.isAfter(weekAgo);
        case DateFilter.thisMonth:
          return trx.date.year == now.year && trx.date.month == now.month;
        case DateFilter.all:
          return true;
      }
    }).toList();

    // Sort
    switch (sortOption) {
      case SortOption.latest:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case SortOption.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.highestTotal:
        filtered.sort((a, b) => HistoryHelpers.toDouble(b.totalAmount)
            .compareTo(HistoryHelpers.toDouble(a.totalAmount)));
        break;
      case SortOption.lowestTotal:
        filtered.sort((a, b) => HistoryHelpers.toDouble(a.totalAmount)
            .compareTo(HistoryHelpers.toDouble(b.totalAmount)));
        break;
    }

    return filtered;
  }
}