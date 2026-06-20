// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PosState {
  RegisterShiftModel? get activeShift => throw _privateConstructorUsedError;
  ShiftSummaryModel? get shiftSummary => throw _privateConstructorUsedError;
  List<CashRegisterModel> get registers => throw _privateConstructorUsedError;
  String? get selectedRegisterId => throw _privateConstructorUsedError;
  bool get isCheckingShift => throw _privateConstructorUsedError;
  bool get isOpeningShift => throw _privateConstructorUsedError;
  bool get isCreatingRegister => throw _privateConstructorUsedError;
  String? get registersError => throw _privateConstructorUsedError;
  List<ProductListItemModel> get products => throw _privateConstructorUsedError;
  List<CategoryModel> get categories => throw _privateConstructorUsedError;
  String? get selectedCategoryId => throw _privateConstructorUsedError;
  String get productSearchQuery => throw _privateConstructorUsedError;
  bool get isLoadingProducts => throw _privateConstructorUsedError;
  String? get productsError => throw _privateConstructorUsedError;
  List<CartItemModel> get cartItems => throw _privateConstructorUsedError;
  CustomerModel? get selectedCustomer => throw _privateConstructorUsedError;
  String? get cartDiscountType => throw _privateConstructorUsedError;
  String? get cartDiscountValue => throw _privateConstructorUsedError;
  String? get cartNote => throw _privateConstructorUsedError;
  Map<String, String> get priceCache => throw _privateConstructorUsedError;
  Map<String, ProductModel> get productDetailsCache =>
      throw _privateConstructorUsedError;
  bool get isSubmittingSale => throw _privateConstructorUsedError;
  bool get isOffline => throw _privateConstructorUsedError;
  String? get cashierName => throw _privateConstructorUsedError;
  String? get branchId => throw _privateConstructorUsedError;
  String? get businessName => throw _privateConstructorUsedError;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PosStateCopyWith<PosState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosStateCopyWith<$Res> {
  factory $PosStateCopyWith(PosState value, $Res Function(PosState) then) =
      _$PosStateCopyWithImpl<$Res, PosState>;
  @useResult
  $Res call({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    bool isCheckingShift,
    bool isOpeningShift,
    bool isCreatingRegister,
    String? registersError,
    List<ProductListItemModel> products,
    List<CategoryModel> categories,
    String? selectedCategoryId,
    String productSearchQuery,
    bool isLoadingProducts,
    String? productsError,
    List<CartItemModel> cartItems,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    Map<String, String> priceCache,
    Map<String, ProductModel> productDetailsCache,
    bool isSubmittingSale,
    bool isOffline,
    String? cashierName,
    String? branchId,
    String? businessName,
  });

  $RegisterShiftModelCopyWith<$Res>? get activeShift;
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary;
  $CustomerModelCopyWith<$Res>? get selectedCustomer;
}

/// @nodoc
class _$PosStateCopyWithImpl<$Res, $Val extends PosState>
    implements $PosStateCopyWith<$Res> {
  _$PosStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeShift = freezed,
    Object? shiftSummary = freezed,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? isCheckingShift = null,
    Object? isOpeningShift = null,
    Object? isCreatingRegister = null,
    Object? registersError = freezed,
    Object? products = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? productSearchQuery = null,
    Object? isLoadingProducts = null,
    Object? productsError = freezed,
    Object? cartItems = null,
    Object? selectedCustomer = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? cartNote = freezed,
    Object? priceCache = null,
    Object? productDetailsCache = null,
    Object? isSubmittingSale = null,
    Object? isOffline = null,
    Object? cashierName = freezed,
    Object? branchId = freezed,
    Object? businessName = freezed,
  }) {
    return _then(
      _value.copyWith(
            activeShift: freezed == activeShift
                ? _value.activeShift
                : activeShift // ignore: cast_nullable_to_non_nullable
                      as RegisterShiftModel?,
            shiftSummary: freezed == shiftSummary
                ? _value.shiftSummary
                : shiftSummary // ignore: cast_nullable_to_non_nullable
                      as ShiftSummaryModel?,
            registers: null == registers
                ? _value.registers
                : registers // ignore: cast_nullable_to_non_nullable
                      as List<CashRegisterModel>,
            selectedRegisterId: freezed == selectedRegisterId
                ? _value.selectedRegisterId
                : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCheckingShift: null == isCheckingShift
                ? _value.isCheckingShift
                : isCheckingShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            isOpeningShift: null == isOpeningShift
                ? _value.isOpeningShift
                : isOpeningShift // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCreatingRegister: null == isCreatingRegister
                ? _value.isCreatingRegister
                : isCreatingRegister // ignore: cast_nullable_to_non_nullable
                      as bool,
            registersError: freezed == registersError
                ? _value.registersError
                : registersError // ignore: cast_nullable_to_non_nullable
                      as String?,
            products: null == products
                ? _value.products
                : products // ignore: cast_nullable_to_non_nullable
                      as List<ProductListItemModel>,
            categories: null == categories
                ? _value.categories
                : categories // ignore: cast_nullable_to_non_nullable
                      as List<CategoryModel>,
            selectedCategoryId: freezed == selectedCategoryId
                ? _value.selectedCategoryId
                : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                      as String?,
            productSearchQuery: null == productSearchQuery
                ? _value.productSearchQuery
                : productSearchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            isLoadingProducts: null == isLoadingProducts
                ? _value.isLoadingProducts
                : isLoadingProducts // ignore: cast_nullable_to_non_nullable
                      as bool,
            productsError: freezed == productsError
                ? _value.productsError
                : productsError // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartItems: null == cartItems
                ? _value.cartItems
                : cartItems // ignore: cast_nullable_to_non_nullable
                      as List<CartItemModel>,
            selectedCustomer: freezed == selectedCustomer
                ? _value.selectedCustomer
                : selectedCustomer // ignore: cast_nullable_to_non_nullable
                      as CustomerModel?,
            cartDiscountType: freezed == cartDiscountType
                ? _value.cartDiscountType
                : cartDiscountType // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartDiscountValue: freezed == cartDiscountValue
                ? _value.cartDiscountValue
                : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            cartNote: freezed == cartNote
                ? _value.cartNote
                : cartNote // ignore: cast_nullable_to_non_nullable
                      as String?,
            priceCache: null == priceCache
                ? _value.priceCache
                : priceCache // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
            productDetailsCache: null == productDetailsCache
                ? _value.productDetailsCache
                : productDetailsCache // ignore: cast_nullable_to_non_nullable
                      as Map<String, ProductModel>,
            isSubmittingSale: null == isSubmittingSale
                ? _value.isSubmittingSale
                : isSubmittingSale // ignore: cast_nullable_to_non_nullable
                      as bool,
            isOffline: null == isOffline
                ? _value.isOffline
                : isOffline // ignore: cast_nullable_to_non_nullable
                      as bool,
            cashierName: freezed == cashierName
                ? _value.cashierName
                : cashierName // ignore: cast_nullable_to_non_nullable
                      as String?,
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            businessName: freezed == businessName
                ? _value.businessName
                : businessName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RegisterShiftModelCopyWith<$Res>? get activeShift {
    if (_value.activeShift == null) {
      return null;
    }

    return $RegisterShiftModelCopyWith<$Res>(_value.activeShift!, (value) {
      return _then(_value.copyWith(activeShift: value) as $Val);
    });
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary {
    if (_value.shiftSummary == null) {
      return null;
    }

    return $ShiftSummaryModelCopyWith<$Res>(_value.shiftSummary!, (value) {
      return _then(_value.copyWith(shiftSummary: value) as $Val);
    });
  }

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get selectedCustomer {
    if (_value.selectedCustomer == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.selectedCustomer!, (value) {
      return _then(_value.copyWith(selectedCustomer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PosStateImplCopyWith<$Res>
    implements $PosStateCopyWith<$Res> {
  factory _$$PosStateImplCopyWith(
    _$PosStateImpl value,
    $Res Function(_$PosStateImpl) then,
  ) = __$$PosStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RegisterShiftModel? activeShift,
    ShiftSummaryModel? shiftSummary,
    List<CashRegisterModel> registers,
    String? selectedRegisterId,
    bool isCheckingShift,
    bool isOpeningShift,
    bool isCreatingRegister,
    String? registersError,
    List<ProductListItemModel> products,
    List<CategoryModel> categories,
    String? selectedCategoryId,
    String productSearchQuery,
    bool isLoadingProducts,
    String? productsError,
    List<CartItemModel> cartItems,
    CustomerModel? selectedCustomer,
    String? cartDiscountType,
    String? cartDiscountValue,
    String? cartNote,
    Map<String, String> priceCache,
    Map<String, ProductModel> productDetailsCache,
    bool isSubmittingSale,
    bool isOffline,
    String? cashierName,
    String? branchId,
    String? businessName,
  });

  @override
  $RegisterShiftModelCopyWith<$Res>? get activeShift;
  @override
  $ShiftSummaryModelCopyWith<$Res>? get shiftSummary;
  @override
  $CustomerModelCopyWith<$Res>? get selectedCustomer;
}

/// @nodoc
class __$$PosStateImplCopyWithImpl<$Res>
    extends _$PosStateCopyWithImpl<$Res, _$PosStateImpl>
    implements _$$PosStateImplCopyWith<$Res> {
  __$$PosStateImplCopyWithImpl(
    _$PosStateImpl _value,
    $Res Function(_$PosStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeShift = freezed,
    Object? shiftSummary = freezed,
    Object? registers = null,
    Object? selectedRegisterId = freezed,
    Object? isCheckingShift = null,
    Object? isOpeningShift = null,
    Object? isCreatingRegister = null,
    Object? registersError = freezed,
    Object? products = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? productSearchQuery = null,
    Object? isLoadingProducts = null,
    Object? productsError = freezed,
    Object? cartItems = null,
    Object? selectedCustomer = freezed,
    Object? cartDiscountType = freezed,
    Object? cartDiscountValue = freezed,
    Object? cartNote = freezed,
    Object? priceCache = null,
    Object? productDetailsCache = null,
    Object? isSubmittingSale = null,
    Object? isOffline = null,
    Object? cashierName = freezed,
    Object? branchId = freezed,
    Object? businessName = freezed,
  }) {
    return _then(
      _$PosStateImpl(
        activeShift: freezed == activeShift
            ? _value.activeShift
            : activeShift // ignore: cast_nullable_to_non_nullable
                  as RegisterShiftModel?,
        shiftSummary: freezed == shiftSummary
            ? _value.shiftSummary
            : shiftSummary // ignore: cast_nullable_to_non_nullable
                  as ShiftSummaryModel?,
        registers: null == registers
            ? _value._registers
            : registers // ignore: cast_nullable_to_non_nullable
                  as List<CashRegisterModel>,
        selectedRegisterId: freezed == selectedRegisterId
            ? _value.selectedRegisterId
            : selectedRegisterId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCheckingShift: null == isCheckingShift
            ? _value.isCheckingShift
            : isCheckingShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOpeningShift: null == isOpeningShift
            ? _value.isOpeningShift
            : isOpeningShift // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCreatingRegister: null == isCreatingRegister
            ? _value.isCreatingRegister
            : isCreatingRegister // ignore: cast_nullable_to_non_nullable
                  as bool,
        registersError: freezed == registersError
            ? _value.registersError
            : registersError // ignore: cast_nullable_to_non_nullable
                  as String?,
        products: null == products
            ? _value._products
            : products // ignore: cast_nullable_to_non_nullable
                  as List<ProductListItemModel>,
        categories: null == categories
            ? _value._categories
            : categories // ignore: cast_nullable_to_non_nullable
                  as List<CategoryModel>,
        selectedCategoryId: freezed == selectedCategoryId
            ? _value.selectedCategoryId
            : selectedCategoryId // ignore: cast_nullable_to_non_nullable
                  as String?,
        productSearchQuery: null == productSearchQuery
            ? _value.productSearchQuery
            : productSearchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        isLoadingProducts: null == isLoadingProducts
            ? _value.isLoadingProducts
            : isLoadingProducts // ignore: cast_nullable_to_non_nullable
                  as bool,
        productsError: freezed == productsError
            ? _value.productsError
            : productsError // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartItems: null == cartItems
            ? _value._cartItems
            : cartItems // ignore: cast_nullable_to_non_nullable
                  as List<CartItemModel>,
        selectedCustomer: freezed == selectedCustomer
            ? _value.selectedCustomer
            : selectedCustomer // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        cartDiscountType: freezed == cartDiscountType
            ? _value.cartDiscountType
            : cartDiscountType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartDiscountValue: freezed == cartDiscountValue
            ? _value.cartDiscountValue
            : cartDiscountValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        cartNote: freezed == cartNote
            ? _value.cartNote
            : cartNote // ignore: cast_nullable_to_non_nullable
                  as String?,
        priceCache: null == priceCache
            ? _value._priceCache
            : priceCache // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
        productDetailsCache: null == productDetailsCache
            ? _value._productDetailsCache
            : productDetailsCache // ignore: cast_nullable_to_non_nullable
                  as Map<String, ProductModel>,
        isSubmittingSale: null == isSubmittingSale
            ? _value.isSubmittingSale
            : isSubmittingSale // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOffline: null == isOffline
            ? _value.isOffline
            : isOffline // ignore: cast_nullable_to_non_nullable
                  as bool,
        cashierName: freezed == cashierName
            ? _value.cashierName
            : cashierName // ignore: cast_nullable_to_non_nullable
                  as String?,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        businessName: freezed == businessName
            ? _value.businessName
            : businessName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$PosStateImpl extends _PosState {
  const _$PosStateImpl({
    this.activeShift,
    this.shiftSummary,
    final List<CashRegisterModel> registers = const [],
    this.selectedRegisterId,
    this.isCheckingShift = true,
    this.isOpeningShift = false,
    this.isCreatingRegister = false,
    this.registersError,
    final List<ProductListItemModel> products = const [],
    final List<CategoryModel> categories = const [],
    this.selectedCategoryId,
    this.productSearchQuery = '',
    this.isLoadingProducts = true,
    this.productsError,
    final List<CartItemModel> cartItems = const [],
    this.selectedCustomer,
    this.cartDiscountType,
    this.cartDiscountValue,
    this.cartNote,
    final Map<String, String> priceCache = const {},
    final Map<String, ProductModel> productDetailsCache = const {},
    this.isSubmittingSale = false,
    this.isOffline = false,
    this.cashierName,
    this.branchId,
    this.businessName,
  }) : _registers = registers,
       _products = products,
       _categories = categories,
       _cartItems = cartItems,
       _priceCache = priceCache,
       _productDetailsCache = productDetailsCache,
       super._();

  @override
  final RegisterShiftModel? activeShift;
  @override
  final ShiftSummaryModel? shiftSummary;
  final List<CashRegisterModel> _registers;
  @override
  @JsonKey()
  List<CashRegisterModel> get registers {
    if (_registers is EqualUnmodifiableListView) return _registers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_registers);
  }

  @override
  final String? selectedRegisterId;
  @override
  @JsonKey()
  final bool isCheckingShift;
  @override
  @JsonKey()
  final bool isOpeningShift;
  @override
  @JsonKey()
  final bool isCreatingRegister;
  @override
  final String? registersError;
  final List<ProductListItemModel> _products;
  @override
  @JsonKey()
  List<ProductListItemModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<CategoryModel> _categories;
  @override
  @JsonKey()
  List<CategoryModel> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? selectedCategoryId;
  @override
  @JsonKey()
  final String productSearchQuery;
  @override
  @JsonKey()
  final bool isLoadingProducts;
  @override
  final String? productsError;
  final List<CartItemModel> _cartItems;
  @override
  @JsonKey()
  List<CartItemModel> get cartItems {
    if (_cartItems is EqualUnmodifiableListView) return _cartItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cartItems);
  }

  @override
  final CustomerModel? selectedCustomer;
  @override
  final String? cartDiscountType;
  @override
  final String? cartDiscountValue;
  @override
  final String? cartNote;
  final Map<String, String> _priceCache;
  @override
  @JsonKey()
  Map<String, String> get priceCache {
    if (_priceCache is EqualUnmodifiableMapView) return _priceCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_priceCache);
  }

  final Map<String, ProductModel> _productDetailsCache;
  @override
  @JsonKey()
  Map<String, ProductModel> get productDetailsCache {
    if (_productDetailsCache is EqualUnmodifiableMapView)
      return _productDetailsCache;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_productDetailsCache);
  }

  @override
  @JsonKey()
  final bool isSubmittingSale;
  @override
  @JsonKey()
  final bool isOffline;
  @override
  final String? cashierName;
  @override
  final String? branchId;
  @override
  final String? businessName;

  @override
  String toString() {
    return 'PosState(activeShift: $activeShift, shiftSummary: $shiftSummary, registers: $registers, selectedRegisterId: $selectedRegisterId, isCheckingShift: $isCheckingShift, isOpeningShift: $isOpeningShift, isCreatingRegister: $isCreatingRegister, registersError: $registersError, products: $products, categories: $categories, selectedCategoryId: $selectedCategoryId, productSearchQuery: $productSearchQuery, isLoadingProducts: $isLoadingProducts, productsError: $productsError, cartItems: $cartItems, selectedCustomer: $selectedCustomer, cartDiscountType: $cartDiscountType, cartDiscountValue: $cartDiscountValue, cartNote: $cartNote, priceCache: $priceCache, productDetailsCache: $productDetailsCache, isSubmittingSale: $isSubmittingSale, isOffline: $isOffline, cashierName: $cashierName, branchId: $branchId, businessName: $businessName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PosStateImpl &&
            (identical(other.activeShift, activeShift) ||
                other.activeShift == activeShift) &&
            (identical(other.shiftSummary, shiftSummary) ||
                other.shiftSummary == shiftSummary) &&
            const DeepCollectionEquality().equals(
              other._registers,
              _registers,
            ) &&
            (identical(other.selectedRegisterId, selectedRegisterId) ||
                other.selectedRegisterId == selectedRegisterId) &&
            (identical(other.isCheckingShift, isCheckingShift) ||
                other.isCheckingShift == isCheckingShift) &&
            (identical(other.isOpeningShift, isOpeningShift) ||
                other.isOpeningShift == isOpeningShift) &&
            (identical(other.isCreatingRegister, isCreatingRegister) ||
                other.isCreatingRegister == isCreatingRegister) &&
            (identical(other.registersError, registersError) ||
                other.registersError == registersError) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality().equals(
              other._categories,
              _categories,
            ) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.productSearchQuery, productSearchQuery) ||
                other.productSearchQuery == productSearchQuery) &&
            (identical(other.isLoadingProducts, isLoadingProducts) ||
                other.isLoadingProducts == isLoadingProducts) &&
            (identical(other.productsError, productsError) ||
                other.productsError == productsError) &&
            const DeepCollectionEquality().equals(
              other._cartItems,
              _cartItems,
            ) &&
            (identical(other.selectedCustomer, selectedCustomer) ||
                other.selectedCustomer == selectedCustomer) &&
            (identical(other.cartDiscountType, cartDiscountType) ||
                other.cartDiscountType == cartDiscountType) &&
            (identical(other.cartDiscountValue, cartDiscountValue) ||
                other.cartDiscountValue == cartDiscountValue) &&
            (identical(other.cartNote, cartNote) ||
                other.cartNote == cartNote) &&
            const DeepCollectionEquality().equals(
              other._priceCache,
              _priceCache,
            ) &&
            const DeepCollectionEquality().equals(
              other._productDetailsCache,
              _productDetailsCache,
            ) &&
            (identical(other.isSubmittingSale, isSubmittingSale) ||
                other.isSubmittingSale == isSubmittingSale) &&
            (identical(other.isOffline, isOffline) ||
                other.isOffline == isOffline) &&
            (identical(other.cashierName, cashierName) ||
                other.cashierName == cashierName) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    activeShift,
    shiftSummary,
    const DeepCollectionEquality().hash(_registers),
    selectedRegisterId,
    isCheckingShift,
    isOpeningShift,
    isCreatingRegister,
    registersError,
    const DeepCollectionEquality().hash(_products),
    const DeepCollectionEquality().hash(_categories),
    selectedCategoryId,
    productSearchQuery,
    isLoadingProducts,
    productsError,
    const DeepCollectionEquality().hash(_cartItems),
    selectedCustomer,
    cartDiscountType,
    cartDiscountValue,
    cartNote,
    const DeepCollectionEquality().hash(_priceCache),
    const DeepCollectionEquality().hash(_productDetailsCache),
    isSubmittingSale,
    isOffline,
    cashierName,
    branchId,
    businessName,
  ]);

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PosStateImplCopyWith<_$PosStateImpl> get copyWith =>
      __$$PosStateImplCopyWithImpl<_$PosStateImpl>(this, _$identity);
}

abstract class _PosState extends PosState {
  const factory _PosState({
    final RegisterShiftModel? activeShift,
    final ShiftSummaryModel? shiftSummary,
    final List<CashRegisterModel> registers,
    final String? selectedRegisterId,
    final bool isCheckingShift,
    final bool isOpeningShift,
    final bool isCreatingRegister,
    final String? registersError,
    final List<ProductListItemModel> products,
    final List<CategoryModel> categories,
    final String? selectedCategoryId,
    final String productSearchQuery,
    final bool isLoadingProducts,
    final String? productsError,
    final List<CartItemModel> cartItems,
    final CustomerModel? selectedCustomer,
    final String? cartDiscountType,
    final String? cartDiscountValue,
    final String? cartNote,
    final Map<String, String> priceCache,
    final Map<String, ProductModel> productDetailsCache,
    final bool isSubmittingSale,
    final bool isOffline,
    final String? cashierName,
    final String? branchId,
    final String? businessName,
  }) = _$PosStateImpl;
  const _PosState._() : super._();

  @override
  RegisterShiftModel? get activeShift;
  @override
  ShiftSummaryModel? get shiftSummary;
  @override
  List<CashRegisterModel> get registers;
  @override
  String? get selectedRegisterId;
  @override
  bool get isCheckingShift;
  @override
  bool get isOpeningShift;
  @override
  bool get isCreatingRegister;
  @override
  String? get registersError;
  @override
  List<ProductListItemModel> get products;
  @override
  List<CategoryModel> get categories;
  @override
  String? get selectedCategoryId;
  @override
  String get productSearchQuery;
  @override
  bool get isLoadingProducts;
  @override
  String? get productsError;
  @override
  List<CartItemModel> get cartItems;
  @override
  CustomerModel? get selectedCustomer;
  @override
  String? get cartDiscountType;
  @override
  String? get cartDiscountValue;
  @override
  String? get cartNote;
  @override
  Map<String, String> get priceCache;
  @override
  Map<String, ProductModel> get productDetailsCache;
  @override
  bool get isSubmittingSale;
  @override
  bool get isOffline;
  @override
  String? get cashierName;
  @override
  String? get branchId;
  @override
  String? get businessName;

  /// Create a copy of PosState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PosStateImplCopyWith<_$PosStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
