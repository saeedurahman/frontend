// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BusinessTypeModel _$BusinessTypeModelFromJson(Map<String, dynamic> json) {
  return _BusinessTypeModel.fromJson(json);
}

/// @nodoc
mixin _$BusinessTypeModel {
  String get id => throw _privateConstructorUsedError;
  String get code => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this BusinessTypeModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessTypeModelCopyWith<BusinessTypeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessTypeModelCopyWith<$Res> {
  factory $BusinessTypeModelCopyWith(
    BusinessTypeModel value,
    $Res Function(BusinessTypeModel) then,
  ) = _$BusinessTypeModelCopyWithImpl<$Res, BusinessTypeModel>;
  @useResult
  $Res call({
    String id,
    String code,
    String name,
    String? description,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class _$BusinessTypeModelCopyWithImpl<$Res, $Val extends BusinessTypeModel>
    implements $BusinessTypeModelCopyWith<$Res> {
  _$BusinessTypeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            code: null == code
                ? _value.code
                : code // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BusinessTypeModelImplCopyWith<$Res>
    implements $BusinessTypeModelCopyWith<$Res> {
  factory _$$BusinessTypeModelImplCopyWith(
    _$BusinessTypeModelImpl value,
    $Res Function(_$BusinessTypeModelImpl) then,
  ) = __$$BusinessTypeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String code,
    String name,
    String? description,
    @JsonKey(name: 'is_active') bool isActive,
  });
}

/// @nodoc
class __$$BusinessTypeModelImplCopyWithImpl<$Res>
    extends _$BusinessTypeModelCopyWithImpl<$Res, _$BusinessTypeModelImpl>
    implements _$$BusinessTypeModelImplCopyWith<$Res> {
  __$$BusinessTypeModelImplCopyWithImpl(
    _$BusinessTypeModelImpl _value,
    $Res Function(_$BusinessTypeModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? code = null,
    Object? name = null,
    Object? description = freezed,
    Object? isActive = null,
  }) {
    return _then(
      _$BusinessTypeModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        code: null == code
            ? _value.code
            : code // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessTypeModelImpl implements _BusinessTypeModel {
  const _$BusinessTypeModelImpl({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    @JsonKey(name: 'is_active') this.isActive = true,
  });

  factory _$BusinessTypeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessTypeModelImplFromJson(json);

  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;

  @override
  String toString() {
    return 'BusinessTypeModel(id: $id, code: $code, name: $name, description: $description, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessTypeModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, code, name, description, isActive);

  /// Create a copy of BusinessTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessTypeModelImplCopyWith<_$BusinessTypeModelImpl> get copyWith =>
      __$$BusinessTypeModelImplCopyWithImpl<_$BusinessTypeModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessTypeModelImplToJson(this);
  }
}

abstract class _BusinessTypeModel implements BusinessTypeModel {
  const factory _BusinessTypeModel({
    required final String id,
    required final String code,
    required final String name,
    final String? description,
    @JsonKey(name: 'is_active') final bool isActive,
  }) = _$BusinessTypeModelImpl;

  factory _BusinessTypeModel.fromJson(Map<String, dynamic> json) =
      _$BusinessTypeModelImpl.fromJson;

  @override
  String get id;
  @override
  String get code;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;

  /// Create a copy of BusinessTypeModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessTypeModelImplCopyWith<_$BusinessTypeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BusinessProfileModel _$BusinessProfileModelFromJson(Map<String, dynamic> json) {
  return _BusinessProfileModel.fromJson(json);
}

/// @nodoc
mixin _$BusinessProfileModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'legal_name')
  String? get legalName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'tax_id')
  String? get taxId => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line1')
  String? get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'logo_url')
  String? get logoUrl => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'country_code')
  String get countryCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'currency_code')
  String get currencyCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_plan')
  String? get subscriptionPlan => throw _privateConstructorUsedError;
  @JsonKey(name: 'subscription_status')
  String? get subscriptionStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_type')
  BusinessTypeModel? get businessType => throw _privateConstructorUsedError;
  List<BranchModel> get branches => throw _privateConstructorUsedError;

  /// Serializes this BusinessProfileModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessProfileModelCopyWith<BusinessProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessProfileModelCopyWith<$Res> {
  factory $BusinessProfileModelCopyWith(
    BusinessProfileModel value,
    $Res Function(BusinessProfileModel) then,
  ) = _$BusinessProfileModelCopyWithImpl<$Res, BusinessProfileModel>;
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'legal_name') String? legalName,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? city,
    @JsonKey(name: 'country_code') String countryCode,
    @JsonKey(name: 'currency_code') String currencyCode,
    @JsonKey(name: 'subscription_plan') String? subscriptionPlan,
    @JsonKey(name: 'subscription_status') String? subscriptionStatus,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'business_type') BusinessTypeModel? businessType,
    List<BranchModel> branches,
  });

  $BusinessTypeModelCopyWith<$Res>? get businessType;
}

/// @nodoc
class _$BusinessProfileModelCopyWithImpl<
  $Res,
  $Val extends BusinessProfileModel
>
    implements $BusinessProfileModelCopyWith<$Res> {
  _$BusinessProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? legalName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? taxId = freezed,
    Object? addressLine1 = freezed,
    Object? logoUrl = freezed,
    Object? city = freezed,
    Object? countryCode = null,
    Object? currencyCode = null,
    Object? subscriptionPlan = freezed,
    Object? subscriptionStatus = freezed,
    Object? isActive = null,
    Object? businessType = freezed,
    Object? branches = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            legalName: freezed == legalName
                ? _value.legalName
                : legalName // ignore: cast_nullable_to_non_nullable
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
            logoUrl: freezed == logoUrl
                ? _value.logoUrl
                : logoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            city: freezed == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                      as String?,
            countryCode: null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                      as String,
            currencyCode: null == currencyCode
                ? _value.currencyCode
                : currencyCode // ignore: cast_nullable_to_non_nullable
                      as String,
            subscriptionPlan: freezed == subscriptionPlan
                ? _value.subscriptionPlan
                : subscriptionPlan // ignore: cast_nullable_to_non_nullable
                      as String?,
            subscriptionStatus: freezed == subscriptionStatus
                ? _value.subscriptionStatus
                : subscriptionStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            businessType: freezed == businessType
                ? _value.businessType
                : businessType // ignore: cast_nullable_to_non_nullable
                      as BusinessTypeModel?,
            branches: null == branches
                ? _value.branches
                : branches // ignore: cast_nullable_to_non_nullable
                      as List<BranchModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessTypeModelCopyWith<$Res>? get businessType {
    if (_value.businessType == null) {
      return null;
    }

    return $BusinessTypeModelCopyWith<$Res>(_value.businessType!, (value) {
      return _then(_value.copyWith(businessType: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BusinessProfileModelImplCopyWith<$Res>
    implements $BusinessProfileModelCopyWith<$Res> {
  factory _$$BusinessProfileModelImplCopyWith(
    _$BusinessProfileModelImpl value,
    $Res Function(_$BusinessProfileModelImpl) then,
  ) = __$$BusinessProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    @JsonKey(name: 'legal_name') String? legalName,
    String? email,
    String? phone,
    @JsonKey(name: 'tax_id') String? taxId,
    @JsonKey(name: 'address_line1') String? addressLine1,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? city,
    @JsonKey(name: 'country_code') String countryCode,
    @JsonKey(name: 'currency_code') String currencyCode,
    @JsonKey(name: 'subscription_plan') String? subscriptionPlan,
    @JsonKey(name: 'subscription_status') String? subscriptionStatus,
    @JsonKey(name: 'is_active') bool isActive,
    @JsonKey(name: 'business_type') BusinessTypeModel? businessType,
    List<BranchModel> branches,
  });

  @override
  $BusinessTypeModelCopyWith<$Res>? get businessType;
}

/// @nodoc
class __$$BusinessProfileModelImplCopyWithImpl<$Res>
    extends _$BusinessProfileModelCopyWithImpl<$Res, _$BusinessProfileModelImpl>
    implements _$$BusinessProfileModelImplCopyWith<$Res> {
  __$$BusinessProfileModelImplCopyWithImpl(
    _$BusinessProfileModelImpl _value,
    $Res Function(_$BusinessProfileModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? legalName = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? taxId = freezed,
    Object? addressLine1 = freezed,
    Object? logoUrl = freezed,
    Object? city = freezed,
    Object? countryCode = null,
    Object? currencyCode = null,
    Object? subscriptionPlan = freezed,
    Object? subscriptionStatus = freezed,
    Object? isActive = null,
    Object? businessType = freezed,
    Object? branches = null,
  }) {
    return _then(
      _$BusinessProfileModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        legalName: freezed == legalName
            ? _value.legalName
            : legalName // ignore: cast_nullable_to_non_nullable
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
        logoUrl: freezed == logoUrl
            ? _value.logoUrl
            : logoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        city: freezed == city
            ? _value.city
            : city // ignore: cast_nullable_to_non_nullable
                  as String?,
        countryCode: null == countryCode
            ? _value.countryCode
            : countryCode // ignore: cast_nullable_to_non_nullable
                  as String,
        currencyCode: null == currencyCode
            ? _value.currencyCode
            : currencyCode // ignore: cast_nullable_to_non_nullable
                  as String,
        subscriptionPlan: freezed == subscriptionPlan
            ? _value.subscriptionPlan
            : subscriptionPlan // ignore: cast_nullable_to_non_nullable
                  as String?,
        subscriptionStatus: freezed == subscriptionStatus
            ? _value.subscriptionStatus
            : subscriptionStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        businessType: freezed == businessType
            ? _value.businessType
            : businessType // ignore: cast_nullable_to_non_nullable
                  as BusinessTypeModel?,
        branches: null == branches
            ? _value._branches
            : branches // ignore: cast_nullable_to_non_nullable
                  as List<BranchModel>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessProfileModelImpl implements _BusinessProfileModel {
  const _$BusinessProfileModelImpl({
    required this.id,
    required this.name,
    @JsonKey(name: 'legal_name') this.legalName,
    this.email,
    this.phone,
    @JsonKey(name: 'tax_id') this.taxId,
    @JsonKey(name: 'address_line1') this.addressLine1,
    @JsonKey(name: 'logo_url') this.logoUrl,
    this.city,
    @JsonKey(name: 'country_code') this.countryCode = 'PK',
    @JsonKey(name: 'currency_code') this.currencyCode = 'PKR',
    @JsonKey(name: 'subscription_plan') this.subscriptionPlan,
    @JsonKey(name: 'subscription_status') this.subscriptionStatus,
    @JsonKey(name: 'is_active') this.isActive = true,
    @JsonKey(name: 'business_type') this.businessType,
    final List<BranchModel> branches = const [],
  }) : _branches = branches;

  factory _$BusinessProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessProfileModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'legal_name')
  final String? legalName;
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
  @JsonKey(name: 'logo_url')
  final String? logoUrl;
  @override
  final String? city;
  @override
  @JsonKey(name: 'country_code')
  final String countryCode;
  @override
  @JsonKey(name: 'currency_code')
  final String currencyCode;
  @override
  @JsonKey(name: 'subscription_plan')
  final String? subscriptionPlan;
  @override
  @JsonKey(name: 'subscription_status')
  final String? subscriptionStatus;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'business_type')
  final BusinessTypeModel? businessType;
  final List<BranchModel> _branches;
  @override
  @JsonKey()
  List<BranchModel> get branches {
    if (_branches is EqualUnmodifiableListView) return _branches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branches);
  }

  @override
  String toString() {
    return 'BusinessProfileModel(id: $id, name: $name, legalName: $legalName, email: $email, phone: $phone, taxId: $taxId, addressLine1: $addressLine1, logoUrl: $logoUrl, city: $city, countryCode: $countryCode, currencyCode: $currencyCode, subscriptionPlan: $subscriptionPlan, subscriptionStatus: $subscriptionStatus, isActive: $isActive, businessType: $businessType, branches: $branches)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.legalName, legalName) ||
                other.legalName == legalName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.taxId, taxId) || other.taxId == taxId) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.subscriptionPlan, subscriptionPlan) ||
                other.subscriptionPlan == subscriptionPlan) &&
            (identical(other.subscriptionStatus, subscriptionStatus) ||
                other.subscriptionStatus == subscriptionStatus) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.businessType, businessType) ||
                other.businessType == businessType) &&
            const DeepCollectionEquality().equals(other._branches, _branches));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    legalName,
    email,
    phone,
    taxId,
    addressLine1,
    logoUrl,
    city,
    countryCode,
    currencyCode,
    subscriptionPlan,
    subscriptionStatus,
    isActive,
    businessType,
    const DeepCollectionEquality().hash(_branches),
  );

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessProfileModelImplCopyWith<_$BusinessProfileModelImpl>
  get copyWith =>
      __$$BusinessProfileModelImplCopyWithImpl<_$BusinessProfileModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessProfileModelImplToJson(this);
  }
}

abstract class _BusinessProfileModel implements BusinessProfileModel {
  const factory _BusinessProfileModel({
    required final String id,
    required final String name,
    @JsonKey(name: 'legal_name') final String? legalName,
    final String? email,
    final String? phone,
    @JsonKey(name: 'tax_id') final String? taxId,
    @JsonKey(name: 'address_line1') final String? addressLine1,
    @JsonKey(name: 'logo_url') final String? logoUrl,
    final String? city,
    @JsonKey(name: 'country_code') final String countryCode,
    @JsonKey(name: 'currency_code') final String currencyCode,
    @JsonKey(name: 'subscription_plan') final String? subscriptionPlan,
    @JsonKey(name: 'subscription_status') final String? subscriptionStatus,
    @JsonKey(name: 'is_active') final bool isActive,
    @JsonKey(name: 'business_type') final BusinessTypeModel? businessType,
    final List<BranchModel> branches,
  }) = _$BusinessProfileModelImpl;

  factory _BusinessProfileModel.fromJson(Map<String, dynamic> json) =
      _$BusinessProfileModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'legal_name')
  String? get legalName;
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
  @JsonKey(name: 'logo_url')
  String? get logoUrl;
  @override
  String? get city;
  @override
  @JsonKey(name: 'country_code')
  String get countryCode;
  @override
  @JsonKey(name: 'currency_code')
  String get currencyCode;
  @override
  @JsonKey(name: 'subscription_plan')
  String? get subscriptionPlan;
  @override
  @JsonKey(name: 'subscription_status')
  String? get subscriptionStatus;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'business_type')
  BusinessTypeModel? get businessType;
  @override
  List<BranchModel> get branches;

  /// Create a copy of BusinessProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessProfileModelImplCopyWith<_$BusinessProfileModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
