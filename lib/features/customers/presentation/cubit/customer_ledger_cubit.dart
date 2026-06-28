import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/customers/data/models/customer_ledger_entry_model.dart';
import 'package:frantend/features/customers/data/models/customer_payment_response_model.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/domain/usecases/record_customer_payment_usecase.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_ledger_state.dart';
import 'package:frantend/features/customers/presentation/utils/customer_balance_utils.dart';
import 'package:frantend/features/pos/data/models/payment_line_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/shared/widgets/tables/client_table_pagination.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomerLedgerCubit extends Cubit<CustomerLedgerState> {
  CustomerLedgerCubit({
    required GetCustomerUseCase getCustomerUseCase,
    required GetCustomerBalanceUseCase getCustomerBalanceUseCase,
    required GetCustomerLedgerUseCase getCustomerLedgerUseCase,
    required RecordCustomerPaymentUseCase recordCustomerPaymentUseCase,
    required GetActiveShiftUseCase getActiveShiftUseCase,
    required GetRegistersUseCase getRegistersUseCase,
    required AuthLocalDataSource authLocalDataSource,
  })  : _getCustomer = getCustomerUseCase,
        _getBalance = getCustomerBalanceUseCase,
        _getLedger = getCustomerLedgerUseCase,
        _recordPayment = recordCustomerPaymentUseCase,
        _getActiveShift = getActiveShiftUseCase,
        _getRegisters = getRegistersUseCase,
        _authLocal = authLocalDataSource,
        super(const CustomerLedgerState.initial());

  static const _defaultPageSize = 10;
  static const _fetchSize = 50;

  int _pageSize = _defaultPageSize;

  final GetCustomerUseCase _getCustomer;
  final GetCustomerBalanceUseCase _getBalance;
  final GetCustomerLedgerUseCase _getLedger;
  final RecordCustomerPaymentUseCase _recordPayment;
  final GetActiveShiftUseCase _getActiveShift;
  final GetRegistersUseCase _getRegisters;
  final AuthLocalDataSource _authLocal;

  String? _customerId;
  List<CustomerLedgerEntryModel> _allEntries = [];

  int paginationTotal(CustomerLedgerLoaded state) {
    if (state.hasMore) {
      return state.entries.length + state.pageSize;
    }
    return state.entries.length;
  }

  int totalPages(CustomerLedgerLoaded state) {
    return ClientTablePagination.totalPages(
      paginationTotal(state),
      state.pageSize,
    );
  }

  Future<void> setPageSize(int size) async {
    if (size < 1) return;
    final current = state;
    if (current is! CustomerLedgerLoaded || current.pageSize == size) return;
    _pageSize = size;
    emit(current.copyWith(pageSize: size, currentPage: 1));
  }

  Future<void> goToPage(int page) async {
    final current = state;
    if (current is! CustomerLedgerLoaded) return;

    final target = page.clamp(1, totalPages(current));
    if (target == current.currentPage) return;

    final needed = target * _pageSize;
    while (_allEntries.length < needed) {
      final latest = state;
      if (latest is! CustomerLedgerLoaded ||
          !latest.hasMore ||
          latest.isLoadingMore) {
        break;
      }
      await _fetchMore();
    }

    final updated = state;
    if (updated is CustomerLedgerLoaded) {
      emit(updated.copyWith(currentPage: target));
    }
  }

  void clearPaymentError() {
    final current = state;
    if (current is CustomerLedgerLoaded) {
      emit(current.copyWith(paymentError: null));
    }
  }

  Future<void> checkPaymentShift() async {
    final current = state;
    if (current is! CustomerLedgerLoaded) return;

    emit(
      current.copyWith(
        isCheckingPaymentShift: true,
        activePaymentShiftId: null,
      ),
    );

    final shiftId = await _resolveActiveShiftId();

    final updated = state;
    if (updated is CustomerLedgerLoaded) {
      emit(
        updated.copyWith(
          isCheckingPaymentShift: false,
          activePaymentShiftId: shiftId,
        ),
      );
    }
  }

  Future<String?> _resolveActiveShiftId() async {
    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;
    if (branchId == null) return null;

    final registersResult = await _getRegisters(branchId: branchId);
    return registersResult.fold(
      (_) async => null,
      (registers) async {
        if (registers.isEmpty) return null;
        final shiftResult = await _getActiveShift(registers.first.id);
        return shiftResult.fold((_) => null, (shift) => shift?.id);
      },
    );
  }

  Future<void> load(String customerId) async {
    _customerId = customerId;
    _allEntries = [];
    _pageSize = _defaultPageSize;
    emit(const CustomerLedgerState.loading());

    final customerResult = await _getCustomer(customerId);
    await customerResult.fold(
      (failure) async => emit(CustomerLedgerState.error(failure.message)),
      (customer) async {
        final balanceResult = await _getBalance(customerId);
        final ledgerResult =
            await _getLedger(customerId, skip: 0, limit: _fetchSize);

        balanceResult.fold(
          (failure) => emit(CustomerLedgerState.error(failure.message)),
          (balance) {
            ledgerResult.fold(
              (failure) => emit(CustomerLedgerState.error(failure.message)),
              (page) {
                _allEntries = page;
                emit(
                  CustomerLedgerState.loaded(
                    customer: customer,
                    balance: balance.balance,
                    entries: _computeDisplayRows(_allEntries),
                    hasMore: page.length >= _fetchSize,
                    currentPage: 1,
                    pageSize: _pageSize,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<CustomerPaymentResponseModel?> recordPayment({
    required Decimal amount,
    required String paymentMethod,
    String? referenceNo,
    String? notes,
  }) async {
    final current = state;
    if (current is! CustomerLedgerLoaded || _customerId == null) return null;

    emit(
      current.copyWith(
        isRecordingPayment: true,
        paymentError: null,
      ),
    );

    String? registerShiftId;
    if (paymentMethod == PaymentMethods.cash) {
      registerShiftId = await _resolveActiveShiftId();
    }

    final result = await _recordPayment(
      _customerId!,
      amount: amount,
      paymentMethod: paymentMethod,
      referenceNo: referenceNo,
      notes: notes,
      registerShiftId: registerShiftId,
    );

    return await result.fold(
      (failure) async {
        emit(
          current.copyWith(
            isRecordingPayment: false,
            paymentError: failure.message,
          ),
        );
        return null;
      },
      (response) async {
        _allEntries = [];
        final ledgerResult =
            await _getLedger(_customerId!, skip: 0, limit: _fetchSize);

        ledgerResult.fold(
          (failure) {
            emit(
              current.copyWith(
                balance: response.newBalance,
                isRecordingPayment: false,
                paymentError: failure.message,
              ),
            );
          },
          (page) {
            _allEntries = page;
            emit(
              current.copyWith(
                balance: response.newBalance,
                entries: _computeDisplayRows(_allEntries),
                hasMore: page.length >= _fetchSize,
                isRecordingPayment: false,
                paymentError: null,
                activePaymentShiftId: registerShiftId,
                currentPage: 1,
                pageSize: _pageSize,
              ),
            );
          },
        );
        return response;
      },
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! CustomerLedgerLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        _customerId == null) {
      return;
    }
    await _fetchMore();
  }

  Future<void> _fetchMore() async {
    final current = state;
    if (current is! CustomerLedgerLoaded ||
        !current.hasMore ||
        current.isLoadingMore ||
        _customerId == null) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final result = await _getLedger(
      _customerId!,
      skip: _allEntries.length,
      limit: _fetchSize,
    );

    result.fold(
      (failure) {
        emit(current.copyWith(isLoadingMore: false));
        emit(CustomerLedgerState.error(failure.message));
      },
      (page) {
        _allEntries = [..._allEntries, ...page];
        emit(
          current.copyWith(
            entries: _computeDisplayRows(_allEntries),
            isLoadingMore: false,
            hasMore: page.length >= _fetchSize,
          ),
        );
      },
    );
  }

  List<LedgerDisplayRow> _computeDisplayRows(
    List<CustomerLedgerEntryModel> entries,
  ) {
    final sorted = [...entries];
    sorted.sort((a, b) {
      final aAt = a.entryAt ?? a.createdAt ?? '';
      final bAt = b.entryAt ?? b.createdAt ?? '';
      return aAt.compareTo(bAt);
    });

    var running = Decimal.zero;
    final withRunning = <({CustomerLedgerEntryModel entry, String running})>[];
    for (final entry in sorted) {
      running = running + CustomerBalanceUtils.parseBalance(entry.amount);
      withRunning.add((
        entry: entry,
        running: DecimalUtils.format(running),
      ));
    }

    return withRunning.reversed
        .map(
          (row) => LedgerDisplayRow(
            entry: row.entry,
            runningBalance: row.running,
          ),
        )
        .toList();
  }
}
