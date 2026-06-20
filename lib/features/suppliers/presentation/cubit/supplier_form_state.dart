import 'package:freezed_annotation/freezed_annotation.dart';

part 'supplier_form_state.freezed.dart';

@freezed
class SupplierFormState with _$SupplierFormState {
  const factory SupplierFormState({
    @Default('create') String mode,
    String? supplierId,
    @Default('') String name,
    @Default('') String contactPerson,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String taxId,
    @Default('') String addressLine1,
    @Default('') String city,
    @Default('30') String paymentTermsDays,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default({}) Map<String, String> errors,
  }) = _SupplierFormState;
}
