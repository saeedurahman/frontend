import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/core/utils/logger.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/product_pricing_usecases.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/utils/variation_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:frantend/core/platform/image_picker_service.dart';

@injectable
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required GetProductByIdUseCase getProductByIdUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required AddVariationUseCase addVariationUseCase,
    required AddBarcodeUseCase addBarcodeUseCase,
    required GetPriceListsUseCase getPriceListsUseCase,
    required GetProductPriceUseCase getProductPriceUseCase,
    required SetProductPriceUseCase setProductPriceUseCase,
    required ImageUploadService imageUploadService,
    required AuthLocalDataSource authLocalDataSource,
    ImagePickerService? imagePickerService,
    Future<String?> Function()? localDefaultPriceListId,
    Future<void> Function(Map<String, dynamic> priceListItem)? onPriceSaved,
  })  : _localDefaultPriceListId = localDefaultPriceListId,
        _onPriceSaved = onPriceSaved,
        _getProductById = getProductByIdUseCase,
        _createProduct = createProductUseCase,
        _updateProduct = updateProductUseCase,
        _addVariation = addVariationUseCase,
        _addBarcode = addBarcodeUseCase,
        _getPriceLists = getPriceListsUseCase,
        _getProductPrice = getProductPriceUseCase,
        _setProductPrice = setProductPriceUseCase,
        _imageUpload = imageUploadService,
        _authLocal = authLocalDataSource,
        _imagePicker = imagePickerService ?? const WindowsImagePickerService(),
        super(const ProductFormState());

  final GetProductByIdUseCase _getProductById;
  final CreateProductUseCase _createProduct;
  final UpdateProductUseCase _updateProduct;
  final AddVariationUseCase _addVariation;
  final AddBarcodeUseCase _addBarcode;
  final GetPriceListsUseCase _getPriceLists;
  final GetProductPriceUseCase _getProductPrice;
  final SetProductPriceUseCase _setProductPrice;
  final ImageUploadService _imageUpload;
  final AuthLocalDataSource _authLocal;

  /// Default price list from the pulled (local) data, if wired.
  final Future<String?> Function()? _localDefaultPriceListId;

  /// Called after a price was saved, with the saved `price_list_item` (same
  /// keys as the sync feed), so the local copy (POS, product lists) has it at
  /// once and a pull can follow.
  final Future<void> Function(Map<String, dynamic> priceListItem)? _onPriceSaved;
  final ImagePickerService _imagePicker;

  Future<bool> _canManagePrices() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canManagePrices(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  String? _defaultVariationId() {
    final withId = state.variations.where((v) => v.id != null).toList();
    if (withId.isEmpty) return null;
    final defaultVar = withId.cast<VariationFormItem?>().firstWhere(
          (v) => v!.isDefault,
          orElse: () => withId.first,
        );
    return defaultVar?.id;
  }

  /// Resolves the default retail price list: cache -> local data -> server list
  /// -> ask the server to create it. Returns the server's message when it fails,
  /// so the user sees the real reason instead of a generic error.
  Future<({String? id, String? error})> _resolveDefaultPriceList() async {
    if (state.defaultPriceListId != null) {
      return (id: state.defaultPriceListId, error: null);
    }

    try {
      final local = await _localDefaultPriceListId?.call();
      if (local != null) return (id: local, error: null);
      AppLogger.debug('Price list lookup: none in local data (price_list entity empty)');
    } catch (e) {
      AppLogger.warning('Price list lookup: local read failed (${e.runtimeType})');
    }

    String? error;
    final listsResult = await _getPriceLists();
    final online = listsResult.fold<String?>(
      (failure) {
        error = failure.message;
        AppLogger.warning('Price list lookup: GET /prices/lists failed: ${failure.message}');
        return null;
      },
      (lists) {
        if (lists.isEmpty) return null;
        return lists.firstWhere((l) => l.isDefault, orElse: () => lists.first).id;
      },
    );
    if (online != null) return (id: online, error: null);
    if (error != null) return (id: null, error: error);

    AppLogger.warning('Price list lookup: server has none, creating default');
    final created = await _getPriceLists.createDefault();
    return created.fold(
      (failure) {
        AppLogger.warning('Price list create failed: ${failure.message}');
        return (id: null, error: failure.message);
      },
      (list) => (id: list.id, error: null),
    );
  }

  void clearPriceSaveSuccess() =>
      emit(state.copyWith(priceSaveSuccess: false));

  Future<void> loadProductPrice() async {
    final productId = state.productId;
    if (productId == null) return;

    emit(state.copyWith(isLoadingPrice: true, priceError: null));

    final variationId = _defaultVariationId();
    final priceResult = await _getProductPrice(
      productId,
      variationId: variationId,
    );

    await priceResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoadingPrice: false,
            priceError: failure.message,
          ),
        );
      },
      (price) async {
        final listId =
            price?.priceListId ?? (await _resolveDefaultPriceList()).id;
        emit(
          state.copyWith(
            isLoadingPrice: false,
            retailUnitPrice: price?.unitPrice,
            minQty: price?.minQty,
            defaultPriceListId: listId,
            priceListItemId: price?.id,
            priceError: null,
          ),
        );
      },
    );
  }

  Future<bool> saveProductPrice({
    required String unitPrice,
    String? minQty,
  }) async {
    final productId = state.productId;
    if (productId == null) return false;

    final trimmed = unitPrice.trim();
    final parsed = Decimal.tryParse(trimmed);
    if (parsed == null || parsed <= Decimal.zero) {
      emit(
        state.copyWith(
          priceError: 'Enter a valid price greater than 0',
          priceSaveSuccess: false,
        ),
      );
      return false;
    }

    final resolved = await _resolveDefaultPriceList();
    final listId = resolved.id;
    if (listId == null) {
      emit(
        state.copyWith(
          priceError: resolved.error ?? 'No price list configured for this business',
          priceSaveSuccess: false,
        ),
      );
      return false;
    }

    emit(state.copyWith(isSavingPrice: true, priceError: null));

    final variationId = _defaultVariationId();
    final body = <String, dynamic>{
      'unit_price': trimmed,
      if (minQty != null && minQty.trim().isNotEmpty) 'min_qty': minQty.trim(),
      if (variationId != null) 'variation_id': variationId,
    };

    final result = await _setProductPrice(productId, listId, body);
    Map<String, dynamic>? savedItem;
    final saveOutcome = result.fold(
      (failure) {
        AppLogger.warning('Set price failed: ${failure.message}');
        emit(
          state.copyWith(
            isSavingPrice: false,
            priceError: failure.message,
            priceSaveSuccess: false,
          ),
        );
        return false;
      },
      (saved) {
        if (saved.id != null) {
          savedItem = {
            'id': saved.id,
            'price_list_id': saved.priceListId ?? listId,
            'product_id': productId,
            'variation_id': saved.variationId ?? variationId,
            'unit_price': saved.unitPrice ?? trimmed,
            'min_qty': saved.minQty ??
                (minQty == null || minQty.trim().isEmpty ? '1' : minQty.trim()),
          };
        }
        emit(
          state.copyWith(
            isSavingPrice: false,
            retailUnitPrice: saved.unitPrice ?? trimmed,
            minQty: saved.minQty ?? minQty?.trim(),
            defaultPriceListId: saved.priceListId ?? listId,
            priceListItemId: saved.id,
            priceError: null,
            priceSaveSuccess: true,
          ),
        );
        return true;
      },
    );
    if (saveOutcome) {
      // Put the new price into the local copy so POS and product lists show it.
      try {
        await _onPriceSaved?.call(savedItem ?? const {});
      } catch (e) {
        AppLogger.warning('Refresh after price save failed (${e.runtimeType})');
      }
    }
    return saveOutcome;
  }

  void initCreate() {
    emit(const ProductFormState(mode: 'create'));
  }

  Future<void> loadForEdit(String productId) async {
    emit(state.copyWith(isLoading: true, mode: 'edit', productId: productId));

    final result = await _getProductById(productId);
    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isLoading: false,
            errors: {'_general': failure.message},
          ),
        );
      },
      (product) async {
        final canManagePrices = await _canManagePrices();
        emit(
          ProductFormState(
            mode: 'edit',
            productId: product.id,
            name: product.name,
            sku: product.sku,
            description: product.description,
            imageUrl: product.imageUrl,
            selectedCategoryId: product.category?.id,
            selectedBrandId: product.brand?.id,
            selectedBaseUnitId: product.baseUnit?.id,
            productType: product.productType,
            trackingType: product.trackingType,
            isSellable: product.isSellable,
            isPurchasable: product.isPurchasable,
            isActive: product.isActive,
            shelfLifeDays: product.shelfLifeDays,
            minStockLevel: product.minStockLevel,
            maxStockLevel: product.maxStockLevel,
            canManagePrices: canManagePrices,
            variations: product.variations
                .map(
                  (v) => VariationFormItem(
                    id: v.id,
                    name: v.name,
                    sku: v.sku,
                    unitId: v.unitId,
                    isDefault: v.isDefault,
                    weightGrams: v.weightGrams,
                    isActive: v.isActive,
                  ),
                )
                .toList(),
            barcodes: [
              ...product.barcodes.map(
                (b) => BarcodeFormItem(
                  id: b.id,
                  barcode: b.barcode,
                  barcodeType: b.barcodeType,
                  variationId: b.variationId,
                  isPrimary: b.isPrimary,
                ),
              ),
            ],
          ),
        );
        if (canManagePrices) {
          await loadProductPrice();
        }
      },
    );
  }

  void updateName(String value) => emit(state.copyWith(name: value));
  void updateSku(String? value) => emit(state.copyWith(sku: value));
  void updateDescription(String? value) =>
      emit(state.copyWith(description: value));
  void updateImageUrl(String? value) => emit(state.copyWith(imageUrl: value));
  void updateLocalImagePath(String? path) =>
      emit(state.copyWith(localImagePath: path));

  Future<void> pickAndUploadImage() async {
    final pickedPath = await _imagePicker.pickImage();
    if (pickedPath == null) return;

    final file = File(pickedPath);
    emit(
      state.copyWith(
        localImagePath: pickedPath,
        isUploadingImage: true,
        imageUploadError: null,
      ),
    );

    try {
      final url = await _imageUpload.uploadImage(file);
      emit(
        state.copyWith(
          imageUrl: url,
          localImagePath: null,
          isUploadingImage: false,
          imageUploadError: null,
        ),
      );
    } on ImageUploadException catch (e) {
      emit(
        state.copyWith(
          isUploadingImage: false,
          imageUploadError: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isUploadingImage: false,
          imageUploadError: 'Image upload failed. Please try again.',
        ),
      );
    }
  }
  void updateCategoryId(String? id) =>
      emit(state.copyWith(selectedCategoryId: id));
  void updateBrandId(String? id) => emit(state.copyWith(selectedBrandId: id));
  void updateBaseUnitId(String? id) =>
      emit(state.copyWith(selectedBaseUnitId: id));
  void updateProductType(String type) =>
      emit(state.copyWith(productType: type));
  void updateTrackingType(String type) =>
      emit(state.copyWith(trackingType: type));
  void updateIsSellable(bool value) => emit(state.copyWith(isSellable: value));
  void updateIsPurchasable(bool value) =>
      emit(state.copyWith(isPurchasable: value));
  void updateIsActive(bool value) => emit(state.copyWith(isActive: value));
  void updateShelfLifeDays(int? days) =>
      emit(state.copyWith(shelfLifeDays: days));
  void updateMinStockLevel(String? value) =>
      emit(state.copyWith(minStockLevel: value));
  void updateMaxStockLevel(String? value) =>
      emit(state.copyWith(maxStockLevel: value));

  void addVariationRow() {
    final variations = [
      ...state.variations,
      VariationFormItem(unitId: state.selectedBaseUnitId),
    ];
    emit(state.copyWith(variations: variations));
  }

  void removeVariationRow(int index) {
    if (state.variations.length <= 1) return;
    final variations = [...state.variations]..removeAt(index);
    emit(state.copyWith(variations: variations));
  }

  void updateVariationRow(int index, VariationFormItem item) {
    final variations = [...state.variations];
    if (index < variations.length) {
      variations[index] = item;
      emit(state.copyWith(variations: variations));
    }
  }

  void setDefaultVariation(int index) {
    final variations = state.variations
        .asMap()
        .entries
        .map((e) => e.value.copyWith(isDefault: e.key == index))
        .toList();
    emit(state.copyWith(variations: variations));
  }

  void addBarcodeRow() {
    emit(state.copyWith(barcodes: [...state.barcodes, const BarcodeFormItem()]));
  }

  void removeBarcodeRow(int index) {
    final barcodes = [...state.barcodes]..removeAt(index);
    emit(state.copyWith(barcodes: barcodes));
  }

  void updateBarcodeRow(int index, BarcodeFormItem item) {
    final barcodes = [...state.barcodes];
    if (index < barcodes.length) {
      barcodes[index] = item;
      emit(state.copyWith(barcodes: barcodes));
    }
  }

  void setPrimaryBarcode(int index) {
    final barcodes = state.barcodes
        .asMap()
        .entries
        .map((e) => e.value.copyWith(isPrimary: e.key == index))
        .toList();
    emit(state.copyWith(barcodes: barcodes));
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.name.trim().length < 2) {
      errors['name'] = 'Name is required (min 2 characters)';
    }
    if (state.selectedBaseUnitId == null || state.selectedBaseUnitId!.isEmpty) {
      errors['base_unit_id'] = 'Base unit is required';
    }
    for (var i = 0; i < state.barcodes.length; i++) {
      final b = state.barcodes[i];
      if (b.barcode.isNotEmpty && b.barcode.length < 4) {
        errors['barcode_$i'] = 'Barcode must be at least 4 characters';
      }
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  List<VariationFormItem> _normalizedVariations() {
    if (state.variations.isEmpty) return [];
    final hasDefault = state.variations.any((v) => v.isDefault);
    if (!hasDefault) {
      return state.variations
          .asMap()
          .entries
          .map((e) => e.key == 0 ? e.value.copyWith(isDefault: true) : e.value)
          .toList();
    }
    return state.variations;
  }

  List<BarcodeFormItem> _normalizedBarcodes() {
    if (state.barcodes.isEmpty) return [];
    final hasPrimary = state.barcodes.any((b) => b.isPrimary);
    if (!hasPrimary) {
      return state.barcodes
          .asMap()
          .entries
          .map((e) => e.key == 0 ? e.value.copyWith(isPrimary: true) : e.value)
          .toList();
    }
    return state.barcodes;
  }

  Future<String?> submit() async {
    if (!validate()) return null;
    emit(state.copyWith(isSubmitting: true, errors: {}));

    final variations = _normalizedVariations();
    final barcodes = _normalizedBarcodes();

    if (state.mode == 'create') {
      final body = <String, dynamic>{
        'name': state.name.trim(),
        'base_unit_id': state.selectedBaseUnitId,
        'product_type': state.productType,
        'tracking_type': state.trackingType,
        'is_sellable': state.isSellable,
        'is_purchasable': state.isPurchasable,
        if (state.selectedCategoryId != null)
          'category_id': state.selectedCategoryId,
        if (state.selectedBrandId != null) 'brand_id': state.selectedBrandId,
        if (state.sku != null && state.sku!.isNotEmpty) 'sku': state.sku,
        if (state.description != null && state.description!.isNotEmpty)
          'description': state.description,
        if (state.imageUrl != null) 'image_url': state.imageUrl,
        if (state.trackingType == 'expiry' && state.shelfLifeDays != null)
          'shelf_life_days': state.shelfLifeDays,
        if (state.minStockLevel != null && state.minStockLevel!.isNotEmpty)
          'min_stock_level': state.minStockLevel,
        if (state.maxStockLevel != null && state.maxStockLevel!.isNotEmpty)
          'max_stock_level': state.maxStockLevel,
        if (variations.isNotEmpty)
          'variations': variations
              .where((v) => v.name.trim().isNotEmpty)
              .map(
                (v) => {
                  'name': v.name.trim(),
                  if (v.sku != null && v.sku!.isNotEmpty) 'sku': v.sku,
                  if (v.unitId != null) 'unit_id': v.unitId,
                  'is_default': v.isDefault,
                  if (v.weightGrams != null && v.weightGrams!.isNotEmpty)
                    'weight_grams': v.weightGrams,
                },
              )
              .toList(),
      };

      final result = await _createProduct(body);
      return await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              isSubmitting: false,
              errors: {'_general': failure.message},
            ),
          );
          return null;
        },
        (product) async {
          for (final b in barcodes.where((x) => x.barcode.isNotEmpty)) {
            final variationId = _resolveSubmitVariationId(
              linkKey: b.variationId,
              formVariations: variations,
              createdVariations: product.variations,
            );
            await _addBarcode(product.id, {
              'barcode': b.barcode,
              'barcode_type': b.barcodeType,
              if (variationId != null) 'variation_id': variationId,
              'is_primary': b.isPrimary,
            });
          }
          emit(state.copyWith(isSubmitting: false));
          return product.id;
        },
      );
    } else {
      final productId = state.productId!;
      final body = <String, dynamic>{
        'name': state.name.trim(),
        'is_sellable': state.isSellable,
        'is_purchasable': state.isPurchasable,
        'is_active': state.isActive,
        'category_id': state.selectedCategoryId,
        'brand_id': state.selectedBrandId,
        if (state.sku != null) 'sku': state.sku,
        if (state.description != null) 'description': state.description,
        if (state.imageUrl != null) 'image_url': state.imageUrl,
        if (state.trackingType == 'expiry' && state.shelfLifeDays != null)
          'shelf_life_days': state.shelfLifeDays,
        if (state.minStockLevel != null) 'min_stock_level': state.minStockLevel,
        if (state.maxStockLevel != null) 'max_stock_level': state.maxStockLevel,
      };

      final result = await _updateProduct(productId, body);
      return await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              isSubmitting: false,
              errors: {'_general': failure.message},
            ),
          );
          return null;
        },
        (_) async {
          final newVariationIds = <String, String>{};
          for (final entry
              in variations.asMap().entries.where((e) => e.value.name.trim().isNotEmpty)) {
            final v = entry.value;
            if (v.id == null) {
              final result = await _addVariation(productId, {
                'name': v.name.trim(),
                if (v.sku != null && v.sku!.isNotEmpty) 'sku': v.sku,
                if (v.unitId != null) 'unit_id': v.unitId,
                'is_default': v.isDefault,
                if (v.weightGrams != null && v.weightGrams!.isNotEmpty)
                  'weight_grams': v.weightGrams,
              });
              result.fold((_) {}, (created) {
                newVariationIds['local:${entry.key}'] = created.id;
              });
            }
          }
          for (final b in barcodes.where((x) => x.barcode.isNotEmpty)) {
            if (b.id == null) {
              final variationId = _resolveSubmitVariationId(
                linkKey: b.variationId,
                formVariations: variations,
                newVariationIds: newVariationIds,
              );
              await _addBarcode(productId, {
                'barcode': b.barcode,
                'barcode_type': b.barcodeType,
                if (variationId != null) 'variation_id': variationId,
                'is_primary': b.isPrimary,
              });
            }
          }
          emit(state.copyWith(isSubmitting: false));
          return productId;
        },
      );
    }
  }

  String? _resolveSubmitVariationId({
    required String? linkKey,
    required List<VariationFormItem> formVariations,
    Map<String, String>? newVariationIds,
    List<VariationModel>? createdVariations,
  }) {
    if (linkKey == null) return null;
    if (!isLocalVariationKey(linkKey)) return linkKey;
    return newVariationIds?[linkKey] ??
        resolveBarcodeVariationId(
          linkKey: linkKey,
          formVariations: formVariations,
          createdVariations: createdVariations ?? const [],
        );
  }
}
