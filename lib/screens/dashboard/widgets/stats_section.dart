import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../utils/dashboard_theme.dart';
import '../../../providers/transaction_provider.dart';
import '../../../utils.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final omzetHariIni = provider.totalOmzetHariIni;
        final totalTransaksi = provider.totalTransaksiHariIni;
        final topProducts = provider.topProducts;
        final totalItemTerjual = topProducts.fold<int>(
          0,
          (sum, item) => sum + (item['sold'] as int),
        );

        return Column(
          children:  [
            MainRevenueCard(omzetHariIni: omzetHariIni),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: MiniStatCard(
                    title: 'Transaksi',
                    value:  '$totalTransaksi',
                    icon: Icons.receipt_long_rounded,
                    gradient: DashboardTheme.transactionGradient,
                    delay: 100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: MiniStatCard(
                    title:  'Item Terjual',
                    value: '$totalItemTerjual',
                    icon: Icons. shopping_bag_rounded,
                    gradient: DashboardTheme.productGradient,
                    delay: 200,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class MainRevenueCard extends StatelessWidget {
  final double omzetHariIni;

  const MainRevenueCard({super.key, required this.omzetHariIni});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * value),
          child:  Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: DashboardTheme.primaryGradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: DashboardTheme.gradientTeal.withAlpha(77),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: DashboardTheme.gradientIndigo.withAlpha(51),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white. withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        size: 14,
                        color: Colors. white,
                      ),
                      const SizedBox(width:  4),
                      Text(
                        'Hari Ini',
                        style:  GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height:  20),
            Text(
              'Total Penjualan',
              style:  GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white. withAlpha(230),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height:  8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end:  omzetHariIni),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Text(
                  formatRupiah(value.toInt()),
                  style: GoogleFonts.poppins(
                    fontSize:  32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    size: 14,
                    color: Colors. white. withAlpha(230),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tarik ke bawah untuk refresh',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors. white.withAlpha(230),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final LinearGradient gradient;
  final int delay;

  const MiniStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animValue)),
          child:  Opacity(opacity: animValue, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors. white,
          borderRadius: BorderRadius. circular(20),
          border: Border.all(color: DashboardTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius:  BorderRadius.circular(12),
              ),
              child:  Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: DashboardTheme.textSecondary,
                fontWeight:  FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DashboardTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}