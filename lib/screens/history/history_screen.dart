import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/settings_provider.dart';
import 'utils/history_theme.dart';
import 'utils/history_helpers.dart';
import 'utils/filter_sort_helper.dart';
import 'utils/stats_calculator.dart';
import 'widgets/gradient_app_bar.dart';
import 'widgets/stats_section.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/filter_chips.dart';
import 'widgets/transaction_item.dart';
import 'widgets/empty_state.dart';
import 'widgets/sort_bottom_sheet.dart';
import 'widgets/receipt_dialog.dart';

// ============================================
// 🏠 PREMIUM HISTORY SCREEN (REFACTORED)
// ============================================
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  DateFilter _selectedFilter = DateFilter.all;
  SortOption _selectedSort = SortOption. latest;
  String _searchQuery = '';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();
    await Provider.of<TransactionProvider>(context, listen: false)
        .loadTransactions();
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => SortBottomSheet(
        selectedSort: _selectedSort,
        onSortChanged: (newSort) {
          setState(() => _selectedSort = newSort);
        },
      ),
    );
  }

  void _showReceipt(Transaction transaction) {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => ReceiptDialog(
        transaction: transaction,
        storeName: settingsProvider.storeName,
        storeAddress:  settingsProvider.storeAddress,
        storePhone: settingsProvider.storePhone,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HistoryTheme.backgroundColor,
      body: FadeTransition(
        opacity:  _fadeAnimation,
        child:  RefreshIndicator(
          onRefresh: _handleRefresh,
          color: HistoryTheme.gradientTeal,
          backgroundColor: Colors.white,
          child: Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              final allTransactions = provider.transactions;
              
              final filteredTransactions = FilterSortHelper.filterAndSort(
                transactions: allTransactions,
                dateFilter: _selectedFilter,
                sortOption: _selectedSort,
                searchQuery: _searchQuery,
              );

              final stats = StatsCalculator.getTodayStats(allTransactions);

              return CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers:  [
                  GradientAppBar(onSortTap: _showSortSheet),
                  SliverToBoxAdapter(
                    child:  StatsSection(
                      stats:  stats,
                      formatCompact: HistoryHelpers.formatCompactRupiah,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SearchBarWidget(
                      controller:  _searchController,
                      searchQuery: _searchQuery,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: FilterChips(
                      selectedFilter: _selectedFilter,
                      onFilterChanged: (filter) {
                        setState(() => _selectedFilter = filter);
                      },
                    ),
                  ),
                  filteredTransactions.isEmpty
                      ? SliverFillRemaining(
                          child: EmptyState(searchQuery: _searchQuery),
                        )
                      : SliverPadding(
                          padding:  const EdgeInsets.fromLTRB(16, 8, 16, 100),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return TransactionItem(
                                  transaction: filteredTransactions[index],
                                  index: index,
                                  onTap: () => _showReceipt(
                                    filteredTransactions[index],
                                  ),
                                );
                              },
                              childCount: filteredTransactions.length,
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}