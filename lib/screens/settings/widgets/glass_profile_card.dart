import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/settings_provider.dart';
import '../utils/settings_theme.dart';

class GlassProfileCard extends StatelessWidget {
  final VoidCallback onEditTap;

  const GlassProfileCard({super.key, required this.onEditTap});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter:  ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Colors.white. withAlpha(77),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: SettingsTheme. deepIndigo.withAlpha(51),
                        blurRadius:  20,
                        offset:  const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ProfileHeader(
                        storeName: settings.storeName,
                        onEditTap: onEditTap,
                      ),
                      const SizedBox(height: 16),
                      _ProfileInfo(
                        storeAddress: settings.storeAddress,
                        storePhone: settings. storePhone,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String storeName;
  final VoidCallback onEditTap;

  const _ProfileHeader({
    required this. storeName,
    required this. onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: SettingsTheme.buttonGradient,
            shape:  BoxShape.circle,
            border: Border.all(
              color: Colors.white.withAlpha(128),
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: SettingsTheme.tealFresh.withAlpha(102),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.store_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width:  16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeName,
                style: GoogleFonts.poppins(
                  fontSize:  20,
                  fontWeight: FontWeight.bold,
                  color: Colors. white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height:  4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration:  BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(8),
                  border: Border. all(
                    color: Colors.white.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons. verified_rounded,
                      size: 14,
                      color: Colors. white,
                    ),
                    const SizedBox(width:  4),
                    Text(
                      "TapNota User",
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _GlassIconButton(
          icon: Icons. edit_rounded,
          onTap: onEditTap,
        ),
      ],
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String storeAddress;
  final String storePhone;

  const _ProfileInfo({
    required this.storeAddress,
    required this.storePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(38),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha(51),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.location_on_rounded, text: storeAddress),
          const SizedBox(height:  12),
          _InfoRow(icon: Icons.phone_rounded, text: storePhone),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white. withAlpha(204), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withAlpha(230),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter:  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(38),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withAlpha(64),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                HapticFeedback.lightImpact();
                onTap();
              },
              child:  Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}