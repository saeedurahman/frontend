import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';

abstract class AccountingRepository {
  Future<Either<Failure, List<ChartOfAccountModel>>> listChartOfAccounts({
    bool activeOnly = false,
    bool tree = false,
  });

  Future<Either<Failure, ChartOfAccountModel>> getChartOfAccount(String id);

  Future<Either<Failure, ChartOfAccountModel>> createChartOfAccount(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, ChartOfAccountModel>> updateChartOfAccount(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteChartOfAccount(String id);

  Future<Either<Failure, List<JournalEntryListModel>>> listJournalEntries({
    String? status,
    String? dateFrom,
    String? dateTo,
    String? branchId,
    int skip = 0,
    int limit = 50,
  });

  Future<Either<Failure, JournalEntryModel>> getJournalEntry(String id);

  Future<Either<Failure, JournalEntryModel>> createJournalEntry(
    Map<String, dynamic> body,
  );

  Future<Either<Failure, JournalEntryModel>> updateJournalEntry(
    String id,
    Map<String, dynamic> body,
  );

  Future<Either<Failure, void>> deleteJournalEntry(String id);

  Future<Either<Failure, JournalEntryModel>> postJournalEntry(String id);
}
