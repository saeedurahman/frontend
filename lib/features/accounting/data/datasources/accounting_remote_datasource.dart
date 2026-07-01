import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:injectable/injectable.dart';

abstract class AccountingRemoteDataSource {
  Future<List<ChartOfAccountModel>> listChartOfAccounts({
    bool activeOnly = false,
    bool tree = false,
  });

  Future<ChartOfAccountModel> getChartOfAccount(String id);

  Future<ChartOfAccountModel> createChartOfAccount(Map<String, dynamic> body);

  Future<ChartOfAccountModel> updateChartOfAccount(
    String id,
    Map<String, dynamic> body,
  );

  Future<void> deleteChartOfAccount(String id);

  Future<List<JournalEntryListModel>> listJournalEntries({
    String? status,
    String? dateFrom,
    String? dateTo,
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  Future<JournalEntryModel> getJournalEntry(String id);

  Future<JournalEntryModel> createJournalEntry(Map<String, dynamic> body);

  Future<JournalEntryModel> updateJournalEntry(
    String id,
    Map<String, dynamic> body,
  );

  Future<void> deleteJournalEntry(String id);

  Future<JournalEntryModel> postJournalEntry(String id);
}

@LazySingleton(as: AccountingRemoteDataSource)
class AccountingRemoteDataSourceImpl implements AccountingRemoteDataSource {
  AccountingRemoteDataSourceImpl(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  @override
  Future<List<ChartOfAccountModel>> listChartOfAccounts({
    bool activeOnly = false,
    bool tree = false,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.accountingCoa,
      queryParameters: {
        'active_only': activeOnly,
        'tree': tree,
      },
    );
    return _toModelList(response.data, ChartOfAccountModel.fromJson);
  }

  @override
  Future<ChartOfAccountModel> getChartOfAccount(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.accountingCoaById(id),
    );
    return ChartOfAccountModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ChartOfAccountModel> createChartOfAccount(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.accountingCoa,
      data: body,
    );
    return ChartOfAccountModel.fromJson(response.data ?? const {});
  }

  @override
  Future<ChartOfAccountModel> updateChartOfAccount(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.accountingCoaById(id),
      data: body,
    );
    return ChartOfAccountModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteChartOfAccount(String id) async {
    await _dio.delete<dynamic>(ApiConstants.accountingCoaById(id));
  }

  @override
  Future<List<JournalEntryListModel>> listJournalEntries({
    String? status,
    String? dateFrom,
    String? dateTo,
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.accountingJournalEntries,
      queryParameters: {
        if (status != null) 'status': status,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (branchId != null) 'branch_id': branchId,
        'skip': skip,
        'limit': limit,
      },
    );
    return _toModelList(response.data, JournalEntryListModel.fromJson);
  }

  @override
  Future<JournalEntryModel> getJournalEntry(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.accountingJournalEntry(id),
    );
    return JournalEntryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<JournalEntryModel> createJournalEntry(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.accountingJournalEntries,
      data: body,
    );
    return JournalEntryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<JournalEntryModel> updateJournalEntry(
    String id,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiConstants.accountingJournalEntry(id),
      data: body,
    );
    return JournalEntryModel.fromJson(response.data ?? const {});
  }

  @override
  Future<void> deleteJournalEntry(String id) async {
    await _dio.delete<dynamic>(ApiConstants.accountingJournalEntry(id));
  }

  @override
  Future<JournalEntryModel> postJournalEntry(String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.accountingJournalEntryPost(id),
    );
    return JournalEntryModel.fromJson(response.data ?? const {});
  }

  List<T> _toModelList<T>(
    dynamic payload,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (payload is List) {
      return payload
          .whereType<Map<dynamic, dynamic>>()
          .map((item) => fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }
}
