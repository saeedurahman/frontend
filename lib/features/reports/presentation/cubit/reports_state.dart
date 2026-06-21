import 'package:equatable/equatable.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_filter.dart';
import 'package:frantend/features/reports/presentation/cubit/reports_tab_data.dart';

class ReportsFilterState extends Equatable {
  const ReportsFilterState({required this.filter});

  factory ReportsFilterState.initial({String? branchId}) =>
      ReportsFilterState(filter: ReportsFilter.last7Days(branchId: branchId));

  final ReportsFilter filter;

  ReportsFilterState copyWith(ReportsFilter filter) =>
      ReportsFilterState(filter: filter);

  @override
  List<Object?> get props => [filter.dateFrom, filter.dateTo, filter.branchId];
}

sealed class ReportsState extends Equatable {
  const ReportsState();
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
  @override
  List<Object?> get props => [];
}

class ReportsLoaded extends ReportsState {
  const ReportsLoaded({
    required this.filter,
    required this.activeTab,
    required this.loadedTabs,
    this.isLoadingTab = false,
    this.errorMessage,
    this.salesTab,
    this.productsTab,
    this.financialTab,
    this.timeTab,
    this.securityTab,
    this.showSecurityTab = true,
  });

  final ReportsFilter filter;
  final ReportsTab activeTab;
  final Set<ReportsTab> loadedTabs;
  final bool isLoadingTab;
  final String? errorMessage;
  final SalesTabData? salesTab;
  final ProductsTabData? productsTab;
  final FinancialTabData? financialTab;
  final TimeTabData? timeTab;
  final SecurityTabData? securityTab;
  final bool showSecurityTab;

  ReportsLoaded copyWith({
    ReportsFilter? filter,
    ReportsTab? activeTab,
    Set<ReportsTab>? loadedTabs,
    bool? isLoadingTab,
    String? errorMessage,
    SalesTabData? salesTab,
    ProductsTabData? productsTab,
    FinancialTabData? financialTab,
    TimeTabData? timeTab,
    SecurityTabData? securityTab,
    bool? showSecurityTab,
    bool clearError = false,
  }) {
    return ReportsLoaded(
      filter: filter ?? this.filter,
      activeTab: activeTab ?? this.activeTab,
      loadedTabs: loadedTabs ?? this.loadedTabs,
      isLoadingTab: isLoadingTab ?? this.isLoadingTab,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      salesTab: salesTab ?? this.salesTab,
      productsTab: productsTab ?? this.productsTab,
      financialTab: financialTab ?? this.financialTab,
      timeTab: timeTab ?? this.timeTab,
      securityTab: securityTab ?? this.securityTab,
      showSecurityTab: showSecurityTab ?? this.showSecurityTab,
    );
  }

  @override
  List<Object?> get props => [
        filter,
        activeTab,
        loadedTabs,
        isLoadingTab,
        errorMessage,
        salesTab,
        productsTab,
        financialTab,
        timeTab,
        securityTab,
        showSecurityTab,
      ];
}

class ReportsError extends ReportsState {
  const ReportsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class ReportsAccessDenied extends ReportsState {
  const ReportsAccessDenied();
  @override
  List<Object?> get props => [];
}
