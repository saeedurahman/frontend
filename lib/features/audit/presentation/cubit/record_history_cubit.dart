import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/audit/domain/usecases/audit_usecases.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_cubit.dart';
import 'package:frantend/features/audit/presentation/cubit/record_history_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class RecordHistoryCubit extends Cubit<RecordHistoryState> {
  RecordHistoryCubit(this._useCases, this._authLocal)
      : super(const RecordHistoryInitial());

  final AuditUseCases _useCases;
  final AuthLocalDataSource _authLocal;

  static const _pageSize = 50;

  String? _tableName;
  String? _recordId;

  Future<void> init(String tableName, String recordId) async {
    _tableName = tableName;
    _recordId = recordId;

    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.isOwner(user?.role)) {
      emit(const RecordHistoryAccessDenied());
      return;
    }
    await load(reset: true);
  }

  Future<void> load({bool reset = true}) async {
    final tableName = _tableName;
    final recordId = _recordId;
    if (tableName == null || recordId == null) return;
    if (state is RecordHistoryAccessDenied) return;

    if (reset) {
      emit(const RecordHistoryLoading());
    } else {
      final current = state;
      if (current is RecordHistoryLoaded) {
        emit(RecordHistoryLoaded(
          logs: current.logs,
          total: current.total,
          skip: current.skip,
          limit: current.limit,
          isLoadingMore: true,
        ));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            RecordHistoryLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    try {
      final page = await _unwrap(
        _useCases.getRecordHistory(
          tableName,
          recordId,
          skip: skip,
          limit: _pageSize,
        ),
      );

      if (reset) {
        emit(
          RecordHistoryLoaded(
            logs: page.items,
            total: page.total,
            skip: page.skip,
            limit: page.limit,
          ),
        );
      } else {
        final current = state;
        if (current is RecordHistoryLoaded) {
          emit(
            RecordHistoryLoaded(
              logs: [...current.logs, ...page.items],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
            ),
          );
        }
      }
    } on AuditAccessDeniedException {
      emit(const RecordHistoryAccessDenied());
    } catch (e) {
      emit(RecordHistoryError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! RecordHistoryLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }
    await load(reset: false);
  }

  Future<T> _unwrap<T>(Future<Either<Failure, T>> call) async {
    final result = await call;
    return result.fold(
      (failure) {
        if (failure is AuthFailure) {
          throw const AuditAccessDeniedException();
        }
        throw Exception(failure.message);
      },
      (value) => value,
    );
  }
}
