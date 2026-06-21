import 'package:dio/dio.dart';
import 'package:frantend/core/constants/api_constants.dart';
import 'package:frantend/core/network/dio_client.dart';
import 'package:frantend/features/audit/data/models/paginated_audit_logs_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuditRemoteDataSource {
  AuditRemoteDataSource(this._dioClient);

  final DioClient _dioClient;

  Dio get _dio => _dioClient.dio;

  static final _opts = Options(extra: {'skip_offline_queue': true});

  Future<PaginatedAuditLogsModel> getAuditLogs({
    String? userId,
    String? action,
    String? tableName,
    String? recordId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.auditLogs,
      queryParameters: {
        if (userId != null && userId.isNotEmpty) 'user_id': userId,
        if (action != null && action.isNotEmpty) 'action': action,
        if (tableName != null && tableName.isNotEmpty) 'table_name': tableName,
        if (recordId != null && recordId.isNotEmpty) 'record_id': recordId,
        if (dateFrom != null) 'date_from': _isoDate(dateFrom),
        if (dateTo != null) 'date_to': _isoDate(dateTo),
        'skip': skip,
        'limit': limit,
      },
      options: _opts,
    );
    return PaginatedAuditLogsModel.fromJson(response.data ?? const {});
  }

  Future<PaginatedAuditLogsModel> getRecordHistory(
    String tableName,
    String recordId, {
    int skip = 0,
    int limit = 50,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.auditRecordHistory(tableName, recordId),
      queryParameters: {
        'skip': skip,
        'limit': limit,
      },
      options: _opts,
    );
    return PaginatedAuditLogsModel.fromJson(response.data ?? const {});
  }

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
