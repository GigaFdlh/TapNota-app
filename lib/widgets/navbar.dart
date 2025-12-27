// lib/widgets/navbar.dart

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ============================================
// 🎨 PREMIUM NAVBAR THEME - TEAL TO INDIGO
// ============================================
class NavbarTheme {
  // Primary Gradient Colors (Teal → Indigo)
  static const gradientTeal = Color(0xFF43C197);
  static const gradientIndigo = Color(0xFF1C1554);

  // UI Colors
  static const surfaceColor = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1C1554);
  static const textSecondary = Color(0xFF8E8E93);
  static const iconInactive = Color(0xFFAEAEB2);

  // Primary Gradient
  static const primaryGradient = LinearGradient(
    colors: [gradientTeal, gradientIndigo],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Gradient for subtle effects
  static const lightGradient = LinearGradient(
    colors: [
      Color(0xFF43C197),
      Color(0xFF2D8B7A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft Gradient for glass effect
  static LinearGradient get softGradient => LinearGradient(
    colors: [
      gradientTeal. withValues(alpha: 0.1),
      gradientIndigo.withValues(alpha: 0.05),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================
// 🚀 PREMIUM IOS-STYLE NAVBAR
// ============================================
class Navbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  // Nav Items
  final List<IconData> _icons = const [
    Icons.dashboard_outlined,
    Icons.point_of_sale_outlined,
    Icons.inventory_2_outlined,
    Icons.history_outlined,
  ];

  final List<IconData> _activeIcons = const [
    Icons.dashboard_rounded,
    Icons. point_of_sale_rounded,
    Icons.inventory_2_rounded,
    Icons.history_rounded,
  ];

  final List<String> _labels = const [
    'Home',
    'Kasir',
    'Produk',
    'Riwayat',
  ];

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds:  500),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves. easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve:  Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(Navbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController. dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (widget.selectedIndex == index) return;
    HapticFeedback.mediumImpact();
    widget.onTabChange(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY:  20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration:  BoxDecoration(
              // Glass effect with subtle gradient
              color: Colors.white. withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.6),
                width:  1.5,
              ),
              boxShadow:  [
                // Primary shadow with teal tint
                BoxShadow(
                  color: NavbarTheme.gradientTeal.withValues(alpha: 0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                // Secondary shadow for depth
                BoxShadow(
                  color: NavbarTheme.gradientIndigo.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
                // Soft ambient shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  List.generate(
                _icons.length,
                (index) => _buildNavItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final isSelected = widget.selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated Icon Container
              AnimatedBuilder(
                animation: _bounceAnimation,
                builder:  (context, child) {
                  final scale = isSelected && _bounceController. isAnimating
                      ? _bounceAnimation.value
                      : 1.0;

                  return Transform. scale(
                    scale: scale,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves. easeOutCubic,
                      width: isSelected ?  54 : 42,
                      height: isSelected ? 34 : 30,
                      decoration: BoxDecoration(
                        gradient:  isSelected ?  NavbarTheme. primaryGradient :  null,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ?  [
                                BoxShadow(
                                  color:  NavbarTheme. gradientTeal. withValues(alpha:  0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                                BoxShadow(
                                  color: NavbarTheme.gradientIndigo.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child:  FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child:  Icon(
                            isSelected ? _activeIcons[index] : _icons[index],
                            key: ValueKey('icon_${index}_$isSelected'),
                            size: isSelected ? 22 : 20,
                            color:  isSelected
                                ?  Colors.white
                                : NavbarTheme.iconInactive,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height:  5),

              // Label with animated style
              AnimatedDefaultTextStyle(
                duration:  const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                style: GoogleFonts.inter(
                  fontSize: isSelected ? 11 : 10,
                  fontWeight:  isSelected ? FontWeight.w600 :  FontWeight.w500,
                  color: isSelected
                      ? NavbarTheme.textPrimary
                      :  NavbarTheme. textSecondary,
                  letterSpacing: 0.2,
                ),
                child: Text(
                  _labels[index],
                  maxLines:  1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}