import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/features/audit/domain/usecases/audit_usecases.dart';
import 'package:frantend/features/audit/presentation/cubit/audit_logs_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

class AuditAccessDeniedException implements Exception {
  const AuditAccessDeniedException();
}

@injectable
class AuditLogsCubit extends Cubit<AuditLogsState> {
  AuditLogsCubit(this._useCases, this._authLocal) : super(const AuditLogsInitial());

  final AuditUseCases _useCases;
  final AuthLocalDataSource _authLocal;

  static const _pageSize = 50;

  AuditLogsFilters _filters = _defaultFilters();

  static AuditLogsFilters _defaultFilters() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return AuditLogsFilters(
      dateFrom: today.subtract(const Duration(days: 6)),
      dateTo: today,
      datePreset: AuditDatePreset.last7Days,
    );
  }

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.isOwner(user?.role)) {
      emit(const AuditLogsAccessDenied());
      return;
    }
    await loadLogs(reset: true);
  }

  Future<void> loadLogs({bool reset = true}) async {
    if (state is AuditLogsAccessDenied) return;

    if (reset) {
      emit(AuditLogsLoading(filters: _filters));
    } else {
      final current = state;
      if (current is AuditLogsLoaded) {
        emit(current.copyWith(isLoadingMore: true));
      }
    }

    final skip = reset
        ? 0
        : switch (state) {
            AuditLogsLoaded(:final skip, :final limit) => skip + limit,
            _ => 0,
          };

    try {
      final page = await _unwrap(
        _useCases.getAuditLogs(
          userId: _filters.userId,
          action: _filters.action,
          tableName: _filters.tableName,
          dateFrom: _filters.dateFrom,
          dateTo: _filters.dateTo,
          skip: skip,
          limit: _pageSize,
        ),
      );

      if (reset) {
        emit(
          AuditLogsLoaded(
            logs: page.items,
            total: page.total,
            skip: page.skip,
            limit: page.limit,
            filters: _filters,
          ),
        );
      } else {
        final current = state;
        if (current is AuditLogsLoaded) {
          emit(
            current.copyWith(
              logs: [...current.logs, ...page.items],
              total: page.total,
              skip: page.skip,
              limit: page.limit,
              isLoadingMore: false,
            ),
          );
        }
      }
    } on AuditAccessDeniedException {
      emit(const AuditLogsAccessDenied());
    } catch (e) {
      emit(AuditLogsError(e.toString(), filters: _filters));
    }
  }

  Future<void> applyFilters(AuditLogsFilters filters) async {
    _filters = filters;
    await loadLogs(reset: true);
  }

  Future<void> clearFilters() async {
    _filters = _defaultFilters();
    await loadLogs(reset: true);
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! AuditLogsLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }
    await loadLogs(reset: false);
  }

  Future<void> refresh() => loadLogs(reset: true);

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
