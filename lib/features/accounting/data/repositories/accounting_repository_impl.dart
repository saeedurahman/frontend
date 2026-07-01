import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/error_handler.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/accounting/data/datasources/accounting_remote_datasource.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:frantend/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AccountingRepository)
class AccountingRepositoryImpl implements AccountingRepository {
  AccountingRepositoryImpl({
    required AccountingRemoteDataSource remoteDataSource,
    required ErrorHandler errorHandler,
  })  : _remote = remoteDataSource,
        _errorHandler = errorHandler;

  final AccountingRemoteDataSource _remote;
  final ErrorHandler _errorHandler;

  @override
  Future<Either<Failure, List<ChartOfAccountModel>>> listChartOfAccounts({
    bool activeOnly = false,
    bool tree = false,
  }) async {
    try {
      final result = await _remote.listChartOfAccounts(
        activeOnly: activeOnly,
        tree: tree,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChartOfAccountModel>> getChartOfAccount(
    String id,
  ) async {
    try {
      return Right(await _remote.getChartOfAccount(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChartOfAccountModel>> createChartOfAccount(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createChartOfAccount(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ChartOfAccountModel>> updateChartOfAccount(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateChartOfAccount(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChartOfAccount(String id) async {
    try {
      await _remote.deleteChartOfAccount(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<JournalEntryListModel>>> listJournalEntries({
    String? status,
    String? dateFrom,
    String? dateTo,
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) async {
    try {
      final result = await _remote.listJournalEntries(
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
        skip: skip,
        limit: limit,
      );
      return Right(result);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, JournalEntryModel>> getJournalEntry(String id) async {
    try {
      return Right(await _remote.getJournalEntry(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, JournalEntryModel>> createJournalEntry(
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.createJournalEntry(body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, JournalEntryModel>> updateJournalEntry(
    String id,
    Map<String, dynamic> body,
  ) async {
    try {
      return Right(await _remote.updateJournalEntry(id, body));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteJournalEntry(String id) async {
    try {
      await _remote.deleteJournalEntry(id);
      return const Right(null);
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, JournalEntryModel>> postJournalEntry(String id) async {
    try {
      return Right(await _remote.postJournalEntry(id));
    } catch (e) {
      return Left(_errorHandler.mapExceptionToFailure(e));
    }
  }
}
