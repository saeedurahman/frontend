// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coa_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CoaFormState {
  String? get accountId => throw _privateConstructorUsedError;
  String get accountCode => throw _privateConstructorUsedError;
  String get accountName => throw _privateConstructorUsedError;
  String get accountType => throw _privateConstructorUsedError;
  String? get accountSubtype => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isSystem => throw _privateConstructorUsedError;
  List<ChartOfAccountModel> get coaTreeRoots =>
      throw _privateConstructorUsedError;
  bool get canManage => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  bool get isDeleting => throw _privateConstructorUsedError;
  Map<String, String> get errors => throw _privateConstructorUsedError;

  /// Create a copy of CoaFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CoaFormStateCopyWith<CoaFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoaFormStateCopyWith<$Res> {
  factory $CoaFormStateCopyWith(
    CoaFormState value,
    $Res Function(CoaFormState) then,
  ) = _$CoaFormStateCopyWithImpl<$Res, CoaFormState>;
  @useResult
  $Res call({
    String? accountId,
    String accountCode,
    String accountName,
    String accountType,
    String? accountSubtype,
    String? parentId,
    String description,
    bool isActive,
    bool isSystem,
    List<ChartOfAccountModel> coaTreeRoots,
    bool canManage,
    bool isLoading,
    bool isSubmitting,
    bool isDeleting,
    Map<String, String> errors,
  });
}

/// @nodoc
class _$CoaFormStateCopyWithImpl<$Res, $Val extends CoaFormState>
    implements $CoaFormStateCopyWith<$Res> {
  _$CoaFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CoaFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = freezed,
    Object? accountCode = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? accountSubtype = freezed,
    Object? parentId = freezed,
    Object? description = null,
    Object? isActive = null,
    Object? isSystem = null,
    Object? coaTreeRoots = null,
    Object? canManage = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isDeleting = null,
    Object? errors = null,
  }) {
    return _then(
      _value.copyWith(
            accountId: freezed == accountId
                ? _value.accountId
                : accountId // ignore: cast_nullable_to_non_nullable
                      as String?,
            accountCode: null == accountCode
                ? _value.accountCode
                : accountCode // ignore: cast_nullable_to_non_nullable
                      as String,
            accountName: null == accountName
                ? _value.accountName
                : accountName // ignore: cast_nullable_to_non_nullable
                      as String,
            accountType: null == accountType
                ? _value.accountType
                : accountType // ignore: cast_nullable_to_non_nullable
                      as String,
            accountSubtype: freezed == accountSubtype
                ? _value.accountSubtype
                : accountSubtype // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentId: freezed == parentId
                ? _value.parentId
                : parentId // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSystem: null == isSystem
                ? _value.isSystem
                : isSystem // ignore: cast_nullable_to_non_nullable
                      as bool,
            coaTreeRoots: null == coaTreeRoots
                ? _value.coaTreeRoots
                : coaTreeRoots // ignore: cast_nullable_to_non_nullable
                      as List<ChartOfAccountModel>,
            canManage: null == canManage
                ? _value.canManage
                : canManage // ignore: cast_nullable_to_non_nullable
                      as bool,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDeleting: null == isDeleting
                ? _value.isDeleting
                : isDeleting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errors: null == errors
                ? _value.errors
                : errors // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CoaFormStateImplCopyWith<$Res>
    implements $CoaFormStateCopyWith<$Res> {
  factory _$$CoaFormStateImplCopyWith(
    _$CoaFormStateImpl value,
    $Res Function(_$CoaFormStateImpl) then,
  ) = __$$CoaFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? accountId,
    String accountCode,
    String accountName,
    String accountType,
    String? accountSubtype,
    String? parentId,
    String description,
    bool isActive,
    bool isSystem,
    List<ChartOfAccountModel> coaTreeRoots,
    bool canManage,
    bool isLoading,
    bool isSubmitting,
    bool isDeleting,
    Map<String, String> errors,
  });
}

/// @nodoc
class __$$CoaFormStateImplCopyWithImpl<$Res>
    extends _$CoaFormStateCopyWithImpl<$Res, _$CoaFormStateImpl>
    implements _$$CoaFormStateImplCopyWith<$Res> {
  __$$CoaFormStateImplCopyWithImpl(
    _$CoaFormStateImpl _value,
    $Res Function(_$CoaFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CoaFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = freezed,
    Object? accountCode = null,
    Object? accountName = null,
    Object? accountType = null,
    Object? accountSubtype = freezed,
    Object? parentId = freezed,
    Object? description = null,
    Object? isActive = null,
    Object? isSystem = null,
    Object? coaTreeRoots = null,
    Object? canManage = null,
    Object? isLoading = null,
    Object? isSubmitting = null,
    Object? isDeleting = null,
    Object? errors = null,
  }) {
    return _then(
      _$CoaFormStateImpl(
        accountId: freezed == accountId
            ? _value.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String?,
        accountCode: null == accountCode
            ? _value.accountCode
            : accountCode // ignore: cast_nullable_to_non_nullable
                  as String,
        accountName: null == accountName
            ? _value.accountName
            : accountName // ignore: cast_nullable_to_non_nullable
                  as String,
        accountType: null == accountType
            ? _value.accountType
            : accountType // ignore: cast_nullable_to_non_nullable
                  as String,
        accountSubtype: freezed == accountSubtype
            ? _value.accountSubtype
            : accountSubtype // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentId: freezed == parentId
            ? _value.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSystem: null == isSystem
            ? _value.isSystem
            : isSystem // ignore: cast_nullable_to_non_nullable
                  as bool,
        coaTreeRoots: null == coaTreeRoots
            ? _value._coaTreeRoots
            : coaTreeRoots // ignore: cast_nullable_to_non_nullable
                  as List<ChartOfAccountModel>,
        canManage: null == canManage
            ? _value.canManage
            : canManage // ignore: cast_nullable_to_non_nullable
                  as bool,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDeleting: null == isDeleting
            ? _value.isDeleting
            : isDeleting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errors: null == errors
            ? _value._errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}

/// @nodoc

class _$CoaFormStateImpl extends _CoaFormState {
  const _$CoaFormStateImpl({
    this.accountId,
    this.accountCode = '',
    this.accountName = '',
    this.accountType = AccountType.asset,
    this.accountSubtype,
    this.parentId,
    this.description = '',
    this.isActive = true,
    this.isSystem = false,
    final List<ChartOfAccountModel> coaTreeRoots = const [],
    this.canManage = false,
    this.isLoading = false,
    this.isSubmitting = false,
    this.isDeleting = false,
    final Map<String, String> errors = const {},
  }) : _coaTreeRoots = coaTreeRoots,
       _errors = errors,
       super._();

  @override
  final String? accountId;
  @override
  @JsonKey()
  final String accountCode;
  @override
  @JsonKey()
  final String accountName;
  @override
  @JsonKey()
  final String accountType;
  @override
  final String? accountSubtype;
  @override
  final String? parentId;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isSystem;
  final List<ChartOfAccountModel> _coaTreeRoots;
  @override
  @JsonKey()
  List<ChartOfAccountModel> get coaTreeRoots {
    if (_coaTreeRoots is EqualUnmodifiableListView) return _coaTreeRoots;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coaTreeRoots);
  }

  @override
  @JsonKey()
  final bool canManage;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  @JsonKey()
  final bool isDeleting;
  final Map<String, String> _errors;
  @override
  @JsonKey()
  Map<String, String> get errors {
    if (_errors is EqualUnmodifiableMapView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_errors);
  }

  @override
  String toString() {
    return 'CoaFormState(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, accountType: $accountType, accountSubtype: $accountSubtype, parentId: $parentId, description: $description, isActive: $isActive, isSystem: $isSystem, coaTreeRoots: $coaTreeRoots, canManage: $canManage, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoaFormStateImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.accountCode, accountCode) ||
                other.accountCode == accountCode) &&
            (identical(other.accountName, accountName) ||
                other.accountName == accountName) &&
            (identical(other.accountType, accountType) ||
                other.accountType == accountType) &&
            (identical(other.accountSubtype, accountSubtype) ||
                other.accountSubtype == accountSubtype) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            const DeepCollectionEquality().equals(
              other._coaTreeRoots,
              _coaTreeRoots,
            ) &&
            (identical(other.canManage, canManage) ||
                other.canManage == canManage) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    accountCode,
    accountName,
    accountType,
    accountSubtype,
    parentId,
    description,
    isActive,
    isSystem,
    const DeepCollectionEquality().hash(_coaTreeRoots),
    canManage,
    isLoading,
    isSubmitting,
    isDeleting,
    const DeepCollectionEquality().hash(_errors),
  );

  /// Create a copy of CoaFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CoaFormStateImplCopyWith<_$CoaFormStateImpl> get copyWith =>
      __$$CoaFormStateImplCopyWithImpl<_$CoaFormStateImpl>(this, _$identity);
}

abstract class _CoaFormState extends CoaFormState {
  const factory _CoaFormState({
    final String? accountId,
    final String accountCode,
    final String accountName,
    final String accountType,
    final String? accountSubtype,
    final String? parentId,
    final String description,
    final bool isActive,
    final bool isSystem,
    final List<ChartOfAccountModel> coaTreeRoots,
    final bool canManage,
    final bool isLoading,
    final bool isSubmitting,
    final bool isDeleting,
    final Map<String, String> errors,
  }) = _$CoaFormStateImpl;
  const _CoaFormState._() : super._();

  @override
  String? get accountId;
  @override
  String get accountCode;
  @override
  String get accountName;
  @override
  String get accountType;
  @override
  String? get accountSubtype;
  @override
  String? get parentId;
  @override
  String get description;
  @override
  bool get isActive;
  @override
  bool get isSystem;
  @override
  List<ChartOfAccountModel> get coaTreeRoots;
  @override
  bool get canManage;
  @override
  bool get isLoading;
  @override
  bool get isSubmitting;
  @override
  bool get isDeleting;
  @override
  Map<String, String> get errors;

  /// Create a copy of CoaFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CoaFormStateImplCopyWith<_$CoaFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
