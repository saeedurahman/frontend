import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/core/services/export_service.dart';
import 'package:frantend/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:frantend/features/dashboard/data/models/dashboard_summary_model.dart';
import 'package:frantend/features/dashboard/data/models/khata_summary_model.dart';
import 'package:frantend/features/dashboard/data/models/sales_trend_model.dart';
import 'package:frantend/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:frantend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:frantend/features/dashboard/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:frantend/features/dashboard/presentation/cubit/dashboard_state.dart';

import '../helpers/fake_http.dart';
import '../helpers/khata_fakes.dart';

class _Dio implements DioClient {
  _Dio(this._dio);
  final Dio _dio;
  @override
  Dio get dio => _dio;
}

class _Data extends Fake implements DashboardData {}

class _Summary extends Fake implements GetDashboardSummaryUseCase {
  final calls = <({String? branch, int days})>[];

  @override
  Future<DashboardData> call({String? branchId, int trendDays = 7}) async {
    calls.add((branch: branchId, days: trendDays));
    return _Data();
  }
}

void main() {
  group('export: one customer / supplier, named file', () {
    test('the customer ledger export is filtered to that customer', () {
      final q = ExportService.buildQuery(
        format: 'xlsx',
        filters: {'customer_id': 'c-1'},
        branchId: 'b-1',
      );
      expect(q['customer_id'], 'c-1');
      expect(q['branch_id'], 'b-1');
      expect(q['format'], 'xlsx');
      expect(q.containsKey('supplier_id'), isFalse);
    });

    test('the supplier ledger export is filtered to that supplier', () {
      final q = ExportService.buildQuery(
        format: 'csv',
        filters: {'supplier_id': 's-1'},
      );
      expect(q['supplier_id'], 's-1');
      expect(q.containsKey('customer_id'), isFalse);
    });

    test('empty filters and empty branch are left out', () {
      final q = ExportService.buildQuery(
        format: 'pdf',
        filters: {'customer_id': ''},
        branchId: '',
      );
      expect(q.keys, ['format']);
    });

    test('dates go as plain days', () {
      final q = ExportService.buildQuery(
        format: 'xlsx',
        dateFrom: DateTime(2026, 3, 1),
        dateTo: DateTime(2026, 3, 31),
      );
      expect(q['date_from'], '2026-03-01');
      expect(q['date_to'], '2026-03-31');
    });

    test('the file is named after the person, safely', () {
      final on = DateTime(2026, 11, 25);
      expect(ExportService.fileNameFor('Ali Khan', 'ledger', 'xlsx', on: on),
          'Ali_Khan_ledger_20261125.xlsx');
      expect(ExportService.fileNameFor('A/B: C*?', 'ledger', 'pdf', on: on),
          isNot(matches(RegExp(r'[\/:*?"<>|]'))));
      expect(ExportService.fileNameFor('   ', 'ledger', 'csv', on: on),
          'ledger_20261125.csv');
    });
  });

  group('dashboard receivable / payable pass the branch', () {
    late FakeAdapter adapter;
    late DashboardRemoteDataSourceImpl source;

    setUp(() {
      adapter = FakeAdapter((o) => jsonResponse({
            'receivable': '1500',
            'payable': '700',
            'top_debtors': [],
          }));
      final dio = Dio(BaseOptions(baseUrl: 'http://x'))
        ..httpClientAdapter = adapter;
      source = DashboardRemoteDataSourceImpl(_Dio(dio));
    });

    test('khata summary sends branch_id', () async {
      final r = await source.getKhataSummary(branchId: 'b-7');
      expect(adapter.requests.single.queryParameters['branch_id'], 'b-7');
      expect(r.receivable.toString(), '1500');
      expect(r.payable.toString(), '700');
    });

    test('no branch picked = no branch_id (all branches)', () async {
      await source.getKhataSummary();
      expect(adapter.requests.single.queryParameters.containsKey('branch_id'),
          isFalse);
    });

    test('summary sends branch_id too', () async {
      adapter = FakeAdapter((o) => jsonResponse(<String, dynamic>{}));
      final dio = Dio(BaseOptions(baseUrl: 'http://x'))
        ..httpClientAdapter = adapter;
      await DashboardRemoteDataSourceImpl(_Dio(dio))
          .getSummary(branchId: 'b-7');
      expect(adapter.requests.single.queryParameters['branch_id'], 'b-7');
    });
  });

  group('dashboard repository', () {
    test('asks for the khata numbers of the same branch as the summary',
        () async {
      final source = _RecordingSource();
      await DashboardRepositoryImpl(source).getDashboardData(branchId: 'b-2');
      expect(source.summaryBranch, 'b-2');
      expect(source.khataBranch, 'b-2');
    });

    test('the page still opens when the credit numbers fail', () async {
      final source = _RecordingSource()..failKhata = true;
      final data =
          await DashboardRepositoryImpl(source).getDashboardData(branchId: 'b');
      expect(data.khata, isNull);
    });
  });

  group('dashboard cubit remembers the branch', () {
    test('Retry / trend buttons and Khata events reload the same branch',
        () async {
      final summary = _Summary();
      final events = CountingKhataEvents();
      final cubit = DashboardCubit(summary, events);
      addTearDown(cubit.close);

      await cubit.loadDashboard(branchId: 'b-9');
      expect(summary.calls.last.branch, 'b-9');
      expect(cubit.state, isA<DashboardLoaded>());

      await cubit.loadDashboard(keepBranch: true, trendDays: 30);
      expect(summary.calls.last.branch, 'b-9');
      expect(summary.calls.last.days, 30);

      // A payment elsewhere refreshes quietly, still for that branch.
      final before = summary.calls.length;
      events.notifyChanged();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(summary.calls.length, before + 1);
      expect(summary.calls.last.branch, 'b-9');
    });

    test('picking another branch replaces it', () async {
      final summary = _Summary();
      final cubit = DashboardCubit(summary, CountingKhataEvents());
      addTearDown(cubit.close);
      await cubit.loadDashboard(branchId: 'b-1');
      await cubit.loadDashboard(branchId: null);
      expect(summary.calls.last.branch, isNull);
    });
  });
}

class _RecordingSource extends Fake implements DashboardRemoteDataSource {
  String? summaryBranch;
  String? khataBranch;
  bool failKhata = false;

  @override
  Future<DashboardSummaryModel> getSummary({String? branchId}) async {
    summaryBranch = branchId;
    return DashboardSummaryModel.fromJson(const {});
  }

  @override
  Future<List<SalesTrendPointModel>> getSalesTrend({
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async =>
      [];

  @override
  Future<List<PaymentBreakdownModel>> getPaymentBreakdown({
    required DateTime dateFrom,
    required DateTime dateTo,
  }) async =>
      [];

  @override
  Future<List<TopProductModel>> getTopProducts({
    required DateTime dateFrom,
    required DateTime dateTo,
    int limit = 5,
  }) async =>
      [];

  @override
  Future<List<RecentTransactionModel>> getRecentTransactions({
    int limit = 5,
  }) async =>
      [];

  @override
  Future<InventoryInsightsModel> getInventoryInsights() async =>
      InventoryInsightsModel.fromJson(const {});

  @override
  Future<KhataSummaryModel> getKhataSummary({
    String? branchId,
    int limit = 5,
  }) async {
    khataBranch = branchId;
    if (failKhata) throw Exception('down');
    return KhataSummaryModel(
      receivable: Decimal.zero,
      payable: Decimal.zero,
      branchId: branchId,
    );
  }
}
