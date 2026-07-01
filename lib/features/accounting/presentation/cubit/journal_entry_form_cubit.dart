import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_model.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';
import 'package:frantend/features/accounting/domain/utils/journal_balance.dart';
import 'package:frantend/features/accounting/domain/utils/journal_entry_payload.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_form_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class JournalEntryFormCubit extends Cubit<JournalEntryFormState> {
  JournalEntryFormCubit({
    required AuthLocalDataSource authLocalDataSource,
    required ListChartOfAccountsUseCase listChartOfAccountsUseCase,
    required GetJournalEntryUseCase getJournalEntryUseCase,
    required CreateJournalEntryUseCase createJournalEntryUseCase,
    required UpdateJournalEntryUseCase updateJournalEntryUseCase,
    required DeleteJournalEntryUseCase deleteJournalEntryUseCase,
  })  : _authLocal = authLocalDataSource,
        _listCoa = listChartOfAccountsUseCase,
        _getEntry = getJournalEntryUseCase,
        _createEntry = createJournalEntryUseCase,
        _updateEntry = updateJournalEntryUseCase,
        _deleteEntry = deleteJournalEntryUseCase,
        super(const JournalEntryFormState());

  final AuthLocalDataSource _authLocal;
  final ListChartOfAccountsUseCase _listCoa;
  final GetJournalEntryUseCase _getEntry;
  final CreateJournalEntryUseCase _createEntry;
  final UpdateJournalEntryUseCase _updateEntry;
  final DeleteJournalEntryUseCase _deleteEntry;

  Future<bool> _canCreate() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canCreateJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  String _todayIso() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  Future<List<ChartOfAccountModel>> _loadActiveAccounts() async {
    final result = await _listCoa(activeOnly: true, tree: true);
    return result.fold(
      (_) => const [],
      (roots) => flattenCoaTree(roots).map((n) => n.account).toList(),
    );
  }

  List<JournalLineDraft> _defaultLines() => [
        const JournalLineDraft(lineOrder: 0),
        const JournalLineDraft(lineOrder: 1, side: JournalLineSide.credit),
      ];

  List<JournalLineDraft> _linesFromEntry(JournalEntryModel entry) {
    return entry.lines.map((line) {
      final debit = double.tryParse(line.debitAmount) ?? 0;
      final credit = double.tryParse(line.creditAmount) ?? 0;
      final isDebit = debit > 0;
      return JournalLineDraft(
        accountId: line.accountId,
        side: isDebit ? JournalLineSide.debit : JournalLineSide.credit,
        amount: isDebit ? line.debitAmount : line.creditAmount,
        description: line.description,
        lineOrder: line.lineOrder,
      );
    }).toList();
  }

  Future<void> loadForCreate() async {
    if (!await _canCreate()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final accounts = await _loadActiveAccounts();
    emit(
      JournalEntryFormState(
        entryDate: _todayIso(),
        lines: _defaultLines(),
        accounts: accounts,
        canEdit: true,
      ),
    );
  }

  Future<void> loadForEdit(String entryId) async {
    if (!await _canCreate()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final entryResult = await _getEntry(entryId);
    if (entryResult.isLeft()) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {
            '_general': entryResult.fold((f) => f.message, (_) => ''),
          },
        ),
      );
      return;
    }

    final entry = entryResult.getOrElse(() => throw StateError('unreachable'));
    if (entry.status != JournalEntryStatus.draft) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': 'Only draft entries can be edited'},
        ),
      );
      return;
    }

    final accounts = await _loadActiveAccounts();
    final lines = entry.lines.isEmpty ? _defaultLines() : _linesFromEntry(entry);

    emit(
      JournalEntryFormState(
        entryId: entry.id,
        entryDate: entry.entryDate,
        description: entry.description ?? '',
        lines: lines,
        accounts: accounts,
        canEdit: true,
      ),
    );
  }

  void updateEntryDate(String value) =>
      emit(state.copyWith(entryDate: value, errors: {}));

  void updateDescription(String value) =>
      emit(state.copyWith(description: value, errors: {}));

  void addLine() {
    final lines = [...state.lines, JournalLineDraft(lineOrder: state.lines.length)];
    emit(state.copyWith(lines: lines, errors: {}));
  }

  void removeLine(int index) {
    if (state.lines.length <= 1) return;
    final lines = [...state.lines]..removeAt(index);
    final reordered = [
      for (var i = 0; i < lines.length; i++) lines[i].copyWith(lineOrder: i),
    ];
    emit(state.copyWith(lines: reordered, errors: {}));
  }

  void updateLineAccount(int index, String? accountId) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(accountId: accountId);
    emit(state.copyWith(lines: lines, errors: {}));
  }

  void updateLineSide(int index, JournalLineSide side) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(side: side);
    emit(state.copyWith(lines: lines, errors: {}));
  }

  void updateLineAmount(int index, String amount) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(amount: amount);
    emit(state.copyWith(lines: lines, errors: {}));
  }

  void updateLineDescription(int index, String? description) {
    final lines = [...state.lines];
    lines[index] = lines[index].copyWith(description: description);
    emit(state.copyWith(lines: lines, errors: {}));
  }

  Future<bool?> submit() async {
    if (!state.canEdit) return false;

    final errors = validateJournalLineDrafts(state.lines);
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return false;
    }

    if (state.entryDate.trim().isEmpty) {
      emit(state.copyWith(errors: {'entry_date': 'Entry date is required'}));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, errors: {}));

    final payload = buildJournalEntryPayload(
      entryDate: state.entryDate.trim(),
      description: state.description,
      lines: state.lines,
    );

    if (state.isEdit) {
      final result = await _updateEntry(state.entryId!, payload);
      return result.fold(
        (failure) {
          emit(state.copyWith(isSubmitting: false, errors: {'_general': failure.message}));
          return false;
        },
        (_) {
          emit(state.copyWith(isSubmitting: false));
          return true;
        },
      );
    }

    final result = await _createEntry(payload);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, errors: {'_general': failure.message}));
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }

  Future<bool?> deleteEntry() async {
    if (!state.canEdit || state.entryId == null) return false;

    emit(state.copyWith(isDeleting: true, errors: {}));

    final result = await _deleteEntry(state.entryId!);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false, errors: {'_general': failure.message}));
        return false;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return true;
      },
    );
  }
}
