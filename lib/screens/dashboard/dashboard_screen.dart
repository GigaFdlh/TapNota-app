import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../providers/transaction_provider.dart';
import 'utils/dashboard_theme.dart';
import 'widgets/glass_app_bar.dart';
import 'widgets/stats_section.dart';
import 'widgets/quick_actions.dart';
import 'widgets/chart_section.dart';
import 'widgets/recent_transactions.dart';

// ============================================
// DASHBOARD SCREEN
// ============================================
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  bool _isLocaleInitialized = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _initData();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent:  _fadeController,
      curve:  Curves.easeOutCubic,
    );
    _fadeController.forward();
  }

  Future<void> _initData() async {
    await initializeDateFormatting('id_ID', null);
    if (mounted) setState(() => _isLocaleInitialized = true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await Provider.of<TransactionProvider>(context, listen: false).loadTransactions();
  }

  void _navigateToTab(int tabIndex) {
    HapticFeedback.lightImpact();
    final mainScreenState = context.findAncestorStateOfType();
    if (mainScreenState != null) {
      try {
        (mainScreenState as dynamic).switchToTab(tabIndex);
      } catch (e) {
        debugPrint('Navigation error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardTheme.backgroundColor,
      body: FadeTransition(
        opacity:  _fadeAnimation,
        child:  RefreshIndicator(
          onRefresh: _handleRefresh,
          color: DashboardTheme.gradientTeal,
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              GlassAppBar(isLocaleInitialized: _isLocaleInitialized),
              SliverToBoxAdapter(
                child:  Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const StatsSection(),
                      const SizedBox(height: 24),
                      QuickActions(onNavigate: _navigateToTab),
                      const SizedBox(height: 24),
                      const ChartSection(),
                      const SizedBox(height: 24),
                      RecentTransactions(onNavigate:  _navigateToTab),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}