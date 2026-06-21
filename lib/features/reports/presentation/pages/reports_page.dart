import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_colors.dart';
import 'package:frantend/core/constants/app_text_styles.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter_cubit.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_tab_data.dart';
import 'package:frantend/features/reports/presentation/widgets/reports_filter_bar.dart';
import 'package:frantend/features/reports/presentation/widgets/reports_tab_views.dart';
import 'package:frantend/shared/widgets/feedback/empty_state.dart';
import 'package:frantend/utils/app_alerts.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ReportsFilterCubit>()),
        BlocProvider(create: (_) => sl<ReportsCubit>()),
      ],
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatefulWidget {
  const _ReportsView();

  @override
  State<_ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<_ReportsView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _initialized = false;
  bool _showSecurity = false;

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final filterCubit = context.read<ReportsFilterCubit>();
    await filterCubit.init();
    if (!mounted) return;

    await context.read<ReportsCubit>().init(filterCubit.state.filter);
    if (!mounted) return;

    final cubitState = context.read<ReportsCubit>().state;
    if (cubitState is ReportsAccessDenied) {
      setState(() => _initialized = true);
      return;
    }

    final loaded = cubitState;
    final showSecurity =
        loaded is ReportsLoaded && loaded.showSecurityTab;

    _tabController?.dispose();
    _tabController = TabController(
      length: showSecurity ? 5 : 4,
      vsync: this,
    )..addListener(_onTabChanged);

    setState(() {
      _showSecurity = showSecurity;
      _initialized = true;
    });
  }

  void _onTabChanged() {
    if (_tabController == null || _tabController!.indexIsChanging) return;
    final tabs = _tabsFor(_showSecurity);
    if (_tabController!.index >= tabs.length) return;
    context.read<ReportsCubit>().selectTab(tabs[_tabController!.index]);
  }

  List<ReportsTab> _tabsFor(bool showSecurity) => [
        ReportsTab.sales,
        ReportsTab.products,
        ReportsTab.financial,
        ReportsTab.time,
        if (showSecurity) ReportsTab.security,
      ];

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
      return const Center(child: CircularProgressIndicator());
    }

    return BlocConsumer<ReportsCubit, ReportsState>(
      listener: (context, state) {
        if (state is ReportsLoaded && state.errorMessage != null) {
          AppAlerts.showErrorMessage(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state is ReportsAccessDenied) {
          return const EmptyState(
            icon: Icons.lock_outline,
            message: "You don't have permission to view reports",
          );
        }

        final loaded = state is ReportsLoaded ? state : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text('Analytics & Reports', style: AppTextStyles.headlineMedium),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () => AppAlerts.showInfoMessage(
                    context,
                    'Export coming soon — backend CSV/Excel endpoints exist but desktop file-save is not wired yet.',
                  ),
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportsFilterBar(
              onFilterChanged: (filter) =>
                  context.read<ReportsCubit>().onFilterChanged(filter),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: [
                const Tab(text: 'Sales'),
                const Tab(text: 'Products & Inventory'),
                const Tab(text: 'Customer & Financial'),
                const Tab(text: 'Time Analysis'),
                if (_showSecurity) const Tab(text: 'Security'),
              ],
            ),
            if (loaded?.isLoadingTab == true)
              const LinearProgressIndicator(minHeight: 2),
            Expanded(
              child: loaded == null || _tabController == null
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        ReportsSalesTab(state: loaded),
                        ReportsProductsTab(state: loaded),
                        ReportsFinancialTab(state: loaded),
                        ReportsTimeTab(state: loaded),
                        if (_showSecurity) ReportsSecurityTab(state: loaded),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}
