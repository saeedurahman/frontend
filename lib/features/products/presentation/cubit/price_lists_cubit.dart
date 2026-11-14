import 'package:decimal/decimal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/connectivity/connectivity_probe.dart';
import 'package:frantend/core/di/injection.dart';
import 'package:frantend/core/offline/local_catalog.dart';
import 'package:frantend/features/products/data/models/price_list_detail_models.dart';
import 'package:frantend/features/products/data/models/price_list_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

class PriceListsState {
  const PriceListsState({
    this.priceLists = const [],
    this.selectedListId,
    this.items = const [],
    this.totalItems = 0,
    this.skip = 0,
    this.limit = 50,
    this.searchQuery = '',
    this.isLoadingLists = false,
    this.isLoadingItems = false,
    this.isSaving = false,
    this.isOnline = true,
    this.errorMessage,
    this.successMessage,
    this.adjustPreview,
  });

  final List<PriceListModel> priceLists;
  final String? selectedListId;
  final List<PriceListItemDetailModel> items;
  final int totalItems;
  final int skip;
  final int limit;
  final String searchQuery;
  final bool isLoadingLists;
  final bool isLoadingItems;
  final bool isSaving;
  final bool isOnline;
  final String? errorMessage;
  final String? successMessage;
  final AdjustPricesResponseModel? adjustPreview;

  PriceListModel? get selectedList {
    if (selectedListId == null) return null;
    for (final l in priceLists) {
      if (l.id == selectedListId) return l;
    }
    return null;
  }

  PriceListsState copyWith({
    List<PriceListModel>? priceLists,
    String? selectedListId,
    bool clearSelectedList = false,
    List<PriceListItemDetailModel>? items,
    int? totalItems,
    int? skip,
    int? limit,
    String? searchQuery,
    bool? isLoadingLists,
    bool? isLoadingItems,
    bool? isSaving,
    bool? isOnline,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    AdjustPricesResponseModel? adjustPreview,
    bool clearAdjustPreview = false,
  }) {
    return PriceListsState(
      priceLists: priceLists ?? this.priceLists,
      selectedListId: clearSelectedList ? null : (selectedListId ?? this.selectedListId),
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingLists: isLoadingLists ?? this.isLoadingLists,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
      isSaving: isSaving ?? this.isSaving,
      isOnline: isOnline ?? this.isOnline,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      adjustPreview: clearAdjustPreview ? null : (adjustPreview ?? this.adjustPreview),
    );
  }
}

@injectable
class PriceListsCubit extends Cubit<PriceListsState> {
  PriceListsCubit({
    required ProductsRepository productsRepository,
    ConnectivityProbe? connectivityProbe,
  })  : _repository = productsRepository,
        _connectivity = connectivityProbe ?? (sl.isRegistered<ConnectivityProbe>() ? sl<ConnectivityProbe>() : null),
        super(const PriceListsState());

  final ProductsRepository _repository;
  final ConnectivityProbe? _connectivity;

  Future<bool> _checkOnline() async {
    if (_connectivity != null) {
      final status = await _connectivity.check();
      final online = status != ReachabilityStatus.offline;
      emit(state.copyWith(isOnline: online));
      return online;
    }
    return true;
  }

  void clearMessages() {
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  Future<void> loadPriceLists({String? preferredSelectedId}) async {
    emit(state.copyWith(isLoadingLists: true, clearError: true));
    await _checkOnline();

    final result = await _repository.getPriceLists();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingLists: false,
          errorMessage: failure.message,
        ));
      },
      (lists) {
        String? targetId = preferredSelectedId;
        if (targetId == null || !lists.any((l) => l.id == targetId)) {
          final defaultList = lists.cast<PriceListModel?>().firstWhere(
            (l) => l?.isDefault == true,
            orElse: () => lists.isNotEmpty ? lists.first : null,
          );
          targetId = defaultList?.id;
        }

        emit(state.copyWith(
          isLoadingLists: false,
          priceLists: lists,
          selectedListId: targetId,
        ));

        if (targetId != null) {
          loadItems(listId: targetId);
        }
      },
    );
  }

  void selectList(String listId) {
    if (state.selectedListId == listId) return;
    emit(state.copyWith(
      selectedListId: listId,
      searchQuery: '',
      skip: 0,
      clearAdjustPreview: true,
      clearError: true,
      clearSuccess: true,
    ));
    loadItems(listId: listId);
  }

  Future<void> loadItems({String? listId, String? search, int? skip, int? limit}) async {
    final targetId = listId ?? state.selectedListId;
    if (targetId == null) return;

    final s = search ?? state.searchQuery;
    final sk = skip ?? state.skip;
    final lim = limit ?? state.limit;

    emit(state.copyWith(
      isLoadingItems: true,
      searchQuery: s,
      skip: sk,
      limit: lim,
      clearError: true,
    ));

    final result = await _repository.getPriceListItems(
      targetId,
      search: s,
      skip: sk,
      limit: lim,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingItems: false,
          errorMessage: failure.message,
        ));
      },
      (paged) {
        emit(state.copyWith(
          isLoadingItems: false,
          items: paged.items,
          totalItems: paged.total,
          skip: paged.skip,
          limit: paged.limit,
        ));
      },
    );
  }

  Future<bool> createPriceList({
    required String name,
    required String listType,
    bool isDefault = false,
    bool isActive = true,
    String? validFrom,
    String? validTo,
  }) async {
    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price list editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = {
      'name': name.trim(),
      'list_type': listType,
      'is_default': isDefault,
      'is_active': isActive,
      if (validFrom != null && validFrom.isNotEmpty) 'valid_from': validFrom,
      if (validTo != null && validTo.isNotEmpty) 'valid_to': validTo,
    };

    final result = await _repository.createPriceList(body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (created) {
        emit(state.copyWith(
          isSaving: false,
          successMessage: 'Price list "${created.name}" created.',
        ));
        loadPriceLists(preferredSelectedId: created.id);
        return true;
      },
    );
  }

  Future<bool> updatePriceList(
    String id, {
    String? name,
    String? listType,
    bool? isDefault,
    bool? isActive,
    String? validFrom,
    String? validTo,
  }) async {
    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price list editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = <String, dynamic>{
      if (name != null) 'name': name.trim(),
      if (listType != null) 'list_type': listType,
      if (isDefault != null) 'is_default': isDefault,
      if (isActive != null) 'is_active': isActive,
      'valid_from': validFrom != null && validFrom.isNotEmpty ? validFrom : null,
      'valid_to': validTo != null && validTo.isNotEmpty ? validTo : null,
    };

    final result = await _repository.updatePriceList(id, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (updated) {
        emit(state.copyWith(
          isSaving: false,
          successMessage: 'Price list "${updated.name}" updated.',
        ));
        loadPriceLists(preferredSelectedId: updated.id);
        return true;
      },
    );
  }

  Future<bool> setDefault(String id) async {
    return updatePriceList(id, isDefault: true);
  }

  Future<bool> copyPriceList(
    String sourceId, {
    required String name,
    Decimal? percent,
    String? listType,
    String? validFrom,
    String? validTo,
  }) async {
    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price list editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = <String, dynamic>{
      'name': name.trim(),
      if (percent != null) 'percent': percent.toString(),
      if (listType != null) 'list_type': listType,
      if (validFrom != null && validFrom.isNotEmpty) 'valid_from': validFrom,
      if (validTo != null && validTo.isNotEmpty) 'valid_to': validTo,
    };

    final result = await _repository.copyPriceList(sourceId, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (copied) {
        emit(state.copyWith(
          isSaving: false,
          successMessage: 'Price list copied as "${copied.name}".',
        ));
        loadPriceLists(preferredSelectedId: copied.id);
        return true;
      },
    );
  }

  Future<String?> deletePriceList(String id) async {
    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price list editing requires an active internet connection.'));
      return 'Price list editing requires an active internet connection.';
    }

    final target = state.priceLists.cast<PriceListModel?>().firstWhere(
      (l) => l?.id == id,
      orElse: () => null,
    );
    if (target?.isDefault == true) {
      emit(state.copyWith(errorMessage: 'The default price list cannot be deleted.'));
      return 'The default price list cannot be deleted.';
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final result = await _repository.deletePriceList(id);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return failure.message;
      },
      (data) {
        final unassigned = data['customers_unassigned'] ?? 0;
        final msg = unassigned > 0
            ? 'Price list deleted. $unassigned customers unassigned to default list.'
            : 'Price list deleted.';
        emit(state.copyWith(
          isSaving: false,
          successMessage: msg,
        ));
        loadPriceLists();
        return null;
      },
    );
  }

  Future<bool> savePriceItem({
    required String productId,
    String? variationId,
    required String price,
    String minQty = '1',
  }) async {
    final listId = state.selectedListId;
    if (listId == null) return false;

    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final items = [
      {
        'product_id': productId,
        if (variationId != null) 'variation_id': variationId,
        'price': price.trim(),
        'min_qty': minQty.trim().isEmpty ? '1' : minQty.trim(),
      }
    ];

    final result = await _repository.bulkUpsertPriceItems(listId, items);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (resp) {
        // Instant local cache update so POS sees it immediately!
        if (sl.isRegistered<LocalCatalog>()) {
          sl<LocalCatalog>().rememberPrice({
            'id': '${listId}_${productId}_${variationId ?? "base"}_$minQty',
            'price_list_id': listId,
            'product_id': productId,
            'variation_id': variationId,
            'unit_price': price.trim(),
            'min_qty': minQty.trim().isEmpty ? '1' : minQty.trim(),
          });
        }

        emit(state.copyWith(
          isSaving: false,
          successMessage: 'Price saved.',
        ));
        loadItems();
        return true;
      },
    );
  }

  Future<bool> deletePriceItem(String itemId) async {
    final listId = state.selectedListId;
    if (listId == null) return false;

    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final result = await _repository.deletePriceItem(listId, itemId);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (_) {
        emit(state.copyWith(
          isSaving: false,
          successMessage: 'Price removed.',
        ));
        loadItems();
        return true;
      },
    );
  }

  Future<AdjustPricesResponseModel?> previewAdjust({
    required String percent,
    String? categoryId,
    String? roundTo,
  }) async {
    final listId = state.selectedListId;
    if (listId == null) return null;

    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price editing requires an active internet connection.'));
      return null;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = {
      'percent': percent.trim(),
      if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
      if (roundTo != null && roundTo.isNotEmpty) 'round_to': roundTo,
      'dry_run': true,
    };

    final result = await _repository.adjustPriceList(listId, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return null;
      },
      (preview) {
        emit(state.copyWith(
          isSaving: false,
          adjustPreview: preview,
        ));
        return preview;
      },
    );
  }

  Future<bool> applyAdjust({
    required String percent,
    String? categoryId,
    String? roundTo,
  }) async {
    final listId = state.selectedListId;
    if (listId == null) return false;

    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price editing requires an active internet connection.'));
      return false;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = {
      'percent': percent.trim(),
      if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
      if (roundTo != null && roundTo.isNotEmpty) 'round_to': roundTo,
      'dry_run': false,
    };

    final result = await _repository.adjustPriceList(listId, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return false;
      },
      (resp) {
        emit(state.copyWith(
          isSaving: false,
          clearAdjustPreview: true,
          successMessage: 'Adjusted ${resp.updated} prices (${resp.unchanged} unchanged).',
        ));
        loadPriceLists(preferredSelectedId: listId);
        return true;
      },
    );
  }

  Future<Map<String, dynamic>?> importCsv({
    required String csvContent,
    required bool dryRun,
    required String onError,
  }) async {
    final listId = state.selectedListId;
    if (listId == null) return null;

    if (!await _checkOnline()) {
      emit(state.copyWith(errorMessage: 'Price import requires an active internet connection.'));
      return null;
    }

    emit(state.copyWith(isSaving: true, clearError: true));
    final body = {
      'csv': csvContent,
      'dry_run': dryRun,
      'on_error': onError,
    };

    final result = await _repository.importPriceListCsv(listId, body);
    return result.fold(
      (failure) {
        emit(state.copyWith(isSaving: false, errorMessage: failure.message));
        return null;
      },
      (report) {
        emit(state.copyWith(
          isSaving: false,
          successMessage: !dryRun ? 'Price list import applied successfully.' : null,
        ));
        if (!dryRun) {
          loadPriceLists(preferredSelectedId: listId);
        }
        return report;
      },
    );
  }
}
