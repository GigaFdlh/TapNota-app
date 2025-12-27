import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/dashboard_theme.dart';

class EmptyTransactionsState extends StatelessWidget {
  final VoidCallback onActionTap;

  const EmptyTransactionsState({super.key, required this. onActionTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: DashboardTheme.borderColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [
                  DashboardTheme.gradientTeal.withAlpha(26),
                  DashboardTheme.gradientIndigo.withAlpha(26),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  DashboardTheme.primaryGradient.createShader(bounds),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada transaksi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: DashboardTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mulai transaksi pertama Anda! ',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: DashboardTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}