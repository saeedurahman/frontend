import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/customers/domain/usecases/customer_usecases.dart';
import 'package:frantend/features/customers/presentation/cubit/customer_form_state.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class CustomerFormCubit extends Cubit<CustomerFormState> {
  CustomerFormCubit({
    required GetCustomerUseCase getCustomerUseCase,
    required CreateCustomerUseCase createCustomerUseCase,
    required UpdateCustomerUseCase updateCustomerUseCase,
    ProductsRepository? productsRepository,
  })  : _getCustomer = getCustomerUseCase,
        _createCustomer = createCustomerUseCase,
        _updateCustomer = updateCustomerUseCase,
        _productsRepository = productsRepository ??
            (sl.isRegistered<ProductsRepository>()
                ? sl<ProductsRepository>()
                : null),
        super(const CustomerFormState());

  final GetCustomerUseCase _getCustomer;
  final CreateCustomerUseCase _createCustomer;
  final UpdateCustomerUseCase _updateCustomer;
  final ProductsRepository? _productsRepository;

  Future<void> _loadPriceLists() async {
    if (_productsRepository != null) {
      final res = await _productsRepository.getPriceLists();
      res.fold((_) {}, (lists) {
        if (!isClosed) {
          emit(state.copyWith(availablePriceLists: lists));
        }
      });
    }
  }

  void initCreate() {
    emit(
      CustomerFormState(
        creditLimit: DecimalUtils.format(Decimal.zero),
      ),
    );
    _loadPriceLists();
  }

  Future<void> loadForEdit(String customerId) async {
    emit(
      state.copyWith(isLoading: true, mode: 'edit', customerId: customerId),
    );

    final result = await _getCustomer(customerId);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errors: {'_general': failure.message}),
      ),
      (customer) {
        emit(
          CustomerFormState(
            mode: 'edit',
            customerId: customer.id,
            name: customer.name,
            phone: customer.phone ?? '',
            email: customer.email ?? '',
            addressLine1: customer.addressLine1 ?? '',
            city: customer.city ?? '',
            creditLimit: customer.creditLimit,
            taxId: customer.taxId ?? '',
            isActive: customer.isActive,
            priceListId: customer.priceListId,
          ),
        );
        _loadPriceLists();
      },
    );
  }

  void updateName(String value) => emit(state.copyWith(name: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updateAddressLine1(String value) =>
      emit(state.copyWith(addressLine1: value));
  void updateCity(String value) => emit(state.copyWith(city: value));
  void updateCreditLimit(String value) =>
      emit(state.copyWith(creditLimit: value));
  void updateTaxId(String value) => emit(state.copyWith(taxId: value));
  void updateIsActive(bool value) => emit(state.copyWith(isActive: value));
  void updatePriceListId(String? value) {
    if (value == null) {
      emit(state.copyWith(clearPriceListId: true));
    } else {
      emit(state.copyWith(priceListId: value));
    }
  }

  Map<String, dynamic> _toCreateBody() {
    final creditLimit = Decimal.tryParse(state.creditLimit.trim()) ??
        Decimal.zero;
    return {
      'name': state.name.trim(),
      'credit_limit': DecimalUtils.format(creditLimit),
      if (state.phone.trim().isNotEmpty) 'phone': state.phone.trim(),
      if (state.email.trim().isNotEmpty) 'email': state.email.trim(),
      if (state.addressLine1.trim().isNotEmpty)
        'address_line1': state.addressLine1.trim(),
      if (state.city.trim().isNotEmpty) 'city': state.city.trim(),
      if (state.taxId.trim().isNotEmpty) 'tax_id': state.taxId.trim(),
      if (state.priceListId != null) 'price_list_id': state.priceListId,
    };
  }

  Map<String, dynamic> _toUpdateBody() {
    final creditLimit = Decimal.tryParse(state.creditLimit.trim()) ??
        Decimal.zero;
    return {
      'name': state.name.trim(),
      'credit_limit': DecimalUtils.format(creditLimit),
      'is_active': state.isActive,
      'price_list_id': state.priceListId,
      if (state.phone.trim().isNotEmpty) 'phone': state.phone.trim(),
      if (state.email.trim().isNotEmpty) 'email': state.email.trim(),
    };
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.name.trim().isEmpty) {
      errors['name'] = 'Name is required';
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Future<String?> submit() async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));

    if (state.mode == 'create') {
      final result = await _createCustomer(_toCreateBody());
      return result.fold(
        (failure) {
          emit(state.copyWith(isSubmitting: false));
          return failure.message;
        },
        (_) {
          emit(state.copyWith(isSubmitting: false));
          return null;
        },
      );
    }

    final result = await _updateCustomer(state.customerId!, _toUpdateBody());
    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return null;
      },
    );
  }
}
