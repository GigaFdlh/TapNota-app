import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/history_theme.dart';

class EmptyState extends StatelessWidget {
  final String searchQuery;

  const EmptyState({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Column(
        mainAxisAlignment:  MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [
                  HistoryTheme.gradientTeal. withAlpha(26),
                  HistoryTheme.gradientIndigo.withAlpha(26),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  HistoryTheme.primaryGradient.createShader(bounds),
              child: const Icon(
                Icons.history_rounded,
                size: 60,
                color: Colors. white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Belum Ada Transaksi',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: HistoryTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty
                ?  'Tidak ada hasil untuk pencarian Anda'
                : 'Transaksi Anda akan muncul di sini',
            style: GoogleFonts. inter(
              fontSize: 14,
              color: HistoryTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}