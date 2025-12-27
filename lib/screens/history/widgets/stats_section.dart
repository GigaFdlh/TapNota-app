import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/history_theme.dart';

class StatsSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final String Function(dynamic) formatCompact;

  const StatsSection({
    super.key,
    required this.stats,
    required this.formatCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: HistoryTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HistoryTheme.gradientTeal.withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: HistoryTheme.gradientIndigo.withAlpha(51),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:  const Icon(
                  Icons. calendar_today_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width:  10),
              Text(
                'Ringkasan Hari Ini',
                style:  GoogleFonts.poppins(
                  fontSize:  16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.receipt_long_rounded,
                  label: 'Transaksi',
                  value: '${stats['count']}',
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon: Icons.account_balance_wallet_rounded,
                  label:  'Omzet',
                  value: formatCompact(stats['revenue']),
                ),
              ),
              Expanded(
                child: _StatItem(
                  icon:  Icons.shopping_bag_rounded,
                  label:  'Item',
                  value: '${stats['items']}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween:  Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, animValue, child) {
            return Opacity(
              opacity: animValue,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors. white,
                  fontWeight:  FontWeight.bold,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style:  GoogleFonts.inter(
            fontSize: 12,
            color: Colors.white.withAlpha(204),
          ),
        ),
      ],
    );
  }
}