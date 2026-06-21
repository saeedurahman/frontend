import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/reports/domain/usecases/reports_usecases.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_state.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_tab_data.dart';
import 'package:injectable/injectable.dart';

class ReportsAccessDeniedException implements Exception {
  const ReportsAccessDeniedException();
}

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._useCases, this._authLocal) : super(const ReportsInitial());

  final ReportsUseCases _useCases;
  final AuthLocalDataSource _authLocal;

  Future<T> _unwrap<T>(Future<Either<Failure, T>> call) async {
    final result = await call;
    return result.fold(
      (failure) {
        if (failure is AuthFailure) {
          throw const ReportsAccessDeniedException();
        }
        throw Exception(failure.message);
      },
      (value) => value,
    );
  }

  Future<void> init(ReportsFilter filter) async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewReports(user?.role)) {
      emit(const ReportsAccessDenied());
      return;
    }
    final isOwner = user?.role.toLowerCase() == 'owner';
    emit(
      ReportsLoaded(
        filter: filter,
        activeTab: ReportsTab.sales,
        loadedTabs: {},
        showSecurityTab: isOwner,
      ),
    );
    await loadTab(ReportsTab.sales, force: true);
  }

  Future<void> onFilterChanged(ReportsFilter filter) async {
    final current = state;
    if (current is! ReportsLoaded) return;
    final active = current.activeTab;
    emit(
      current.copyWith(
        filter: filter,
        loadedTabs: {},
        clearError: true,
      ),
    );
    await loadTab(active, force: true);
  }

  Future<void> selectTab(ReportsTab tab) async {
    final current = state;
    if (current is! ReportsLoaded) return;
    if (current.activeTab == tab) return;
    emit(current.copyWith(activeTab: tab, clearError: true));
    await loadTab(tab);
  }

  Future<void> loadTab(ReportsTab tab, {bool force = false}) async {
    final current = state;
    if (current is! ReportsLoaded) return;
    if (!force && current.loadedTabs.contains(tab)) return;

    emit(current.copyWith(isLoadingTab: true, clearError: true));

    try {
      switch (tab) {
        case ReportsTab.sales:
          await _loadSalesTab(current);
        case ReportsTab.products:
          await _loadProductsTab(current);
        case ReportsTab.financial:
          await _loadFinancialTab(current);
        case ReportsTab.time:
          await _loadTimeTab(current);
        case ReportsTab.security:
          await _loadSecurityTab(current);
      }
    } on ReportsAccessDeniedException {
      emit(const ReportsAccessDenied());
    } on Exception catch (e) {
      final latest = state;
      if (latest is ReportsLoaded) {
        emit(
          latest.copyWith(
            isLoadingTab: false,
            errorMessage: e.toString().replaceFirst('Exception: ', ''),
          ),
        );
      }
    }
  }

  Future<void> _loadSalesTab(ReportsLoaded current) async {
    final q = current.filter.query;
    final branchId = current.filter.branchId;

    final summary = await _unwrap(_useCases.salesSummary(q));
    final todayVsYesterday =
        await _unwrap(_useCases.todayVsYesterday(branchId: branchId));
    final salesTrend = await _unwrap(_useCases.salesTrend(q));
    final paymentBreakdown = await _unwrap(_useCases.paymentBreakdown(q));
    final cashierPerformance = await _unwrap(_useCases.cashierPerformance(q));
    final branchComparison = await _unwrap(_useCases.branchComparison(q));

    final latest = state;
    if (latest is! ReportsLoaded) return;

    emit(
      latest.copyWith(
        isLoadingTab: false,
        salesTab: SalesTabData(
          summary: summary,
          todayVsYesterday: todayVsYesterday,
          salesTrend: salesTrend,
          paymentBreakdown: paymentBreakdown,
          cashierPerformance: cashierPerformance,
          branchComparison: branchComparison,
        ),
        loadedTabs: {...latest.loadedTabs, ReportsTab.sales},
      ),
    );
  }

  Future<void> _loadProductsTab(ReportsLoaded current) async {
    final q = current.filter.query;
    final branchId = current.filter.branchId;

    final topProducts = await _unwrap(_useCases.topProducts(q));
    final categoryPerformance = await _unwrap(_useCases.categoryPerformance(q));
    final productMovement = await _unwrap(_useCases.productMovement(q));
    final deadStock = await _unwrap(_useCases.deadStock(branchId: branchId));
    final stockValuation =
        await _unwrap(_useCases.stockValuation(branchId: branchId));
    final inventoryInsights =
        await _unwrap(_useCases.inventoryInsights(branchId: branchId));

    final latest = state;
    if (latest is! ReportsLoaded) return;

    emit(
      latest.copyWith(
        isLoadingTab: false,
        productsTab: ProductsTabData(
          topProducts: topProducts,
          categoryPerformance: categoryPerformance,
          productMovement: productMovement,
          deadStock: deadStock,
          stockValuation: stockValuation,
          inventoryInsights: inventoryInsights,
        ),
        loadedTabs: {...latest.loadedTabs, ReportsTab.products},
      ),
    );
  }

  Future<void> _loadFinancialTab(ReportsLoaded current) async {
    final q = current.filter.query;

    final customerInsights = await _unwrap(_useCases.customerInsights());
    final profitLoss = await _unwrap(_useCases.profitLoss(q));
    final expenseSummary = await _unwrap(_useCases.expenseSummary(q));
    final taxSummary = await _unwrap(_useCases.taxSummary(q));

    final latest = state;
    if (latest is! ReportsLoaded) return;

    emit(
      latest.copyWith(
        isLoadingTab: false,
        financialTab: FinancialTabData(
          customerInsights: customerInsights,
          profitLoss: profitLoss,
          expenseSummary: expenseSummary,
          taxSummary: taxSummary,
        ),
        loadedTabs: {...latest.loadedTabs, ReportsTab.financial},
      ),
    );
  }

  Future<void> _loadTimeTab(ReportsLoaded current) async {
    final q = current.filter.query;
    final peakHours = await _unwrap(_useCases.peakHours(q));
    final peakDays = await _unwrap(_useCases.peakDays(q));

    final latest = state;
    if (latest is! ReportsLoaded) return;

    emit(
      latest.copyWith(
        isLoadingTab: false,
        timeTab: TimeTabData(peakHours: peakHours, peakDays: peakDays),
        loadedTabs: {...latest.loadedTabs, ReportsTab.time},
      ),
    );
  }

  Future<void> _loadSecurityTab(ReportsLoaded current) async {
    final alerts = await _unwrap(_useCases.fraudAlerts(current.filter.query));

    final latest = state;
    if (latest is! ReportsLoaded) return;

    emit(
      latest.copyWith(
        isLoadingTab: false,
        securityTab: SecurityTabData(fraudAlerts: alerts),
        loadedTabs: {...latest.loadedTabs, ReportsTab.security},
      ),
    );
  }
}
