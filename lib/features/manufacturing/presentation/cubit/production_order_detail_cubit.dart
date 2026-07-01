import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/utils/decimal_utils.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/inventory/domain/usecases/inventory_usecases.dart';
import 'package:frantend/features/manufacturing/data/models/production_order_model.dart';
import 'package:frantend/features/manufacturing/domain/usecases/manufacturing_usecases.dart';
import 'package:frantend/features/manufacturing/domain/utils/production_availability.dart';
import 'package:frantend/features/manufacturing/presentation/cubit/production_order_detail_state.dart';
import 'package:frantend/features/settings/domain/usecases/settings_usecases.dart';
import 'package:injectable/injectable.dart';

const _previewDebounceDuration = Duration(milliseconds: 400);

@injectable
class ProductionOrderDetailCubit extends Cubit<ProductionOrderDetailState> {
  ProductionOrderDetailCubit({
    required AuthLocalDataSource authLocalDataSource,
    required GetProductionOrderUseCase getProductionOrderUseCase,
    required ListBomsUseCase listBomsUseCase,
    required UpdateProductionOrderUseCase updateProductionOrderUseCase,
    required StartProductionOrderUseCase startProductionOrderUseCase,
    required CancelProductionOrderUseCase cancelProductionOrderUseCase,
    required CompleteProductionOrderUseCase completeProductionOrderUseCase,
    required PreviewBomUseCase previewBomUseCase,
    required GetStockBalancesUseCase getStockBalancesUseCase,
    required GetBusinessProfileUseCase getBusinessProfileUseCase,
  })  : _authLocal = authLocalDataSource,
        _getOrder = getProductionOrderUseCase,
        _listBoms = listBomsUseCase,
        _updateOrder = updateProductionOrderUseCase,
        _startOrder = startProductionOrderUseCase,
        _cancelOrder = cancelProductionOrderUseCase,
        _completeOrder = completeProductionOrderUseCase,
        _previewBom = previewBomUseCase,
        _getStockBalances = getStockBalancesUseCase,
        _getBusinessProfile = getBusinessProfileUseCase,
        super(const ProductionOrderDetailState());

  final AuthLocalDataSource _authLocal;
  final GetProductionOrderUseCase _getOrder;
  final ListBomsUseCase _listBoms;
  final UpdateProductionOrderUseCase _updateOrder;
  final StartProductionOrderUseCase _startOrder;
  final CancelProductionOrderUseCase _cancelOrder;
  final CompleteProductionOrderUseCase _completeOrder;
  final PreviewBomUseCase _previewBom;
  final GetStockBalancesUseCase _getStockBalances;
  final GetBusinessProfileUseCase _getBusinessProfile;

  Timer? _previewDebounce;
  int _previewGeneration = 0;

  Future<void> load(String orderId) async {
    emit(state.copyWith(isLoading: true, loadError: null));

    final user = await _authLocal.getCachedUser();
    if (!UserRoleUtils.canViewProduction(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    )) {
      emit(
        state.copyWith(
          isLoading: false,
          loadError: 'Permission denied',
        ),
      );
      return;
    }

    final allowNegative = await _loadAllowNegativeStock();
    final orderResult = await _getOrder(orderId);
    final bomsResult = await _listBoms(activeOnly: true);

    orderResult.fold(
      (failure) => emit(
        state.copyWith(isLoading: false, loadError: failure.message),
      ),
      (order) {
        final boms = bomsResult.getOrElse(() => const []);
        emit(
          ProductionOrderDetailState(
            order: order,
            isLoading: false,
            allowNegativeStock: allowNegative,
            canCreate: UserRoleUtils.canCreateProduction(
              role: user?.role,
              permissionKeys: user?.permissionKeys ?? const [],
            ),
            canComplete: UserRoleUtils.canCompleteProduction(
              role: user?.role,
              permissionKeys: user?.permissionKeys ?? const [],
            ),
            canCancel: UserRoleUtils.canCancelProduction(
              role: user?.role,
              permissionKeys: user?.permissionKeys ?? const [],
            ),
            activeBoms: boms,
            draftBomHeaderId: order.bomHeaderId,
            draftQtyToProduce: order.qtyToProduce,
            draftNotes: order.notes ?? '',
          ),
        );
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

  void startEditingDraft() {
    final order = state.order;
    if (order == null || order.status != ProductionOrderStatus.draft) return;
    emit(
      state.copyWith(
        isEditingDraft: true,
        draftBomHeaderId: order.bomHeaderId,
        draftQtyToProduce: order.qtyToProduce,
        draftNotes: order.notes ?? '',
        errors: {},
      ),
    );
  }

  void cancelEditingDraft() {
    final order = state.order;
    if (order == null) return;
    emit(
      state.copyWith(
        isEditingDraft: false,
        draftBomHeaderId: order.bomHeaderId,
        draftQtyToProduce: order.qtyToProduce,
        draftNotes: order.notes ?? '',
        errors: {},
      ),
    );
  }

  void updateDraftBom(String? bomId) =>
      emit(state.copyWith(draftBomHeaderId: bomId));

  void updateDraftQty(String value) =>
      emit(state.copyWith(draftQtyToProduce: value));

  void updateDraftNotes(String value) =>
      emit(state.copyWith(draftNotes: value));

  bool _validateDraft() {
    final errors = <String, String>{};
    if (state.draftBomHeaderId == null) {
      errors['bom'] = 'BOM is required';
    }
    final qty = double.tryParse(state.draftQtyToProduce.trim());
    if (qty == null || qty <= 0) {
      errors['qty'] = 'Quantity must be greater than zero';
    }
    emit(state.copyWith(errors: errors));
    return errors.isEmpty;
  }

  Future<String?> saveDraft() async {
    final order = state.order;
    if (order == null || order.status != ProductionOrderStatus.draft) {
      return 'Order is not editable';
    }
    if (!_validateDraft()) return 'Validation failed';

    emit(state.copyWith(isUpdating: true));
    final body = <String, dynamic>{
      'bom_header_id': state.draftBomHeaderId,
      'qty_to_produce': DecimalUtils.format(
        DecimalUtils.parse(state.draftQtyToProduce.trim()),
        fractionDigits: 4,
      ),
      'notes': state.draftNotes.trim().isEmpty ? null : state.draftNotes.trim(),
    };

    final result = await _updateOrder(order.id, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false));
        return failure.message;
      },
      (updated) {
        emit(
          state.copyWith(
            order: updated,
            isUpdating: false,
            isEditingDraft: false,
            draftBomHeaderId: updated.bomHeaderId,
            draftQtyToProduce: updated.qtyToProduce,
            draftNotes: updated.notes ?? '',
          ),
        );
        return null;
      },
    );
  }

  Future<String?> start() async {
    final order = state.order;
    if (order == null) return 'Order not loaded';

    emit(state.copyWith(isUpdating: true));
    final result = await _startOrder(order.id);
    return result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false));
        return failure.message;
      },
      (updated) {
        emit(state.copyWith(order: updated, isUpdating: false));
        return null;
      },
    );
  }

  Future<String?> cancel() async {
    final order = state.order;
    if (order == null) return 'Order not loaded';

    emit(state.copyWith(isUpdating: true));
    final result = await _cancelOrder(order.id);
    return result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false));
        return failure.message;
      },
      (updated) {
        emit(
          state.copyWith(
            order: updated,
            isUpdating: false,
            isEditingDraft: false,
          ),
        );
        return null;
      },
    );
  }

  Future<void> prepareCompletionPreview(String qtyProduced) async {
    final order = state.order;
    if (order == null) return;

    _previewDebounce?.cancel();
    final generation = ++_previewGeneration;
    emit(state.copyWith(isPreviewLoading: true));

    final parsedQty = double.tryParse(qtyProduced.trim());
    if (parsedQty == null || parsedQty <= 0) {
      emit(
        state.copyWith(
          isPreviewLoading: false,
          completionPreview: null,
          completionAvailability: const [],
        ),
      );
      return;
    }

    _previewDebounce = Timer(_previewDebounceDuration, () async {
      final previewResult = await _previewBom(
        bomHeaderId: order.bomHeaderId,
        qtyToProduce: qtyProduced.trim(),
      );

      if (generation != _previewGeneration || isClosed) return;

      await previewResult.fold(
        (failure) async {
          emit(
            state.copyWith(
              isPreviewLoading: false,
              completionPreview: null,
              completionAvailability: const [],
            ),
          );
        },
        (preview) async {
          final productIds = preview.lines
              .map((line) => line.ingredientProductId)
              .toList();
          final balancesResult = await _getStockBalances(
            branchId: order.branchId,
            productIds: productIds.isEmpty ? null : productIds,
          );

          if (generation != _previewGeneration || isClosed) return;

          balancesResult.fold(
            (_) => emit(
              state.copyWith(
                isPreviewLoading: false,
                completionPreview: preview,
                completionAvailability: const [],
              ),
            ),
            (balances) {
              final availability = joinPreviewWithStock(
                preview: preview,
                balances: balances,
                allowNegativeStock: state.allowNegativeStock,
              );
              emit(
                state.copyWith(
                  isPreviewLoading: false,
                  completionPreview: preview,
                  completionAvailability: availability,
                ),
              );
            },
          );
        },
      );
    });
  }

  Future<String?> complete(String qtyProduced) async {
    final order = state.order;
    if (order == null) return 'Order not loaded';

    emit(state.copyWith(isUpdating: true));
    final result = await _completeOrder(
      order.id,
      qtyProduced: DecimalUtils.format(
        DecimalUtils.parse(qtyProduced.trim()),
        fractionDigits: 4,
      ),
    );
    return result.fold(
      (failure) {
        emit(state.copyWith(isUpdating: false));
        return failure.message;
      },
      (updated) {
        emit(
          state.copyWith(
            order: updated,
            isUpdating: false,
            isEditingDraft: false,
          ),
        );
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
