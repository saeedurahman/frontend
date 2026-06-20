import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/pos/data/models/customer_model.dart';
import 'package:frantend/features/pos/domain/usecases/pos_usecases.dart';
import 'package:frantend/features/pos/presentation/cubit/customer_picker_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomerPickerCubit extends Cubit<CustomerPickerState> {
  CustomerPickerCubit({
    required SearchCustomersUseCase searchCustomersUseCase,
    required CreateCustomerUseCase createCustomerUseCase,
  })  : _searchCustomers = searchCustomersUseCase,
        _createCustomer = createCustomerUseCase,
        super(const CustomerPickerState());

  final SearchCustomersUseCase _searchCustomers;
  final CreateCustomerUseCase _createCustomer;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query, showCreateForm: false));
    _debounce?.cancel();
    if (query.length < 2) {
      emit(state.copyWith(results: [], isSearching: false));
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      emit(state.copyWith(isSearching: true, error: null));
      final result = await _searchCustomers(query);
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
    });
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
