import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/audit/data/datasources/audit_remote_datasource.dart';
import 'package:frantend/features/audit/data/models/paginated_audit_logs_model.dart';
import 'package:frantend/features/audit/domain/repositories/audit_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuditRepository)
class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl({
    required AuditRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final AuditRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  Future<Either<Failure, T>> _wrap<T>(Future<T> call) async {
    try {
      return Right(await call);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
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
      _wrap(
        _remote.getAuditLogs(
          userId: userId,
          action: action,
          tableName: tableName,
          recordId: recordId,
          dateFrom: dateFrom,
          dateTo: dateTo,
          skip: skip,
          limit: limit,
        ),
      );

  @override
  Future<Either<Failure, PaginatedAuditLogsModel>> getRecordHistory(
    String tableName,
    String recordId, {
    int skip = 0,
    int limit = 50,
  }) =>
      _wrap(
        _remote.getRecordHistory(
          tableName,
          recordId,
          skip: skip,
          limit: limit,
        ),
      );
}
