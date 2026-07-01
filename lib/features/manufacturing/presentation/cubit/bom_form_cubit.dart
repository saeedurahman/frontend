import 'package:decimal/decimal.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/domain/utils/bom_qty_calculator.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/bom_form_state.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class BomFormCubit extends Cubit<BomFormState> {
  BomFormCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetProductsUseCase getProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required GetBomUseCase getBomUseCase,
    required CreateBomUseCase createBomUseCase,
    required UpdateBomUseCase updateBomUseCase,
    required DeleteBomUseCase deleteBomUseCase,
  })  : _authLocal = authLocalDataSource,
        _getProducts = getProductsUseCase,
        _getProductById = getProductByIdUseCase,
        _getBom = getBomUseCase,
        _createBom = createBomUseCase,
        _updateBom = updateBomUseCase,
        _deleteBom = deleteBomUseCase,
        super(const BomFormState());

  final AuthLocalDataSource _authLocal;
  final GetProductsUseCase _getProducts;
  final GetProductByIdUseCase _getProductById;
  final GetBomUseCase _getBom;
  final CreateBomUseCase _createBom;
  final UpdateBomUseCase _updateBom;
  final DeleteBomUseCase _deleteBom;

  static const _productPageSize = 200;
  static const _manufacturedType = 'manufactured';

  Future<bool> _canManage() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canManageBom(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  Future<void> loadForCreate() async {
    if (!await _canManage()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final productsResult = await _fetchAllProducts(isActive: true);
    productsResult.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, errors: {'_general': failure.message}),
      ),
      (products) {
        final manufactured =
            products.where((p) => p.productType == _manufacturedType).toList();
        final next = BomFormState(
          manufacturedProducts: manufactured,
          ingredientProducts: products,
          lines: [const BomLineFormItem()],
        );
        emit(_withPreview(next));
      },
    );
  }

  Future<void> loadForEdit(String bomId) async {
    if (!await _canManage()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final bomResult = await _getBom(bomId);
    final productsResult = await _fetchAllProducts(isActive: true);

    if (bomResult.isLeft()) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': bomResult.fold((f) => f.message, (_) => '')},
        ),
      );
      return;
    }

    if (productsResult.isLeft()) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {
            '_general': productsResult.fold((f) => f.message, (_) => ''),
          },
        ),
      );
      return;
    }

    final bom = bomResult.getOrElse(() => throw StateError('unreachable'));
    final products = productsResult.getOrElse(() => const []);

    final manufactured =
        products.where((p) => p.productType == _manufacturedType).toList();

    VariationModel? selectedVariation;
    final variations = await _loadVariations(bom.productId);
    for (final v in variations) {
      if (v.id == bom.variationId) {
        selectedVariation = v;
        break;
      }
    }

    final lines = <BomLineFormItem>[];
    for (final line in bom.lines) {
      final lineVariations =
          await _loadVariations(line.ingredientProductId);
      VariationModel? ingredientVariation;
      for (final v in lineVariations) {
        if (v.id == line.ingredientVariationId) {
          ingredientVariation = v;
          break;
        }
      }
      lines.add(
        BomLineFormItem(
          ingredientProductId: line.ingredientProductId,
          ingredientProductName: line.ingredientProductName,
          ingredientVariationId: line.ingredientVariationId,
          ingredientVariationName: ingredientVariation?.name,
          qtyRequired: line.qtyRequired,
          wastagePct: line.wastagePct,
          variations: lineVariations,
        ),
      );
    }

    final next = BomFormState(
      bomId: bom.id,
      productId: bom.productId,
      productName: bom.productName,
      variationId: bom.variationId,
      variationName: selectedVariation?.name,
      finishedVariations: variations,
      name: bom.name,
      outputQty: bom.outputQty,
      isActive: bom.isActive,
      lines: lines.isEmpty ? [const BomLineFormItem()] : lines,
      manufacturedProducts: manufactured,
      ingredientProducts: _ingredientProductsFor(
        products,
        finishedProductId: bom.productId,
      ),
      previewBatchQty: bom.outputQty,
    );
    emit(_withPreview(next.copyWith(isLoading: false)));
  }

  List<ProductListItemModel> _ingredientProductsFor(
    List<ProductListItemModel> products, {
    required String? finishedProductId,
  }) {
    if (finishedProductId == null) return products;
    return products.where((p) => p.id != finishedProductId).toList();
  }

  Future<List<VariationModel>> _loadVariations(String productId) async {
    final result = await _getProductById(productId);
    return result.fold(
      (_) => const [],
      (product) => product.variations.where((v) => v.isActive).toList(),
    );
  }

  void updateName(String value) => emit(_withPreview(state.copyWith(name: value)));

  void updateOutputQty(String value) =>
      emit(_withPreview(state.copyWith(outputQty: value)));

  void updatePreviewBatchQty(String value) =>
      emit(_withPreview(state.copyWith(previewBatchQty: value)));

  void updateIsActive(bool value) => emit(state.copyWith(isActive: value));

  void addLine() =>
      emit(_withPreview(state.copyWith(lines: [...state.lines, const BomLineFormItem()])));

  void removeLine(int index) {
    if (state.lines.length <= 1) return;
    final lines = [...state.lines]..removeAt(index);
    emit(_withPreview(state.copyWith(lines: lines)));
  }

  void updateLine(int index, BomLineFormItem item) {
    final lines = [...state.lines];
    if (index >= lines.length) return;
    lines[index] = item;
    emit(_withPreview(state.copyWith(lines: lines)));
  }

  Future<void> selectFinishedProduct(String productId) async {
    final product = state.manufacturedProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => state.manufacturedProducts.first,
    );
    final variations = await _loadVariations(productId);
    VariationModel? defaultVar;
    for (final v in variations) {
      if (v.isDefault) {
        defaultVar = v;
        break;
      }
    }
    defaultVar ??= variations.isNotEmpty ? variations.first : null;

    final allProducts = state.ingredientProducts.isEmpty
        ? state.manufacturedProducts
        : [
            ...state.manufacturedProducts,
            ...state.ingredientProducts,
          ];

    emit(
      _withPreview(
        state.copyWith(
          productId: productId,
          productName: product.name,
          variationId: defaultVar?.id,
          variationName: defaultVar?.name,
          finishedVariations: variations,
          ingredientProducts: _ingredientProductsFor(
            _uniqueProducts(allProducts),
            finishedProductId: productId,
          ),
        ),
      ),
    );
  }

  List<ProductListItemModel> _uniqueProducts(List<ProductListItemModel> products) {
    final seen = <String>{};
    return products.where((p) => seen.add(p.id)).toList();
  }

  void selectFinishedVariation(String? variationId) {
    VariationModel? variation;
    for (final v in state.finishedVariations) {
      if (v.id == variationId) {
        variation = v;
        break;
      }
    }
    emit(
      state.copyWith(
        variationId: variationId,
        variationName: variation?.name,
      ),
    );
  }

  Future<void> selectIngredientProduct(int index, String productId) async {
    final products = state.ingredientProducts;
    final product = products.firstWhere(
      (p) => p.id == productId,
      orElse: () => products.first,
    );
    final variations = await _loadVariations(productId);
    VariationModel? defaultVar;
    for (final v in variations) {
      if (v.isDefault) {
        defaultVar = v;
        break;
      }
    }
    defaultVar ??= variations.isNotEmpty ? variations.first : null;

    final lines = [...state.lines];
    if (index >= lines.length) return;
    lines[index] = BomLineFormItem(
      ingredientProductId: productId,
      ingredientProductName: product.name,
      variations: variations,
      ingredientVariationId: defaultVar?.id,
      ingredientVariationName: defaultVar?.name,
    );
    emit(_withPreview(state.copyWith(lines: lines)));
  }

  void selectIngredientVariation(int index, String? variationId) {
    final lines = [...state.lines];
    if (index >= lines.length) return;
    final line = lines[index];
    VariationModel? variation;
    for (final v in line.variations) {
      if (v.id == variationId) {
        variation = v;
        break;
      }
    }
    lines[index] = line.copyWith(
      ingredientVariationId: variationId,
      ingredientVariationName: variation?.name,
    );
    emit(state.copyWith(lines: lines));
  }

  BomFormState _withPreview(BomFormState next) {
    final outputQty = Decimal.tryParse(next.outputQty.trim());
    final batchQty = Decimal.tryParse(next.previewBatchQty.trim());
    if (outputQty == null ||
        outputQty <= Decimal.zero ||
        batchQty == null ||
        batchQty <= Decimal.zero) {
      return next.copyWith(previewLines: const []);
    }

    final previewLines = <BomQtyPreviewLine>[];
    for (final line in next.lines) {
      if (line.ingredientProductId == null) continue;
      final qty = Decimal.tryParse(line.qtyRequired.trim());
      if (qty == null || qty <= Decimal.zero) continue;
      final wastage = Decimal.tryParse(line.wastagePct.trim()) ?? Decimal.zero;

      final computed = computeIngredientQtyForProduction(
        qtyRequired: qty,
        outputQty: outputQty,
        wastagePct: wastage,
        qtyToProduce: batchQty,
      );
      previewLines.add(
        BomQtyPreviewLine(
          ingredientProductId: line.ingredientProductId!,
          ingredientProductName: line.ingredientProductName,
          ingredientVariationId: line.ingredientVariationId,
          qtyPerOutputUnit: computed.perUnit,
          totalQtyRequired: computed.total,
          wastagePct: wastage,
        ),
      );
    }

    return next.copyWith(previewLines: previewLines);
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.productId == null) {
      errors['product'] = 'Finished product is required';
    }
    if (state.name.trim().isEmpty) {
      errors['name'] = 'Recipe name is required';
    }
    final outputQty = double.tryParse(state.outputQty.trim());
    if (outputQty == null || outputQty <= 0) {
      errors['output_qty'] = 'Output quantity must be greater than zero';
    }
    if (state.lines.isEmpty) {
      errors['lines'] = 'At least one ingredient line is required';
    }
    for (var i = 0; i < state.lines.length; i++) {
      final line = state.lines[i];
      if (line.ingredientProductId == null) {
        errors['line_$i'] = 'Ingredient product is required';
        continue;
      }
      if (line.ingredientProductId == state.productId) {
        errors['line_$i'] = 'Ingredient cannot be the finished product';
        continue;
      }
      final qty = double.tryParse(line.qtyRequired.trim());
      if (qty == null || qty <= 0) {
        errors['line_$i'] = 'Valid quantity is required';
      }
      final wastage = double.tryParse(line.wastagePct.trim());
      if (wastage == null || wastage < 0 || wastage > 100) {
        errors['line_$i'] = 'Wastage must be between 0 and 100';
      }
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Map<String, dynamic> _buildBody() {
    final lines = <Map<String, dynamic>>[];
    for (var i = 0; i < state.lines.length; i++) {
      final line = state.lines[i];
      if (line.ingredientProductId == null) continue;
      lines.add({
        'ingredient_product_id': line.ingredientProductId,
        if (line.ingredientVariationId != null)
          'ingredient_variation_id': line.ingredientVariationId,
        'qty_required': DecimalUtils.format(
          DecimalUtils.parse(line.qtyRequired.trim()),
          fractionDigits: 4,
        ),
        'wastage_pct': DecimalUtils.format(
          DecimalUtils.parse(line.wastagePct.trim().isEmpty ? '0' : line.wastagePct.trim()),
          fractionDigits: 4,
        ),
        'sort_order': i,
      });
    }

    return {
      'product_id': state.productId,
      if (state.variationId != null) 'variation_id': state.variationId,
      'name': state.name.trim(),
      'output_qty': DecimalUtils.format(
        DecimalUtils.parse(state.outputQty.trim()),
        fractionDigits: 4,
      ),
      'is_active': state.isActive,
      'lines': lines,
    };
  }

  Future<String?> submit() async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));
    final body = _buildBody();

    if (state.isEdit) {
      final result = await _updateBom(state.bomId!, body);
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

    final result = await _createBom(body);
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

  Future<String?> delete() async {
    if (!state.isEdit) return 'Nothing to delete';

    emit(state.copyWith(isDeleting: true));
    final result = await _deleteBom(state.bomId!);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false));
        return failure.message;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return null;
      },
    );
  }

  Future<Either<Failure, List<ProductListItemModel>>> _fetchAllProducts({
    bool? isActive,
  }) async {
    final all = <ProductListItemModel>[];
    var skip = 0;

    while (true) {
      final result = await _getProducts(
        isActive: isActive,
        skip: skip,
        limit: _productPageSize,
      );
      Failure? failure;
      var fetched = 0;
      var total = 0;

      result.fold(
        (f) => failure = f,
        (page) {
          fetched = page.items.length;
          total = page.total;
          all.addAll(page.items);
        },
      );

      if (failure != null) return Left(failure!);
      if (fetched == 0 || all.length >= total) break;
      skip += fetched;
    }

    return Right(all);
  }
}