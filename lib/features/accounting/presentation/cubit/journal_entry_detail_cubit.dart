import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/accounting/data/models/journal_entry_list_model.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/presentation/cubit/journal_entry_detail_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class JournalEntryDetailCubit extends Cubit<JournalEntryDetailState> {
  JournalEntryDetailCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetJournalEntryUseCase getJournalEntryUseCase,
    required DeleteJournalEntryUseCase deleteJournalEntryUseCase,
    required PostJournalEntryUseCase postJournalEntryUseCase,
  })  : _authLocal = authLocalDataSource,
        _getEntry = getJournalEntryUseCase,
        _deleteEntry = deleteJournalEntryUseCase,
        _postEntry = postJournalEntryUseCase,
        super(const JournalEntryDetailState());

  final AuthLocalDataSource _authLocal;
  final GetJournalEntryUseCase _getEntry;
  final DeleteJournalEntryUseCase _deleteEntry;
  final PostJournalEntryUseCase _postEntry;

  Future<void> load(String entryId) async {
    emit(state.copyWith(isLoading: true, loadError: null));

    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(
        state.copyWith(
          isLoading: false,
          loadError: 'Permission denied',
        ),
      );
      return;
    }

    final canCreate = UserRoleUtils.canCreateJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
    final canPost = UserRoleUtils.canPostJournal(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );

    final result = await _getEntry(entryId);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, loadError: failure.message),
      ),
      (entry) => emit(
        state.copyWith(
          isLoading: false,
          entry: entry,
          canCreate: canCreate,
          canPost: canPost,
        ),
      ),
    );
  }

  Future<String?> deleteEntry() async {
    final entry = state.entry;
    if (entry == null || entry.status != JournalEntryStatus.draft) {
      return 'Cannot delete this entry';
    }
    if (!state.canCreate) return 'Permission denied';

    emit(state.copyWith(isDeleting: true));

    final result = await _deleteEntry(entry.id);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return null;
      },
    );
  }

  Future<String?> postEntry() async {
    final entry = state.entry;
    if (entry == null || entry.status != JournalEntryStatus.draft) {
      return 'Cannot post this entry';
    }
    if (!state.canPost) return 'Permission denied';

    emit(state.copyWith(isPosting: true));

    final result = await _postEntry(entry.id);
    return result.fold(
      (failure) {
        emit(state.copyWith(isPosting: false));
        return failure.message;
      },
      (posted) {
        emit(
          state.copyWith(
            isPosting: false,
            entry: posted,
          ),
        );
        return null;
      },
    );
  }
}
