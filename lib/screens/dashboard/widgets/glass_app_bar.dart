import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/dashboard_theme.dart';
import '../../settings/settings_screen.dart';

class GlassAppBar extends StatelessWidget {
  final bool isLocaleInitialized;

  const GlassAppBar({
    super.key,
    required this. isLocaleInitialized,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor:  Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient:  DashboardTheme.primaryGradient,
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SafeArea(
                bottom: false,
                child:  Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:  CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Selamat Datang!  👋',
                                  style:  GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight:  FontWeight.w500,
                                    color: Colors.white. withAlpha(230),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Dashboard',
                                  style: GoogleFonts.poppins(
                                    fontSize: 26,
                                    fontWeight:  FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _SettingsButton(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _DateChip(isLocaleInitialized: isLocaleInitialized),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position:  Tween<Offset>(
                  begin: const Offset(1, 0),
                  end:  Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve:  Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        );
      },
      child:  Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white. withAlpha(51),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withAlpha(77),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.settings_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  final bool isLocaleInitialized;

  const _DateChip({required this.isLocaleInitialized});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(77),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            size: 12,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            isLocaleInitialized
                ? DateFormat('EEE, dd MMM yyyy', 'id_ID').format(DateTime.now())
                : 'Memuat...',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}