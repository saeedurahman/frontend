import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/audit/data/models/paginated_audit_logs_model.dart';
import 'package:frantend/features/audit/domain/repositories/audit_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuditUseCases {
  AuditUseCases(this._repository);

  final AuditRepository _repository;

  Future<Either<Failure, PaginatedAuditLogsModel>> getAuditLogs({
    String? userId,
    String? action,
    String? tableName,
    String? recordId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getAuditLogs(
        userId: userId,
        action: action,
        tableName: tableName,
        recordId: recordId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        skip: skip,
        limit: limit,
      );

  Future<Either<Failure, PaginatedAuditLogsModel>> getRecordHistory(
    String tableName,
    String recordId, {
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.getRecordHistory(
        tableName,
        recordId,
        skip: skip,
        limit: limit,
      );
}
