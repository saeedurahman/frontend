import 'package:frantend/features/products/data/models/price_list_model.dart';

class CustomerFormState {
  const CustomerFormState({
    this.mode = 'create',
    this.customerId,
    this.name = '',
    this.phone = '',
    this.email = '',
    this.addressLine1 = '',
    this.city = '',
    this.creditLimit = '0.00',
    this.taxId = '',
    this.isActive = true,
    this.priceListId,
    this.availablePriceLists = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.errors = const {},
  });

  final String mode;
  final String? customerId;
  final String name;
  final String phone;
  final String email;
  final String addressLine1;
  final String city;
  final String creditLimit;
  final String taxId;
  final bool isActive;
  final String? priceListId;
  final List<PriceListModel> availablePriceLists;
  final bool isLoading;
  final bool isSubmitting;
  final Map<String, String> errors;

  CustomerFormState copyWith({
    String? mode,
    String? customerId,
    String? name,
    String? phone,
    String? email,
    String? addressLine1,
    String? city,
    String? creditLimit,
    String? taxId,
    bool? isActive,
    String? priceListId,
    bool clearPriceListId = false,
    List<PriceListModel>? availablePriceLists,
    bool? isLoading,
    bool? isSubmitting,
    Map<String, String>? errors,
  }) {
    return CustomerFormState(
      mode: mode ?? this.mode,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      addressLine1: addressLine1 ?? this.addressLine1,
      city: city ?? this.city,
      creditLimit: creditLimit ?? this.creditLimit,
      taxId: taxId ?? this.taxId,
      isActive: isActive ?? this.isActive,
      priceListId: clearPriceListId ? null : (priceListId ?? this.priceListId),
      availablePriceLists: availablePriceLists ?? this.availablePriceLists,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errors: errors ?? this.errors,
    );
  }
}
