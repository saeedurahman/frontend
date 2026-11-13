import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/user_error_message.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_state.dart';
import 'package:injectable/injectable.dart';

/// POS customer picker.
///
/// Local-first: the list and the search read the customers on this device,
/// and a quick-create is one local write + outbox op. Nothing here waits for
/// the server, so nothing here can show a connection error; a customer that
/// has not reached the server yet is marked "Not synced yet".
@injectable
class CustomerPickerCubit extends Cubit<CustomerPickerState> {
  CustomerPickerCubit({
    required customers_uc.GetCustomersUseCase getCustomersUseCase,
    required customers_uc.CreateCustomerUseCase createCustomerUseCase,
    Future<Set<String>> Function()? unsyncedCustomerIds,
  })  : _getCustomers = getCustomersUseCase,
        _createCustomer = createCustomerUseCase,
        _unsyncedCustomerIds = unsyncedCustomerIds,
        super(const CustomerPickerState());

  final customers_uc.GetCustomersUseCase _getCustomers;
  final customers_uc.CreateCustomerUseCase _createCustomer;
  final Future<Set<String>> Function()? _unsyncedCustomerIds;
  Timer? _debounce;

  /// Only the newest search may publish its result.
  int _searchId = 0;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> loadInitial() => _fetchCustomers(search: null);

  void search(String query) {
    final trimmed = query.trim();
    emit(state.copyWith(searchQuery: query, showCreateForm: false, error: null));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchCustomers(search: trimmed.isEmpty ? null : trimmed);
    });
  }

  Future<Set<String>> _unsynced() async {
    try {
      return await _unsyncedCustomerIds?.call() ?? const <String>{};
    } catch (_) {
      return const <String>{};
    }
  }

  Future<void> _fetchCustomers({String? search}) async {
    final searchId = ++_searchId;
    emit(state.copyWith(isSearching: true, error: null));
    final result = await _getCustomers(search: search);
    final unsynced = await _unsynced();
    // A slower, older search (or one that finished after a customer was
    // created) must not overwrite what is on screen.
    if (isClosed || searchId != _searchId) return;
    result.fold(
      (failure) => emit(state.copyWith(
        isSearching: false,
        error: UserErrorMessage.from(failure),
        results: [],
      )),
      (customers) => emit(state.copyWith(
        isSearching: false,
        results: customers,
        unsyncedIds: unsynced,
      )),
    );
  }

  void showCreateForm() {
    // Whatever an earlier search reported has nothing to do with the form.
    emit(state.copyWith(showCreateForm: true, error: null));
  }

  Future<CustomerModel?> createCustomer({
    required String name,
    String? phone,
    String? email,
    String creditLimit = '0',
  }) async {
    if (name.trim().isEmpty) {
      emit(state.copyWith(error: 'Enter the customer name'));
      return null;
    }
    // A search still on its way must not report into the create form.
    _debounce?.cancel();
    _searchId++;
    emit(state.copyWith(isCreating: true, isSearching: false, error: null));
    final result = await _createCustomer({
      'name': name.trim(),
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      'credit_limit': creditLimit.trim().isEmpty ? '0' : creditLimit.trim(),
    });
    final unsynced = await _unsynced();
    if (isClosed) return result.fold((_) => null, (c) => c);
    return result.fold(
      (failure) {
        emit(state.copyWith(
          isCreating: false,
          error: UserErrorMessage.from(failure),
        ));
        return null;
      },
      (customer) {
        emit(state.copyWith(
          isCreating: false,
          showCreateForm: false,
          error: null,
          results: [customer],
          unsyncedIds: {...unsynced, if (_unsyncedCustomerIds != null) customer.id},
        ));
        return customer;
      },
    );
  }

  void reset() {
    _debounce?.cancel();
    _searchId++;
    emit(const CustomerPickerState());
  }
}
