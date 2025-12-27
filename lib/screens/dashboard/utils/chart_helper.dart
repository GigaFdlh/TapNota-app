import 'package:fl_chart/fl_chart.dart';
import '../../../models/models.dart';

class ChartHelper {
  static List<FlSpot> getChartData(
    List<Transaction> transactions,
    String period,
  ) {
    final now = DateTime.now();
    List<FlSpot> spots = [];

    if (period == 'Minggu Ini') {
      spots = _getWeeklyData(transactions, now);
    } else if (period == 'Bulan Ini') {
      spots = _getMonthlyData(transactions, now);
    } else {
      spots = _getDailyData(transactions, now);
    }

    return spots;
  }

  static List<FlSpot> _getWeeklyData(List<Transaction> transactions, DateTime now) {
    Map<int, double> dataMap = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0};
    DateTime monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days:  now.weekday - 1));
    DateTime nextMonday = monday. add(const Duration(days: 7));

    for (var trx in transactions) {
      if (trx.date. isAfter(monday. subtract(const Duration(seconds: 1))) &&
          trx.date.isBefore(nextMonday)) {
        dataMap[trx. date.weekday] = (dataMap[trx.date.weekday] ?? 0) + trx.totalAmount;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 1; i <= 7; i++) {
      spots.add(FlSpot((i - 1).toDouble(), dataMap[i]! ));
    }
    return spots;
  }

  static List<FlSpot> _getMonthlyData(List<Transaction> transactions, DateTime now) {
    int days = DateTime(now.year, now.month + 1, 0).day;
    Map<int, double> dataMap = {for (var i = 1; i <= days; i++) i: 0.0};

    for (var trx in transactions) {
      if (trx.date.month == now.month && trx. date. year == now.year) {
        dataMap[trx.date. day] = (dataMap[trx.date.day] ?? 0) + trx.totalAmount;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < (days / 5).ceil(); i++) {
      int day = (i * 5) + 1;
      if (day <= days) spots.add(FlSpot(i.toDouble(), dataMap[day]!));
    }
    return spots;
  }

  static List<FlSpot> _getDailyData(List<Transaction> transactions, DateTime now) {
    Map<int, double> dataMap = {for (var i = 0; i < 24; i++) i: 0.0};
    for (var trx in transactions) {
      if (trx.date.day == now.day &&
          trx.date.month == now.month &&
          trx.date. year == now.year) {
        dataMap[trx.date.hour] = (dataMap[trx.date.hour] ??  0) + trx.totalAmount;
      }
    }

    List<FlSpot> spots = [];
    for (int i = 0; i < 6; i++) {
      int hour = i * 4;
      spots.add(FlSpot(i.toDouble(), dataMap[hour]!));
    }
    return spots;
  }

  static String getBottomTitle(double value, String period) {
    int valInt = value.toInt();

    if (period == 'Minggu Ini') {
      const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
      return (valInt >= 0 && valInt < 7) ? days[valInt] : '';
    } else if (period == 'Bulan Ini') {
      return '${(valInt * 5) + 1}';
    } else {
      return '${valInt * 4}: 00';
    }
  }

  static double getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    double max = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    return max == 0 ? 100 :  max * 1.2;
  }
}