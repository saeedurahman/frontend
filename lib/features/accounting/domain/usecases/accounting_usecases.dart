import 'package:dartz/dartz.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:frantend/features/accounting/domain/repositories/accounting_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ListChartOfAccountsUseCase {
  const ListChartOfAccountsUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, List<ChartOfAccountModel>>> call({
    bool activeOnly = false,
    bool tree = false,
  }) =>
      _repository.listChartOfAccounts(activeOnly: activeOnly, tree: tree);
}

@injectable
class GetChartOfAccountUseCase {
  const GetChartOfAccountUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, ChartOfAccountModel>> call(String id) =>
      _repository.getChartOfAccount(id);
}

@injectable
class CreateChartOfAccountUseCase {
  const CreateChartOfAccountUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, ChartOfAccountModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.createChartOfAccount(body);
}

@injectable
class UpdateChartOfAccountUseCase {
  const UpdateChartOfAccountUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, ChartOfAccountModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateChartOfAccount(id, body);
}

@injectable
class DeleteChartOfAccountUseCase {
  const DeleteChartOfAccountUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteChartOfAccount(id);
}

@injectable
class ListJournalEntriesUseCase {
  const ListJournalEntriesUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, List<JournalEntryListModel>>> call({
    String? status,
    String? dateFrom,
    String? dateTo,
    String? branchId,
    int skip = 0,
    int limit = 50,
  }) =>
      _repository.listJournalEntries(
        status: status,
        dateFrom: dateFrom,
        dateTo: dateTo,
        branchId: branchId,
        skip: skip,
        limit: limit,
      );
}

@injectable
class GetJournalEntryUseCase {
  const GetJournalEntryUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, JournalEntryModel>> call(String id) =>
      _repository.getJournalEntry(id);
}

@injectable
class CreateJournalEntryUseCase {
  const CreateJournalEntryUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, JournalEntryModel>> call(
    Map<String, dynamic> body,
  ) =>
      _repository.createJournalEntry(body);
}

@injectable
class UpdateJournalEntryUseCase {
  const UpdateJournalEntryUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, JournalEntryModel>> call(
    String id,
    Map<String, dynamic> body,
  ) =>
      _repository.updateJournalEntry(id, body);
}

@injectable
class DeleteJournalEntryUseCase {
  const DeleteJournalEntryUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteJournalEntry(id);
}

@injectable
class PostJournalEntryUseCase {
  const PostJournalEntryUseCase(this._repository);

  final AccountingRepository _repository;

  Future<Either<Failure, JournalEntryModel>> call(String id) =>
      _repository.postJournalEntry(id);
}
