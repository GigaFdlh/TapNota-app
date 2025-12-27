import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/navbar.dart';

import 'dashboard/dashboard_screen.dart';
import 'cashier/cashier_screen.dart';
import 'product/product_screen.dart';
import 'history/history_screen.dart';

// ============================================
// 🎨 MAIN SCREEN THEME
// ============================================
class MainScreenTheme {
  static const gradientTeal = Color(0xFF43C197);
  static const gradientIndigo = Color(0xFF1C1554);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFCFDFD),
      Color(0xFFF5FAF8),
      Color(0xFFF0F4F8),
      Color(0xFFEEF2F6),
    ],
    stops: [0.0, 0.3, 0.6, 1.0],
  );
}

// ============================================
// 🏠 MAIN SCREEN
// ============================================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static final GlobalKey<_MainScreenState> mainScreenKey =
      GlobalKey<_MainScreenState>();

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  DateTime?  _lastBackPressed;

  final List<Widget> _pages = const [
    DashboardScreen(),
    CashierScreen(),
    ProductScreen(),
    HistoryScreen(),
  ];

  void switchToTab(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    final now = DateTime.now();

    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }

    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 2)) {
      _lastBackPressed = now;
      _showExitSnackbar();
      return false;
    }

    return true;
  }

  void _showExitSnackbar() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding:  const EdgeInsets.all(6),
              decoration:  BoxDecoration(
                color: Colors. white. withValues(alpha:  0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child:  const Icon(
                Icons.exit_to_app_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tekan sekali lagi untuk keluar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight. w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: MainScreenTheme.gradientIndigo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        duration: const Duration(seconds: 2),
        elevation: 8,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child:  Scaffold(
        extendBody: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: MainScreenTheme.backgroundGradient,
          ),
          child: IndexedStack(
            index: _selectedIndex,
            children:  _pages,
          ),
        ),
        bottomNavigationBar:  Navbar(
          selectedIndex: _selectedIndex,
          onTabChange: _onTabChange,
        ),
      ),
    );
  }
}