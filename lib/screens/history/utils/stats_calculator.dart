import '../../../models/models.dart';
import 'history_helpers.dart';

class StatsCalculator {
  static Map<String, dynamic> getTodayStats(List<Transaction> transactions) {
    final now = DateTime.now();
    final todayTrx = transactions
        .where((trx) =>
            trx.date.year == now.year &&
            trx.date.month == now. month &&
            trx.date.day == now.day)
        .toList();

    final totalRevenue = todayTrx. fold<double>(
      0.0,
      (sum, trx) => sum + HistoryHelpers.toDouble(trx.totalAmount),
    );

    final totalItems = todayTrx.fold<int>(
      0,
      (sum, trx) => sum + trx.items.length,
    );

    return {
      'count':  todayTrx.length,
      'revenue': totalRevenue,
      'items': totalItems,
    };
  }
}