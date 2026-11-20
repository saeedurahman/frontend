import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/platform/image_picker_service.dart';
import 'package:frantend/core/services/image_upload_service.dart';
import 'package:frantend/features/products/data/models/category_model.dart';
import 'package:frantend/features/products/data/models/product_list_item_model.dart';
import 'package:frantend/features/products/data/models/product_model.dart';
import 'package:frantend/features/products/data/models/unit_model.dart';
import 'package:frantend/features/products/domain/repositories/products_repository.dart';

/// What the owner is filling in for the product on screen.
class CompleteDetailsState extends Equatable {
  const CompleteDetailsState({
    this.loading = true,
    this.items = const [],
    this.index = 0,
    this.done = 0,
    this.categories = const [],
    this.units = const [],
    this.detail,
    this.imageUrl,
    this.categoryId,
    this.unitId,
    this.minStock = '',
    this.price = '',
    this.uploading = false,
    this.saving = false,
    this.error,
    this.finished = false,
  });

  final bool loading;

  /// Products that still need details, in the order they are walked through.
  final List<ProductListItemModel> items;
  final int index;

  /// How many were completed in this session (the progress counter).
  final int done;
  final List<CategoryModel> categories;
  final List<UnitModel> units;

  /// The full product (variations, unit) of the one on screen.
  final ProductModel? detail;
  final String? imageUrl;
  final String? categoryId;
  final String? unitId;
  final String minStock;
  final String price;
  final bool uploading;
  final bool saving;
  final String? error;
  final bool finished;

  ProductListItemModel? get current =>
      index >= 0 && index < items.length ? items[index] : null;

  int get total => items.length;

  bool get needsPrice => current?.missing.contains('price') ?? false;

  CompleteDetailsState copyWith({
    bool? loading,
    List<ProductListItemModel>? items,
    int? index,
    int? done,
    List<CategoryModel>? categories,
    List<UnitModel>? units,
    ProductModel? detail,
    bool clearDetail = false,
    String? imageUrl,
    String? categoryId,
    String? unitId,
    String? minStock,
    String? price,
    bool? uploading,
    bool? saving,
    String? error,
    bool clearError = false,
    bool? finished,
  }) =>
      CompleteDetailsState(
        loading: loading ?? this.loading,
        items: items ?? this.items,
        index: index ?? this.index,
        done: done ?? this.done,
        categories: categories ?? this.categories,
        units: units ?? this.units,
        detail: clearDetail ? null : (detail ?? this.detail),
        imageUrl: imageUrl ?? this.imageUrl,
        categoryId: categoryId ?? this.categoryId,
        unitId: unitId ?? this.unitId,
        minStock: minStock ?? this.minStock,
        price: price ?? this.price,
        uploading: uploading ?? this.uploading,
        saving: saving ?? this.saving,
        error: clearError ? null : (error ?? this.error),
        finished: finished ?? this.finished,
      );

  @override
  List<Object?> get props => [
        loading,
        items,
        index,
        done,
        categories,
        units,
        detail,
        imageUrl,
        categoryId,
        unitId,
        minStock,
        price,
        uploading,
        saving,
        error,
        finished,
      ];
}

/// Walks through the products that "need details", one at a time: picture,
/// category, unit, minimum stock and (if missing) the sale price.
class CompleteDetailsCubit extends Cubit<CompleteDetailsState> {
  CompleteDetailsCubit({
    required ProductsRepository repository,
    required ImageUploadService imageUpload,
    ImagePickerService? imagePicker,
  })  : _repo = repository,
        _upload = imageUpload,
        _picker = imagePicker ?? const WindowsImagePickerService(),
        super(const CompleteDetailsState());

  final ProductsRepository _repo;
  final ImageUploadService _upload;
  final ImagePickerService _picker;
  String? _priceListId;

  Future<void> load() async {
    final result = await _repo.getProducts(needsAttention: true, isActive: true, limit: 200);
    final cats = await _repo.getCategories();
    final units = await _repo.getUnits();
    final lists = await _repo.getPriceLists();
    _priceListId = lists.fold(
      (_) => null,
      (all) {
        for (final l in all) {
          if (l.isDefault) return l.id;
        }
        return all.isEmpty ? null : all.first.id;
      },
    );
    if (isClosed) return;
    await result.fold(
      (f) async => emit(state.copyWith(loading: false, error: f.message, finished: true)),
      (page) async {
        emit(state.copyWith(
          loading: false,
          items: page.items,
          categories: cats.getOrElse(() => const []),
          units: units.getOrElse(() => const []),
          finished: page.items.isEmpty,
        ));
        await _open(0);
      },
    );
  }

  Future<void> _open(int index) async {
    if (isClosed) return;
    if (index >= state.items.length) {
      emit(state.copyWith(finished: true, index: index, clearDetail: true, clearError: true));
      return;
    }
    final item = state.items[index];
    emit(CompleteDetailsState(
      loading: false,
      items: state.items,
      index: index,
      done: state.done,
      categories: state.categories,
      units: state.units,
      imageUrl: item.imageUrl,
      categoryId: item.categoryId,
    ));
    final detail = await _repo.getProductById(item.id);
    if (isClosed || state.index != index) return;
    detail.fold((_) {}, (p) {
      final variation = p.variations.isEmpty ? null : p.variations.first;
      emit(state.copyWith(
        detail: p,
        unitId: variation?.unitId ?? p.baseUnit?.id,
        minStock: p.minStockLevel ?? '',
      ));
    });
  }

  void setCategory(String? id) => emit(state.copyWith(categoryId: id));
  void setUnit(String? id) => emit(state.copyWith(unitId: id));
  void setMinStock(String v) => emit(state.copyWith(minStock: v));
  void setPrice(String v) => emit(state.copyWith(price: v));

  /// Picks a picture and uploads it with the same service the product form uses.
  Future<void> pickImage() async {
    final path = await _picker.pickImage();
    if (path == null) return;
    emit(state.copyWith(uploading: true, clearError: true));
    try {
      final url = await _upload.uploadImage(File(path));
      emit(state.copyWith(uploading: false, imageUrl: url));
    } on ImageUploadException catch (e) {
      emit(state.copyWith(uploading: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(
        uploading: false,
        error: 'The picture could not be uploaded. Try again.',
      ));
    }
  }

  Future<void> skip() => _open(state.index + 1);

  /// Saves what was filled in, then shows the next product.
  Future<void> saveAndNext() async {
    final item = state.current;
    if (item == null || state.saving) return;
    emit(state.copyWith(saving: true, clearError: true));

    final body = <String, dynamic>{
      if (state.categoryId != null && state.categoryId != item.categoryId)
        'category_id': state.categoryId,
      if (state.imageUrl != null && state.imageUrl != item.imageUrl)
        'image_url': state.imageUrl,
      if (state.minStock.trim().isNotEmpty &&
          state.minStock.trim() != (state.detail?.minStockLevel ?? ''))
        'min_stock_level': state.minStock.trim(),
    };
    if (body.isNotEmpty) {
      final r = await _repo.updateProduct(item.id, body);
      final failed = r.fold((f) => f.message, (_) => null);
      if (failed != null) {
        emit(state.copyWith(saving: false, error: failed));
        return;
      }
    }

    final detail = state.detail;
    final variation =
        (detail == null || detail.variations.isEmpty) ? null : detail.variations.first;
    if (variation != null && state.unitId != null && state.unitId != variation.unitId) {
      final r = await _repo.updateVariation(item.id, variation.id, {'unit_id': state.unitId});
      final failed = r.fold((f) => f.message, (_) => null);
      if (failed != null) {
        emit(state.copyWith(saving: false, error: failed));
        return;
      }
    }

    final price = state.price.trim();
    if (state.needsPrice && price.isNotEmpty && _priceListId != null) {
      final r = await _repo.setProductPrice(item.id, _priceListId!, {
        'unit_price': price,
        if (variation != null) 'variation_id': variation.id,
      });
      final failed = r.fold((f) => f.message, (_) => null);
      if (failed != null) {
        emit(state.copyWith(saving: false, error: failed));
        return;
      }
    }

    emit(state.copyWith(saving: false, done: state.done + 1));
    await _open(state.index + 1);
  }
}
