import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../utils/dashboard_theme.dart';
import '../utils/chart_helper.dart';
import '../../../providers/transaction_provider.dart';
import '../../../utils.dart';

class ChartSection extends StatefulWidget {
  const ChartSection({super.key});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  String _selectedPeriod = 'Minggu Ini';
  final List<String> _periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini'];

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statistik Penjualan',
                  style: GoogleFonts.poppins(
                    fontSize:  18,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.textPrimary,
                  ),
                ),
                _PeriodSelector(
                  selectedPeriod: _selectedPeriod,
                  periods: _periods,
                  onChanged: (value) {
                    setState(() => _selectedPeriod = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 220,
              padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: DashboardTheme.borderColor, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _ChartContent(
                transactions: provider.transactions,
                period: _selectedPeriod,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  final String selectedPeriod;
  final List<String> periods;
  final ValueChanged<String> onChanged;

  const _PeriodSelector({
    required this.selectedPeriod,
    required this.periods,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical:  4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DashboardTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: selectedPeriod,
        underline: const SizedBox(),
        icon: ShaderMask(
          shaderCallback: (bounds) =>
              DashboardTheme.primaryGradient.createShader(bounds),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: Colors.white,
          ),
        ),
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: DashboardTheme.textPrimary,
        ),
        items: periods.map((String value) {
          return DropdownMenuItem<String>(
            value:  value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          HapticFeedback.selectionClick();
          if (newValue != null) onChanged(newValue);
        },
      ),
    );
  }
}

class _ChartContent extends StatelessWidget {
  final List transactions;
  final String period;

  const _ChartContent({
    required this.transactions,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    final chartData = ChartHelper.getChartData(transactions as List<Transaction>, period);
    
    if (chartData.isEmpty) {
      return _EmptyChart();
    }

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) {
              return spots.map((spot) {
                return LineTooltipItem(
                  formatRupiah(spot.y.toInt()),
                  GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: ChartHelper.getMaxY(chartData) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: DashboardTheme.borderColor,
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles:  SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) => _buildBottomTitle(value, meta, period),
            ),
          ),
        ),
        borderData:  FlBorderData(show: false),
        minX: 0,
        maxX: chartData.length. toDouble() - 1,
        minY: 0,
        maxY: ChartHelper.getMaxY(chartData),
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: true,
            curveSmoothness: 0.3,
            gradient: DashboardTheme.primaryGradient,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors. white,
                  strokeWidth:  2,
                  strokeColor: DashboardTheme. gradientTeal,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  DashboardTheme.gradientTeal.withAlpha(77),
                  DashboardTheme.gradientIndigo.withAlpha(26),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta, String period) {
    final text = ChartHelper.getBottomTitle(value, period);
    
    return SideTitleWidget(
      axisSide: meta. axisSide,
      space: 8,
      child:  Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          color: DashboardTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _EmptyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                DashboardTheme.primaryGradient.createShader(bounds),
            child: const Icon(
              Icons.show_chart_rounded,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height:  12),
          Text(
            'Belum ada data',
            style: GoogleFonts.inter(
              color: DashboardTheme.textSecondary,
              fontSize:  14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}