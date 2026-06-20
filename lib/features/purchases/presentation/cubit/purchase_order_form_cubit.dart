import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/error/failures.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/variation_model.dart';
import 'package:frantend/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:frantend/features/products/domain/usecases/get_products_usecase.dart';
import 'package:frantend/features/purchases/data/models/purchase_order_model.dart';
import 'package:frantend/features/purchases/domain/usecases/purchase_usecases.dart';
import 'package:frantend/features/purchases/presentation/cubit/purchase_order_form_state.dart';
import 'package:frantend/features/suppliers/domain/usecases/supplier_usecases.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseOrderFormCubit extends Cubit<PurchaseOrderFormState> {
  PurchaseOrderFormCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetSuppliersUseCase getSuppliersUseCase,
    required GetProductsUseCase getProductsUseCase,
    required GetProductByIdUseCase getProductByIdUseCase,
    required CreatePurchaseOrderUseCase createPurchaseOrderUseCase,
    required UpdatePurchaseOrderStatusUseCase updatePurchaseOrderStatusUseCase,
  })  : _authLocal = authLocalDataSource,
        _getSuppliers = getSuppliersUseCase,
        _getProducts = getProductsUseCase,
        _getProductById = getProductByIdUseCase,
        _createOrder = createPurchaseOrderUseCase,
        _updateStatus = updatePurchaseOrderStatusUseCase,
        super(const PurchaseOrderFormState());

  final AuthLocalDataSource _authLocal;
  final GetSuppliersUseCase _getSuppliers;
  final GetProductsUseCase _getProducts;
  final GetProductByIdUseCase _getProductById;
  final CreatePurchaseOrderUseCase _createOrder;
  final UpdatePurchaseOrderStatusUseCase _updateStatus;

  static const _productPageSize = 200;

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    final user = await _authLocal.getCachedUser();
    final branchId = user?.branchId;

    final suppliersResult = await _getSuppliers();
    final productsResult = await _fetchAllProducts(isActive: true);

    suppliersResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': failure.message},
        ),
      ),
      (suppliers) {
        productsResult.fold(
          (failure) => emit(
            state.copyWith(
              isLoading: false,
              errors: {'_general': failure.message},
            ),
          ),
          (products) => emit(
            PurchaseOrderFormState(
              branchId: branchId,
              suppliers: suppliers,
              products: products,
              lines: [const PurchaseLineFormItem()],
            ),
          ),
        );
      },
    );
  }

  void updateSupplierId(String? id) => emit(state.copyWith(supplierId: id));
  void updateExpectedAt(DateTime? date) => emit(state.copyWith(expectedAt: date));
  void updateNotes(String value) => emit(state.copyWith(notes: value));

  void addLine() {
    emit(state.copyWith(lines: [...state.lines, const PurchaseLineFormItem()]));
  }

  void removeLine(int index) {
    if (state.lines.length <= 1) return;
    final lines = [...state.lines]..removeAt(index);
    emit(state.copyWith(lines: lines));
  }

  void updateLine(int index, PurchaseLineFormItem item) {
    final lines = [...state.lines];
    if (index < lines.length) {
      lines[index] = item;
      emit(state.copyWith(lines: lines));
    }
  }

  Future<void> selectProduct(int index, String productId) async {
    final product = state.products.firstWhere(
      (p) => p.id == productId,
      orElse: () => state.products.first,
    );

    final result = await _getProductById(productId);
    result.fold(
      (failure) => emit(
        state.copyWith(errors: {'_general': failure.message}),
      ),
      (fullProduct) {
        final variations = fullProduct.variations
            .where((v) => v.isActive)
            .toList();
        VariationModel? defaultVar;
        for (final v in variations) {
          if (v.isDefault) {
            defaultVar = v;
            break;
          }
        }
        defaultVar ??= variations.isNotEmpty ? variations.first : null;

        final lines = [...state.lines];
        if (index < lines.length) {
          lines[index] = PurchaseLineFormItem(
            productId: productId,
            productName: product.name,
            variations: variations,
            variationId: defaultVar?.id,
            variationName: defaultVar?.name,
          );
          emit(state.copyWith(lines: lines));
        }
      },
    );
  }

  void selectVariation(int index, String? variationId) {
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
      variationId: variationId,
      variationName: variation?.name,
    );
    emit(state.copyWith(lines: lines));
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.branchId == null) {
      errors['_general'] = 'Branch not found. Please log in again.';
    }
    if (state.supplierId == null) {
      errors['supplier'] = 'Supplier is required';
    }
    if (state.lines.isEmpty) {
      errors['lines'] = 'At least one line item is required';
    }
    for (var i = 0; i < state.lines.length; i++) {
      final line = state.lines[i];
      if (line.productId == null) {
        errors['line_$i'] = 'Product is required';
      }
      if (line.orderedQty.trim().isEmpty ||
          (double.tryParse(line.orderedQty) ?? 0) <= 0) {
        errors['line_$i'] = 'Valid quantity is required';
      }
      if (line.costPerUnit.trim().isEmpty ||
          (double.tryParse(line.costPerUnit) ?? 0) < 0) {
        errors['line_$i'] = 'Valid cost is required';
      }
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  List<CreatePurchaseLineParams> _buildLineParams() {
    return state.lines
        .where((l) => l.productId != null)
        .map(
          (line) => CreatePurchaseLineParams(
            productId: line.productId!,
            variationId: line.variationId,
            orderedQty: DecimalUtils.parse(line.orderedQty),
            costPerUnit: DecimalUtils.parse(line.costPerUnit),
            taxRate: line.taxRate.isNotEmpty
                ? DecimalUtils.parse(line.taxRate)
                : null,
          ),
        )
        .toList();
  }

  Future<String?> submitDraft() => _submit(submitAsOrdered: false);

  Future<String?> submitAndOrder() => _submit(submitAsOrdered: true);

  Future<String?> _submit({required bool submitAsOrdered}) async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));

    final params = CreatePurchaseOrderParams(
      branchId: state.branchId!,
      supplierId: state.supplierId!,
      expectedAt: state.expectedAt,
      notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      lines: _buildLineParams(),
    );

    final result = await _createOrder(params);

    return await result.fold<Future<String?>>(
      (failure) async {
        emit(state.copyWith(isSubmitting: false));
        return failure.message;
      },
      (order) async {
        if (submitAsOrdered) {
          final statusResult = await _updateStatus(
            order.id,
            PurchaseOrderStatus.ordered,
          );
          return statusResult.fold(
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
        emit(state.copyWith(isSubmitting: false));
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
