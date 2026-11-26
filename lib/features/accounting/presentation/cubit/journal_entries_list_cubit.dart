import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entries_list_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class JournalEntriesListCubit extends Cubit<JournalEntriesListState>
    with AutoRefresh<JournalEntriesListState> {
  JournalEntriesListCubit({
    required ListJournalEntriesUseCase listJournalEntriesUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _listEntries = listJournalEntriesUseCase,
        _authLocal = authLocalDataSource,
        super(const JournalEntriesListState.initial()) {
    watchData({DataTopic.accounting}, _readQuietly);
  }

  final ListJournalEntriesUseCase _listEntries;
  final AuthLocalDataSource _authLocal;

  String? _statusFilter;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(const JournalEntriesListState.accessDenied());
      return;
    }
    await load();
  }

  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> load() => _read(quiet: false);

  /// Reads the entries again behind the rows on screen.
  Future<void> _readQuietly() async {
    if (state is JournalEntriesListLoaded) await _read(quiet: true);
  }

  /// The id of a new entry on top of the list, for the table's reset token.
  String? get newestCreatedId {
    final current = state;
    if (current is! JournalEntriesListLoaded) return null;
    return createdOnTop(current.entries, (entry) => entry.id);
  }

  Future<void> _read({required bool quiet}) async {
    final read = beginRead();
    if (!quiet) emit(const JournalEntriesListState.loading());

    final user = await _authLocal.getCachedUser();
    final canCreate = UserRoleUtils.canCreateJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final result = await _listEntries(
      status: _statusFilter,
      dateFrom: _formatDate(_dateFrom),
      dateTo: _formatDate(_dateTo),
      limit: 200,
    );
    if (isStale(read)) return;

    result.fold(
      (failure) {
        if (!quiet) emit(JournalEntriesListState.error(failure.message));
      },
      (entries) {
        final sorted = [...entries]
          ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
        emit(
          JournalEntriesListState.loaded(
            entries: newestFirst(sorted, (entry) => entry.id),
            statusFilter: _statusFilter,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            canCreate: canCreate,
          ),
        );
      },
    );
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    forgetCreated();
    await load();
  }

  Future<void> setDateRange({DateTime? from, DateTime? to}) async {
    _dateFrom = from;
    _dateTo = to;
    forgetCreated();
    await load();
  }

  Future<void> refresh() =>
      state is JournalEntriesListLoaded ? _read(quiet: true) : load();
}
