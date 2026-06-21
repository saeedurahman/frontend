import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/audit/data/models/paginated_audit_logs_model.dart';

abstract class AuditRepository {
  Future<Either<Failure, PaginatedAuditLogsModel>> getAuditLogs({
    String? userId,
    String? action,
    String? tableName,
    String? recordId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int skip,
    int limit,
  });

  Future<Either<Failure, PaginatedAuditLogsModel>> getRecordHistory(
    String tableName,
    String recordId, {
    int skip,
    int limit,
  });
}
