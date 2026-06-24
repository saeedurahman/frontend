import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/constants/app_config.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/add_barcode_usecase.dart';
import 'package:frantend/features/products/domain/usecases/add_variation_usecase.dart';
import 'package:frantend/features/products/domain/usecases/create_product_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/update_product_usecase.dart';
import 'package:frantend/features/products/presentation/cubit/product_form_state.dart';
import 'package:frantend/features/products/presentation/utils/variation_utils.dart';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';

@injectable
class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required GetProductByIdUseCase getProductByIdUseCase,
    required CreateProductUseCase createProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
    required AddVariationUseCase addVariationUseCase,
    required AddBarcodeUseCase addBarcodeUseCase,
    required ImageUploadService imageUploadService,
  })  : _getProductById = getProductByIdUseCase,
        _createProduct = createProductUseCase,
        _updateProduct = updateProductUseCase,
        _addVariation = addVariationUseCase,
        _addBarcode = addBarcodeUseCase,
        _imageUpload = imageUploadService,
        super(const ProductFormState());

  final GetProductByIdUseCase _getProductById;
  final CreateProductUseCase _createProduct;
  final UpdateProductUseCase _updateProduct;
  final AddVariationUseCase _addVariation;
  final AddBarcodeUseCase _addBarcode;
  final ImageUploadService _imageUpload;
  final ImagePicker _imagePicker = ImagePicker();

  void initCreate() {
    emit(const ProductFormState(mode: 'create'));
  }

  Future<void> loadForEdit(String productId) async {
    emit(state.copyWith(isLoading: true, mode: 'edit', productId: productId));

    final result = await _getProductById(productId);
    result.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errors: {'_general': failure.message}),
      ),
      (product) {
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
    final picked = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final file = File(picked.path);
    emit(
      state.copyWith(
        localImagePath: picked.path,
        isUploadingImage: true,
        imageUploadError: null,
      ),
    );

    try {
      final url = await _imageUpload.uploadImage(
        file,
        folder: AppConfig.cloudinaryProductsFolder,
      );
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
