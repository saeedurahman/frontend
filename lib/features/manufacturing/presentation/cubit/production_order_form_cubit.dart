import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_form_state.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:injectable/injectable.dart';

const _previewDebounceDuration = Duration(milliseconds: 400);

@injectable
class ProductionOrderFormCubit extends Cubit<ProductionOrderFormState> {
  ProductionOrderFormCubit({
    required AuthLocalDataSource authLocalDataSource,
    required BranchSelectorCubit branchSelectorCubit,
    required ListBomsUseCase listBomsUseCase,
    required PreviewBomUseCase previewBomUseCase,
    required GetStockBalancesUseCase getStockBalancesUseCase,
    required GetBusinessProfileUseCase getBusinessProfileUseCase,
    required CreateProductionOrderUseCase createProductionOrderUseCase,
  })  : _authLocal = authLocalDataSource,
        _branchSelector = branchSelectorCubit,
        _listBoms = listBomsUseCase,
        _previewBom = previewBomUseCase,
        _getStockBalances = getStockBalancesUseCase,
        _getBusinessProfile = getBusinessProfileUseCase,
        _createOrder = createProductionOrderUseCase,
        super(const ProductionOrderFormState());

  final AuthLocalDataSource _authLocal;
  final BranchSelectorCubit _branchSelector;
  final ListBomsUseCase _listBoms;
  final PreviewBomUseCase _previewBom;
  final GetStockBalancesUseCase _getStockBalances;
  final GetBusinessProfileUseCase _getBusinessProfile;
  final CreateProductionOrderUseCase _createOrder;

  Timer? _previewDebounce;
  int _previewGeneration = 0;

  Future<void> init() async {
    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canCreateProduction(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final allowNegative = await _loadAllowNegativeStock();
    final bomsResult = await _listBoms(activeOnly: true);
    final branchId = _branchSelector.state.selectedBranchId;

    bomsResult.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          errors: {'_general': failure.message},
        ),
      ),
      (boms) {
        if (boms.isEmpty) {
          emit(
            state.copyWith(
              isLoading: false,
              allowNegativeStock: allowNegative,
              errors: {'_general': 'No active BOMs. Create a recipe first.'},
            ),
          );
          return;
        }

        emit(
          ProductionOrderFormState(
            branchId: branchId,
            activeBoms: boms,
            bomHeaderId: boms.first.id,
            allowNegativeStock: allowNegative,
            isLoading: false,
          ),
        );
        _scheduleAvailabilityPreview();
      },
    );
  }

  Future<bool> _loadAllowNegativeStock() async {
    final result = await _getBusinessProfile();
    return result.fold(
      (_) => false,
      (profile) => profile.config?.allowNegativeStock ?? false,
    );
  }

  void selectBom(String? bomId) {
    emit(state.copyWith(bomHeaderId: bomId));
    _scheduleAvailabilityPreview();
  }

  void updateQtyToProduce(String value) {
    emit(state.copyWith(qtyToProduce: value));
    _scheduleAvailabilityPreview();
  }

  void updateNotes(String value) => emit(state.copyWith(notes: value));

  void _scheduleAvailabilityPreview() {
    _previewDebounce?.cancel();
    final bomId = state.bomHeaderId;
    final qty = state.qtyToProduce.trim();
    final branchId = state.branchId;

    if (bomId == null || qty.isEmpty || branchId == null) {
      emit(
        state.copyWith(
          preview: null,
          availability: const [],
          hasShortfall: false,
          isPreviewLoading: false,
        ),
      );
      return;
    }

    final parsedQty = double.tryParse(qty);
    if (parsedQty == null || parsedQty <= 0) {
      emit(
        state.copyWith(
          preview: null,
          availability: const [],
          hasShortfall: false,
          isPreviewLoading: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isPreviewLoading: true));
    final generation = ++_previewGeneration;

    _previewDebounce = Timer(_previewDebounceDuration, () async {
      final previewResult = await _previewBom(
        bomHeaderId: bomId,
        qtyToProduce: qty,
      );

      if (generation != _previewGeneration || isClosed) return;

      await previewResult.fold(
        (failure) async {
          emit(
            state.copyWith(
              isPreviewLoading: false,
              preview: null,
              availability: const [],
              hasShortfall: false,
              errors: {...state.errors, 'preview': failure.message},
            ),
          );
        },
        (preview) async {
          final productIds = preview.lines
              .map((line) => line.ingredientProductId)
              .toList();
          final balancesResult = await _getStockBalances(
            branchId: branchId,
            productIds: productIds.isEmpty ? null : productIds,
          );

          if (generation != _previewGeneration || isClosed) return;

          balancesResult.fold(
            (failure) => emit(
              state.copyWith(
                isPreviewLoading: false,
                preview: preview,
                availability: const [],
                hasShortfall: false,
                errors: {...state.errors, 'preview': failure.message},
              ),
            ),
            (balances) {
              final availability = joinPreviewWithStock(
                preview: preview,
                balances: balances,
                allowNegativeStock: state.allowNegativeStock,
              );
              final errors = Map<String, String>.from(state.errors)
                ..remove('preview');
              emit(
                state.copyWith(
                  isPreviewLoading: false,
                  preview: preview,
                  availability: availability,
                  hasShortfall: hasIngredientShortfall(availability),
                  errors: errors,
                ),
              );
            },
          );
        },
      );
    });
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.branchId == null) {
      errors['_general'] = 'Branch not selected';
    }
    if (state.bomHeaderId == null) {
      errors['bom'] = 'BOM is required';
    }
    final qty = double.tryParse(state.qtyToProduce.trim());
    if (qty == null || qty <= 0) {
      errors['qty'] = 'Quantity must be greater than zero';
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Future<String?> submit() async {
    if (!validate()) return 'Validation failed';

    emit(state.copyWith(isSubmitting: true, errors: {}));

    final body = <String, dynamic>{
      'branch_id': state.branchId,
      'bom_header_id': state.bomHeaderId,
      'qty_to_produce': DecimalUtils.format(
        DecimalUtils.parse(state.qtyToProduce.trim()),
        fractionDigits: 4,
      ),
      if (state.notes.trim().isNotEmpty) 'notes': state.notes.trim(),
    };

    final result = await _createOrder(body);
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

  @override
  Future<void> close() {
    _previewDebounce?.cancel();
    return super.close();
  }
}
