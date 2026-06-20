import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:frantend/features/suppliers/presentation/cubit/supplier_form_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class SupplierFormCubit extends Cubit<SupplierFormState> {
  SupplierFormCubit({
    required GetSupplierUseCase getSupplierUseCase,
    required CreateSupplierUseCase createSupplierUseCase,
    required UpdateSupplierUseCase updateSupplierUseCase,
  })  : _getSupplier = getSupplierUseCase,
        _createSupplier = createSupplierUseCase,
        _updateSupplier = updateSupplierUseCase,
        super(const SupplierFormState());

  final GetSupplierUseCase _getSupplier;
  final CreateSupplierUseCase _createSupplier;
  final UpdateSupplierUseCase _updateSupplier;

  void initCreate() {
    emit(const SupplierFormState(mode: 'create'));
  }

  Future<void> loadForEdit(String supplierId) async {
    emit(state.copyWith(isLoading: true, mode: 'edit', supplierId: supplierId));

    final result = await _getSupplier(supplierId);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errors: {'_general': failure.message}),
      ),
      (supplier) => emit(
        SupplierFormState(
          mode: 'edit',
          supplierId: supplier.id,
          name: supplier.name,
          contactPerson: supplier.contactPerson ?? '',
          email: supplier.email ?? '',
          phone: supplier.phone ?? '',
          taxId: supplier.taxId ?? '',
          addressLine1: supplier.addressLine1 ?? '',
          city: supplier.city ?? '',
          paymentTermsDays: supplier.paymentTermsDays.toString(),
        ),
      ),
    );
  }

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateContactPerson(String value) =>
      emit(state.copyWith(contactPerson: value));
  void updateEmail(String value) => emit(state.copyWith(email: value));
  void updatePhone(String value) => emit(state.copyWith(phone: value));
  void updateTaxId(String value) => emit(state.copyWith(taxId: value));
  void updateAddressLine1(String value) =>
      emit(state.copyWith(addressLine1: value));
  void updateCity(String value) => emit(state.copyWith(city: value));
  void updatePaymentTermsDays(String value) =>
      emit(state.copyWith(paymentTermsDays: value));

  Map<String, dynamic> _toBody() {
    final terms = int.tryParse(state.paymentTermsDays.trim());
    return {
      'name': state.name.trim(),
      if (state.contactPerson.trim().isNotEmpty)
        'contact_person': state.contactPerson.trim(),
      if (state.email.trim().isNotEmpty) 'email': state.email.trim(),
      if (state.phone.trim().isNotEmpty) 'phone': state.phone.trim(),
      if (state.taxId.trim().isNotEmpty) 'tax_id': state.taxId.trim(),
      if (state.addressLine1.trim().isNotEmpty)
        'address_line1': state.addressLine1.trim(),
      if (state.city.trim().isNotEmpty) 'city': state.city.trim(),
      if (terms != null) 'payment_terms_days': terms,
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
    final body = _toBody();

    if (state.mode == 'create') {
      final result = await _createSupplier(body);
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

    final result = await _updateSupplier(state.supplierId!, body);
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
