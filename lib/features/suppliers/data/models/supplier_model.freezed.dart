// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) {
  return _SupplierModel.fromJson(json);
}

/// @nodoc
mixin _$SupplierModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'contact_person')
  String? get contactPerson => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_id')
  String? get taxId => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_terms_days')
  int get paymentTermsDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this SupplierModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplierModelCopyWith<SupplierModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierModelCopyWith<$Res> {
  factory $SupplierModelCopyWith(
    SupplierModel value,
    $Res Function(SupplierModel) then,
  ) = _$SupplierModelCopyWithImpl<$Res, SupplierModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'contact_person') String? contactPerson,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    @JsonKey(name: 'payment_terms_days') int paymentTermsDays,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class _$SupplierModelCopyWithImpl<$Res, $Val extends SupplierModel>
    implements $SupplierModelCopyWith<$Res> {
  _$SupplierModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? contactPerson = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? taxId = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? paymentTermsDays = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            businessId: null == businessId
                ? _value.businessId
                : businessId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            contactPerson: freezed == contactPerson
                ? _value.contactPerson
                : contactPerson // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            taxId: freezed == taxId
                ? _value.taxId
                : taxId // ignore: cast_nullable_to_non_nullable
                      as String?,
            addressLine1: freezed == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            paymentTermsDays: null == paymentTermsDays
                ? _value.paymentTermsDays
                : paymentTermsDays // ignore: cast_nullable_to_non_nullable
                      as int,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupplierModelImplCopyWith<$Res>
    implements $SupplierModelCopyWith<$Res> {
  factory _$$SupplierModelImplCopyWith(
    _$SupplierModelImpl value,
    $Res Function(_$SupplierModelImpl) then,
  ) = __$$SupplierModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    String name,
    @JsonKey(name: 'contact_person') String? contactPerson,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    String? city,
    @JsonKey(name: 'payment_terms_days') int paymentTermsDays,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  });
}

/// @nodoc
class __$$SupplierModelImplCopyWithImpl<$Res>
    extends _$SupplierModelCopyWithImpl<$Res, _$SupplierModelImpl>
    implements _$$SupplierModelImplCopyWith<$Res> {
  __$$SupplierModelImplCopyWithImpl(
    _$SupplierModelImpl _value,
    $Res Function(_$SupplierModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? name = null,
    Object? contactPerson = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? taxId = freezed,
    Object? addressLine1 = freezed,
    Object? city = freezed,
    Object? paymentTermsDays = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$SupplierModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        contactPerson: freezed == contactPerson
            ? _value.contactPerson
            : contactPerson // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        taxId: freezed == taxId
            ? _value.taxId
            : taxId // ignore: cast_nullable_to_non_nullable
                  as String?,
        addressLine1: freezed == addressLine1
            ? _value.addressLine1
            : addressLine1 // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        paymentTermsDays: null == paymentTermsDays
            ? _value.paymentTermsDays
            : paymentTermsDays // ignore: cast_nullable_to_non_nullable
                  as int,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierModelImpl implements _SupplierModel {
  const _$SupplierModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    required this.name,
    @JsonKey(name: 'contact_person') this.contactPerson,
    this.email,
    this.phone,
    @JsonKey(name: 'tax_id') this.taxId,
    @JsonKey(name: 'address_line1') this.addressLine1,
    this.city,
    @JsonKey(name: 'payment_terms_days') this.paymentTermsDays = 30,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  });

  factory _$SupplierModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  final String name;
  @override
  @JsonKey(name: 'contact_person')
  final String? contactPerson;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'tax_id')
  final String? taxId;
  @override
  @JsonKey(name: 'address_line1')
  final String? addressLine1;
  @override
  final String? city;
  @override
  @JsonKey(name: 'payment_terms_days')
  final int paymentTermsDays;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @override
  String toString() {
    return 'SupplierModel(id: $id, businessId: $businessId, name: $name, contactPerson: $contactPerson, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, city: $city, paymentTermsDays: $paymentTermsDays, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.contactPerson, contactPerson) ||
                other.contactPerson == contactPerson) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.paymentTermsDays, paymentTermsDays) ||
                other.paymentTermsDays == paymentTermsDays) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    name,
    contactPerson,
    email,
    phone,
    taxId,
    addressLine1,
    city,
    paymentTermsDays,
    isActive,
    createdAt,
    updatedAt,
  );

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierModelImplCopyWith<_$SupplierModelImpl> get copyWith =>
      __$$SupplierModelImplCopyWithImpl<_$SupplierModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplierModelImplToJson(this);
  }
}

abstract class _SupplierModel implements SupplierModel {
  const factory _SupplierModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    required final String name,
    @JsonKey(name: 'contact_person') final String? contactPerson,
    final String? email,
    final String? phone,
    @JsonKey(name: 'tax_id') final String? taxId,
    @JsonKey(name: 'address_line1') final String? addressLine1,
    final String? city,
    @JsonKey(name: 'payment_terms_days') final int paymentTermsDays,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'updated_at') final String? updatedAt,
  }) = _$SupplierModelImpl;

  factory _SupplierModel.fromJson(Map<String, dynamic> json) =
      _$SupplierModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  String get name;
  @override
  @JsonKey(name: 'contact_person')
  String? get contactPerson;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  @JsonKey(name: 'tax_id')
  String? get taxId;
  @override
  @JsonKey(name: 'address_line1')
  String? get addressLine1;
  @override
  String? get city;
  @override
  @JsonKey(name: 'payment_terms_days')
  int get paymentTermsDays;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;

  /// Create a copy of SupplierModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplierModelImplCopyWith<_$SupplierModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SupplierBalanceModel _$SupplierBalanceModelFromJson(Map<String, dynamic> json) {
  return _SupplierBalanceModel.fromJson(json);
}

/// @nodoc
mixin _$SupplierBalanceModel {
  @JsonKey(name: 'supplier_id')
  String get supplierId => throw _privateConstructorUsedError;
  String get balance => throw _privateConstructorUsedError;

  /// Serializes this SupplierBalanceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupplierBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupplierBalanceModelCopyWith<SupplierBalanceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupplierBalanceModelCopyWith<$Res> {
  factory $SupplierBalanceModelCopyWith(
    SupplierBalanceModel value,
    $Res Function(SupplierBalanceModel) then,
  ) = _$SupplierBalanceModelCopyWithImpl<$Res, SupplierBalanceModel>;
  @useResult
  $Res call({@JsonKey(name: 'supplier_id') String supplierId, String balance});
}

/// @nodoc
class _$SupplierBalanceModelCopyWithImpl<
  $Res,
  $Val extends SupplierBalanceModel
>
    implements $SupplierBalanceModelCopyWith<$Res> {
  _$SupplierBalanceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupplierBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? supplierId = null, Object? balance = null}) {
    return _then(
      _value.copyWith(
            supplierId: null == supplierId
                ? _value.supplierId
                : supplierId // ignore: cast_nullable_to_non_nullable
                      as String,
            balance: null == balance
                ? _value.balance
                : balance // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SupplierBalanceModelImplCopyWith<$Res>
    implements $SupplierBalanceModelCopyWith<$Res> {
  factory _$$SupplierBalanceModelImplCopyWith(
    _$SupplierBalanceModelImpl value,
    $Res Function(_$SupplierBalanceModelImpl) then,
  ) = __$$SupplierBalanceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'supplier_id') String supplierId, String balance});
}

/// @nodoc
class __$$SupplierBalanceModelImplCopyWithImpl<$Res>
    extends _$SupplierBalanceModelCopyWithImpl<$Res, _$SupplierBalanceModelImpl>
    implements _$$SupplierBalanceModelImplCopyWith<$Res> {
  __$$SupplierBalanceModelImplCopyWithImpl(
    _$SupplierBalanceModelImpl _value,
    $Res Function(_$SupplierBalanceModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupplierBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? supplierId = null, Object? balance = null}) {
    return _then(
      _$SupplierBalanceModelImpl(
        supplierId: null == supplierId
            ? _value.supplierId
            : supplierId // ignore: cast_nullable_to_non_nullable
                  as String,
        balance: null == balance
            ? _value.balance
            : balance // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupplierBalanceModelImpl implements _SupplierBalanceModel {
  const _$SupplierBalanceModelImpl({
    @JsonKey(name: 'supplier_id') required this.supplierId,
    required this.balance,
  });

  factory _$SupplierBalanceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupplierBalanceModelImplFromJson(json);

  @override
  @JsonKey(name: 'supplier_id')
  final String supplierId;
  @override
  final String balance;

  @override
  String toString() {
    return 'SupplierBalanceModel(supplierId: $supplierId, balance: $balance)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupplierBalanceModelImpl &&
            (identical(other.supplierId, supplierId) ||
                other.supplierId == supplierId) &&
            (identical(other.balance, balance) || other.balance == balance));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, supplierId, balance);

  /// Create a copy of SupplierBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupplierBalanceModelImplCopyWith<_$SupplierBalanceModelImpl>
  get copyWith =>
      __$$SupplierBalanceModelImplCopyWithImpl<_$SupplierBalanceModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SupplierBalanceModelImplToJson(this);
  }
}

abstract class _SupplierBalanceModel implements SupplierBalanceModel {
  const factory _SupplierBalanceModel({
    @JsonKey(name: 'supplier_id') required final String supplierId,
    required final String balance,
  }) = _$SupplierBalanceModelImpl;

  factory _SupplierBalanceModel.fromJson(Map<String, dynamic> json) =
      _$SupplierBalanceModelImpl.fromJson;

  @override
  @JsonKey(name: 'supplier_id')
  String get supplierId;
  @override
  String get balance;

  /// Create a copy of SupplierBalanceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupplierBalanceModelImplCopyWith<_$SupplierBalanceModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
