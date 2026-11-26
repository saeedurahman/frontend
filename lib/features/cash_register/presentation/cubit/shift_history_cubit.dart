import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/data_changes/auto_refresh.dart';
import 'package:frantend/core/data_changes/data_change_bus.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/cash_register/data/models/register_shift_model.dart';
import 'package:frantend/features/cash_register/domain/usecases/cash_register_usecases.dart';
import 'package:frantend/features/cash_register/presentation/cubit/shift_history_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShiftHistoryCubit extends Cubit<ShiftHistoryState>
    with AutoRefresh<ShiftHistoryState> {
  ShiftHistoryCubit({
    required GetRegisterShiftsUseCase getShiftsUseCase,
    required GetCashRegistersUseCase getRegistersUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getShifts = getShiftsUseCase,
        _getRegisters = getRegistersUseCase,
        _authLocal = authLocalDataSource,
        super(const ShiftHistoryState()) {
    watchData(const {DataTopic.shifts}, _reload);
  }

  static const _maxLimit = 200;
  bool _started = false;

  final GetRegisterShiftsUseCase _getShifts;
  final GetCashRegistersUseCase _getRegisters;
  final AuthLocalDataSource _authLocal;

  static const _pageSize = 50;

  String? _branchId;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewShifts(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(state.copyWith(accessDenied: true));
      return;
    }

    _branchId = user?.branchId;

    if (_branchId == null) {
      emit(state.copyWith(error: 'Branch not configured. Please re-login.'));
      return;
    }

    final registersResult = await _getRegisters(branchId: _branchId);
    registersResult.fold(
      (failure) => emit(state.copyWith(error: failure.message)),
      (registers) => emit(state.copyWith(registers: registers)),
    );

    await load();
  }

  Future<void> load() async {
    if (_branchId == null) return;

    _started = true;
    final read = beginRead();
    emit(state.copyWith(isLoading: true, error: null, skip: 0));

    final result = await _getShifts(
      branchId: _branchId,
      registerId: state.selectedRegisterId,
      status: 'closed',
      skip: 0,
      limit: _pageSize,
    );
    if (isStale(read)) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (shifts) {
        final filtered = _applyDateFilter(shifts);
        emit(
          state.copyWith(
            isLoading: false,
            shifts: filtered,
            hasMore: shifts.length >= _pageSize,
            skip: shifts.length,
          ),
        );
      },
    );
  }

  /// A quiet re-read after a shift changed: as many rows as were read before.
  Future<void> _reload() async {
    if (!_started) return;
    if (state.isLoading || state.error != null) return load();
    final read = beginRead();
    final wanted = state.skip > _pageSize ? state.skip : _pageSize;
    final rows = <RegisterShiftModel>[];
    var hasMore = false;
    while (rows.length < wanted) {
      final size = (wanted - rows.length).clamp(1, _maxLimit);
      final result = await _getShifts(
        branchId: _branchId,
        registerId: state.selectedRegisterId,
        status: 'closed',
        skip: rows.length,
        limit: size,
      );
      if (isStale(read)) return;
      final page = result.fold((_) => null, (p) => p);
      if (page == null) {
        // This read replaced a "load more" in flight.
        emit(state.copyWith(isLoadingMore: false));
        return;
      }
      rows.addAll(page);
      hasMore = page.length >= size;
      if (!hasMore) break;
    }
    emit(
      state.copyWith(
        isLoadingMore: false,
        shifts: _applyDateFilter(rows),
        hasMore: hasMore,
        skip: rows.length,
      ),
    );
  }

  Future<void> loadMore() async {
    if (_branchId == null || !state.hasMore || state.isLoadingMore) return;

    final read = beginRead();
    emit(state.copyWith(isLoadingMore: true));

    final result = await _getShifts(
      branchId: _branchId,
      registerId: state.selectedRegisterId,
      status: 'closed',
      skip: state.skip,
      limit: _pageSize,
    );
    if (isStale(read)) return;

    result.fold(
      (failure) => emit(state.copyWith(isLoadingMore: false, error: failure.message)),
      (shifts) {
        final filtered = _applyDateFilter(shifts);
        emit(
          state.copyWith(
            isLoadingMore: false,
            shifts: [...state.shifts, ...filtered],
            hasMore: shifts.length >= _pageSize,
            skip: state.skip + shifts.length,
          ),
        );
      },
    );
  }

  Future<void> setRegisterFilter(String? registerId) async {
    emit(state.copyWith(selectedRegisterId: registerId));
    await load();
  }

  Future<void> setDatePreset(ShiftDatePreset preset) async {
    emit(
      state.copyWith(
        datePreset: preset,
        customDateFrom: null,
        customDateTo: null,
      ),
    );
    await load();
  }

  Future<void> setCustomDateRange(DateTime? from, DateTime? to) async {
    emit(
      state.copyWith(
        datePreset: ShiftDatePreset.all,
        customDateFrom: from,
        customDateTo: to,
      ),
    );
    await load();
  }

  List<RegisterShiftModel> _applyDateFilter(List<RegisterShiftModel> shifts) {
    final range = _dateRange();
    if (range == null) return shifts;

    return shifts.where((shift) {
      final openedAt = shift.openedAt;
      if (openedAt == null) return true;
      try {
        final dt = DateTime.parse(openedAt).toLocal();
        if (range.$1 != null && dt.isBefore(range.$1!)) return false;
        if (range.$2 != null && dt.isAfter(range.$2!)) return false;
        return true;
      } catch (_) {
        return true;
      }
    }).toList();
  }

  (DateTime?, DateTime?)? _dateRange() {
    final now = DateTime.now();
    final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return switch (state.datePreset) {
      ShiftDatePreset.today => (
          DateTime(now.year, now.month, now.day),
          endOfToday,
        ),
      ShiftDatePreset.last7Days => (
          DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6)),
          endOfToday,
        ),
      ShiftDatePreset.last30Days => (
          DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29)),
          endOfToday,
        ),
      ShiftDatePreset.all => state.customDateFrom == null &&
              state.customDateTo == null
          ? null
          : (state.customDateFrom, state.customDateTo),
    };
  }

  String? registerName(String registerId) {
    for (final register in state.registers) {
      if (register.id == registerId) return register.name;
    }
    return null;
  }
}
