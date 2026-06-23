import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart'
    as customers_uc;
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomerPickerCubit extends Cubit<CustomerPickerState> {
  CustomerPickerCubit({
    required customers_uc.GetCustomersUseCase getCustomersUseCase,
    required customers_uc.CreateCustomerUseCase createCustomerUseCase,
  })  : _getCustomers = getCustomersUseCase,
        _createCustomer = createCustomerUseCase,
        super(const CustomerPickerState());

  final customers_uc.GetCustomersUseCase _getCustomers;
  final customers_uc.CreateCustomerUseCase _createCustomer;
  Timer? _debounce;

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

    if (trimmed.isEmpty) {
      _debounce = Timer(const Duration(milliseconds: 300), () {
        _fetchCustomers(search: null);
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 300), () {
      _fetchCustomers(search: trimmed);
    });
  }

  Future<void> _fetchCustomers({String? search}) async {
    emit(state.copyWith(isSearching: true, error: null));
    final result = await _getCustomers(search: search);
    result.fold(
      (failure) => emit(state.copyWith(
        isSearching: false,
        error: failure.message,
        results: [],
      )),
      (customers) => emit(state.copyWith(
        isSearching: false,
        results: customers,
      )),
    );
  }

  void showCreateForm() {
    emit(state.copyWith(showCreateForm: true));
  }

  Future<CustomerModel?> createCustomer({
    required String name,
    String? phone,
    String? email,
    String creditLimit = '0',
  }) async {
    emit(state.copyWith(isCreating: true, error: null));
    final result = await _createCustomer({
      'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      if (email != null && email.isNotEmpty) 'email': email,
      'credit_limit': creditLimit,
    });
    return result.fold(
      (failure) {
        emit(state.copyWith(isCreating: false, error: failure.message));
        return null;
      },
      (customer) {
        emit(state.copyWith(isCreating: false, results: [customer]));
        return customer;
      },
    );
  }

  void reset() {
    emit(const CustomerPickerState());
  }
}
