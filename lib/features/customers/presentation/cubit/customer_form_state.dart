import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_form_state.freezed.dart';

@freezed
class CustomerFormState with _$CustomerFormState {
  const factory CustomerFormState({
    @Default('create') String mode,
    String? customerId,
    @Default('') String name,
    @Default('') String phone,
    @Default('') String email,
    @Default('') String addressLine1,
    @Default('') String city,
    @Default('0.00') String creditLimit,
    @Default('') String taxId,
    @Default(true) bool isActive,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default({}) Map<String, String> errors,
  }) = _CustomerFormState;
}
