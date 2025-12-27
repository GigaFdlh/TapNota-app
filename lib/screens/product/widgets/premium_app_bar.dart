import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../utils/product_theme.dart';

class PremiumAppBar extends StatelessWidget {
  const PremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor:  Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: ProductTheme.mainGradient,
          ),
          child: BackdropFilter(
            filter:  ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: SafeArea(
              bottom: false,
              child:  Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Produk',
                      style: GoogleFonts.poppins(
                        fontSize:  32,
                        fontWeight: FontWeight.bold,
                        color: Colors. white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<ProductProvider>(
                      builder: (context, provider, child) {
                        return Text(
                          '${provider.products.length} item tersedia',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors. white. withAlpha(217),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}