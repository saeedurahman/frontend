import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_form_state.freezed.dart';

@freezed
class VariationFormItem with _$VariationFormItem {
  const factory VariationFormItem({
    String? id,
    @Default('') String name,
    String? sku,
    String? unitId,
    @Default(false) bool isDefault,
    String? weightGrams,
    @Default(true) bool isActive,
  }) = _VariationFormItem;
}

@freezed
class BarcodeFormItem with _$BarcodeFormItem {
  const factory BarcodeFormItem({
    String? id,
    @Default('') String barcode,
    @Default('EAN13') String barcodeType,
    String? variationId,
    @Default(false) bool isPrimary,
  }) = _BarcodeFormItem;
}

@freezed
class ProductFormState with _$ProductFormState {
  const factory ProductFormState({
    @Default('create') String mode,
    String? productId,
    @Default('') String name,
    String? sku,
    String? description,
    String? imageUrl,
    String? localImagePath,
    String? selectedCategoryId,
    String? selectedBrandId,
    String? selectedBaseUnitId,
    @Default('standard') String productType,
    @Default('none') String trackingType,
    @Default(true) bool isSellable,
    @Default(true) bool isPurchasable,
    @Default(true) bool isActive,
    int? shelfLifeDays,
    String? minStockLevel,
    String? maxStockLevel,
    @Default([]) List<VariationFormItem> variations,
    @Default([]) List<BarcodeFormItem> barcodes,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isUploadingImage,
    String? imageUploadError,
    @Default(false) bool canManagePrices,
    String? retailUnitPrice,
    String? minQty,
    String? defaultPriceListId,
    String? priceListItemId,
    @Default(false) bool isLoadingPrice,
    @Default(false) bool isSavingPrice,
    String? priceError,
    @Default(false) bool priceSaveSuccess,
    @Default({}) Map<String, String> errors,
  }) = _ProductFormState;
}
