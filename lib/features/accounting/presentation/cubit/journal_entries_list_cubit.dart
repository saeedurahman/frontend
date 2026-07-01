import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entries_list_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class JournalEntriesListCubit extends Cubit<JournalEntriesListState> {
  JournalEntriesListCubit({
    required ListJournalEntriesUseCase listJournalEntriesUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _listEntries = listJournalEntriesUseCase,
        _authLocal = authLocalDataSource,
        super(const JournalEntriesListState.initial());

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

  Future<void> load() async {
    emit(const JournalEntriesListState.loading());

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

    result.fold(
      (failure) => emit(JournalEntriesListState.error(failure.message)),
      (entries) {
        final sorted = [...entries]
          ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
        emit(
          JournalEntriesListState.loaded(
            entries: sorted,
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
    await load();
  }

  Future<void> setDateRange({DateTime? from, DateTime? to}) async {
    _dateFrom = from;
    _dateTo = to;
    await load();
  }

  Future<void> refresh() => load();
}
