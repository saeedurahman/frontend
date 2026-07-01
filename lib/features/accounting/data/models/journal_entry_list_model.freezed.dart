// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JournalEntryListModel _$JournalEntryListModelFromJson(
  Map<String, dynamic> json,
) {
  return _JournalEntryListModel.fromJson(json);
}

/// @nodoc
mixin _$JournalEntryListModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_id')
  String get businessId => throw _privateConstructorUsedError;
  @JsonKey(name: 'branch_id')
  String? get branchId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_number')
  String get entryNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_date')
  String get entryDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'reference_type')
  String? get referenceType => throw _privateConstructorUsedError;
  @JsonKey(name: 'posted_at')
  String? get postedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_debit')
  String get totalDebit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_credit')
  String get totalCredit => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;

  /// Serializes this JournalEntryListModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryListModelCopyWith<JournalEntryListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryListModelCopyWith<$Res> {
  factory $JournalEntryListModelCopyWith(
    JournalEntryListModel value,
    $Res Function(JournalEntryListModel) then,
  ) = _$JournalEntryListModelCopyWithImpl<$Res, JournalEntryListModel>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'entry_number') String entryNumber,
    String status,
    @JsonKey(name: 'entry_date') String entryDate,
    String? description,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'posted_at') String? postedAt,
    @JsonKey(name: 'total_debit') String totalDebit,
    @JsonKey(name: 'total_credit') String totalCredit,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class _$JournalEntryListModelCopyWithImpl<
  $Res,
  $Val extends JournalEntryListModel
>
    implements $JournalEntryListModelCopyWith<$Res> {
  _$JournalEntryListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? entryNumber = null,
    Object? status = null,
    Object? entryDate = null,
    Object? description = freezed,
    Object? referenceType = freezed,
    Object? postedAt = freezed,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? createdAt = null,
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
            branchId: freezed == branchId
                ? _value.branchId
                : branchId // ignore: cast_nullable_to_non_nullable
                      as String?,
            entryNumber: null == entryNumber
                ? _value.entryNumber
                : entryNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            entryDate: null == entryDate
                ? _value.entryDate
                : entryDate // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            referenceType: freezed == referenceType
                ? _value.referenceType
                : referenceType // ignore: cast_nullable_to_non_nullable
                      as String?,
            postedAt: freezed == postedAt
                ? _value.postedAt
                : postedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalDebit: null == totalDebit
                ? _value.totalDebit
                : totalDebit // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCredit: null == totalCredit
                ? _value.totalCredit
                : totalCredit // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JournalEntryListModelImplCopyWith<$Res>
    implements $JournalEntryListModelCopyWith<$Res> {
  factory _$$JournalEntryListModelImplCopyWith(
    _$JournalEntryListModelImpl value,
    $Res Function(_$JournalEntryListModelImpl) then,
  ) = __$$JournalEntryListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'business_id') String businessId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'entry_number') String entryNumber,
    String status,
    @JsonKey(name: 'entry_date') String entryDate,
    String? description,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'posted_at') String? postedAt,
    @JsonKey(name: 'total_debit') String totalDebit,
    @JsonKey(name: 'total_credit') String totalCredit,
    @JsonKey(name: 'created_at') String createdAt,
  });
}

/// @nodoc
class __$$JournalEntryListModelImplCopyWithImpl<$Res>
    extends
        _$JournalEntryListModelCopyWithImpl<$Res, _$JournalEntryListModelImpl>
    implements _$$JournalEntryListModelImplCopyWith<$Res> {
  __$$JournalEntryListModelImplCopyWithImpl(
    _$JournalEntryListModelImpl _value,
    $Res Function(_$JournalEntryListModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JournalEntryListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? businessId = null,
    Object? branchId = freezed,
    Object? entryNumber = null,
    Object? status = null,
    Object? entryDate = null,
    Object? description = freezed,
    Object? referenceType = freezed,
    Object? postedAt = freezed,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$JournalEntryListModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        businessId: null == businessId
            ? _value.businessId
            : businessId // ignore: cast_nullable_to_non_nullable
                  as String,
        branchId: freezed == branchId
            ? _value.branchId
            : branchId // ignore: cast_nullable_to_non_nullable
                  as String?,
        entryNumber: null == entryNumber
            ? _value.entryNumber
            : entryNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        entryDate: null == entryDate
            ? _value.entryDate
            : entryDate // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        referenceType: freezed == referenceType
            ? _value.referenceType
            : referenceType // ignore: cast_nullable_to_non_nullable
                  as String?,
        postedAt: freezed == postedAt
            ? _value.postedAt
            : postedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalDebit: null == totalDebit
            ? _value.totalDebit
            : totalDebit // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCredit: null == totalCredit
            ? _value.totalCredit
            : totalCredit // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalEntryListModelImpl implements _JournalEntryListModel {
  const _$JournalEntryListModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'entry_number') required this.entryNumber,
    required this.status,
    @JsonKey(name: 'entry_date') required this.entryDate,
    this.description,
    @JsonKey(name: 'reference_type') this.referenceType,
    @JsonKey(name: 'posted_at') this.postedAt,
    @JsonKey(name: 'total_debit') required this.totalDebit,
    @JsonKey(name: 'total_credit') required this.totalCredit,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  factory _$JournalEntryListModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryListModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'business_id')
  final String businessId;
  @override
  @JsonKey(name: 'branch_id')
  final String? branchId;
  @override
  @JsonKey(name: 'entry_number')
  final String entryNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'entry_date')
  final String entryDate;
  @override
  final String? description;
  @override
  @JsonKey(name: 'reference_type')
  final String? referenceType;
  @override
  @JsonKey(name: 'posted_at')
  final String? postedAt;
  @override
  @JsonKey(name: 'total_debit')
  final String totalDebit;
  @override
  @JsonKey(name: 'total_credit')
  final String totalCredit;
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;

  @override
  String toString() {
    return 'JournalEntryListModel(id: $id, businessId: $businessId, branchId: $branchId, entryNumber: $entryNumber, status: $status, entryDate: $entryDate, description: $description, referenceType: $referenceType, postedAt: $postedAt, totalDebit: $totalDebit, totalCredit: $totalCredit, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryListModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.businessId, businessId) ||
                other.businessId == businessId) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.entryNumber, entryNumber) ||
                other.entryNumber == entryNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.referenceType, referenceType) ||
                other.referenceType == referenceType) &&
            (identical(other.postedAt, postedAt) ||
                other.postedAt == postedAt) &&
            (identical(other.totalDebit, totalDebit) ||
                other.totalDebit == totalDebit) &&
            (identical(other.totalCredit, totalCredit) ||
                other.totalCredit == totalCredit) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    businessId,
    branchId,
    entryNumber,
    status,
    entryDate,
    description,
    referenceType,
    postedAt,
    totalDebit,
    totalCredit,
    createdAt,
  );

  /// Create a copy of JournalEntryListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryListModelImplCopyWith<_$JournalEntryListModelImpl>
  get copyWith =>
      __$$JournalEntryListModelImplCopyWithImpl<_$JournalEntryListModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryListModelImplToJson(this);
  }
}

abstract class _JournalEntryListModel implements JournalEntryListModel {
  const factory _JournalEntryListModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'entry_number') required final String entryNumber,
    required final String status,
    @JsonKey(name: 'entry_date') required final String entryDate,
    final String? description,
    @JsonKey(name: 'reference_type') final String? referenceType,
    @JsonKey(name: 'posted_at') final String? postedAt,
    @JsonKey(name: 'total_debit') required final String totalDebit,
    @JsonKey(name: 'total_credit') required final String totalCredit,
    @JsonKey(name: 'created_at') required final String createdAt,
  }) = _$JournalEntryListModelImpl;

  factory _JournalEntryListModel.fromJson(Map<String, dynamic> json) =
      _$JournalEntryListModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'business_id')
  String get businessId;
  @override
  @JsonKey(name: 'branch_id')
  String? get branchId;
  @override
  @JsonKey(name: 'entry_number')
  String get entryNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'entry_date')
  String get entryDate;
  @override
  String? get description;
  @override
  @JsonKey(name: 'reference_type')
  String? get referenceType;
  @override
  @JsonKey(name: 'posted_at')
  String? get postedAt;
  @override
  @JsonKey(name: 'total_debit')
  String get totalDebit;
  @override
  @JsonKey(name: 'total_credit')
  String get totalCredit;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;

  /// Create a copy of JournalEntryListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryListModelImplCopyWith<_$JournalEntryListModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
