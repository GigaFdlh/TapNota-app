import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../utils/dashboard_theme.dart';
import '../../../providers/transaction_provider.dart';
import '../../../models/models.dart';
import '../../../utils.dart';
import 'empty_state.dart';

class RecentTransactions extends StatelessWidget {
  final Function(int) onNavigate;

  const RecentTransactions({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaksi Terbaru',
                  style: GoogleFonts. poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed:  () {
                    HapticFeedback.lightImpact();
                    onNavigate(3);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        DashboardTheme. primaryGradient.createShader(bounds),
                    child:  Text(
                      'Lihat Semua',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (transactions.isEmpty)
              EmptyTransactionsState(onActionTap: () => onNavigate(1))
            else
              Column(
                children: List.generate(
                  transactions. length,
                  (index) => TransactionItem(
                    transaction: transactions[index],
                    index: index,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child:  Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors. white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DashboardTheme.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color:  Colors.black.withAlpha(8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: DashboardTheme.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child:  const Icon(
                Icons.receipt_long_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width:  14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.customerName,
                    style: GoogleFonts.poppins(
                      fontSize:  15,
                      fontWeight: FontWeight.w600,
                      color: DashboardTheme. textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height:  4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12,
                        color: DashboardTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('HH:mm').format(transaction. date),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: DashboardTheme.textSecondary,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: DashboardTheme.textSecondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        '${transaction.items.length} item',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: DashboardTheme. textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatRupiah(transaction. totalAmount. toInt()),
                  style:  GoogleFonts.poppins(
                    fontSize:  15,
                    fontWeight: FontWeight.bold,
                    color: DashboardTheme.accentGreen,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: DashboardTheme.accentGreen. withAlpha(26),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Lunas',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: DashboardTheme.accentGreen,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}