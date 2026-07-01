// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

JournalEntryModel _$JournalEntryModelFromJson(Map<String, dynamic> json) {
  return _JournalEntryModel.fromJson(json);
}

/// @nodoc
mixin _$JournalEntryModel {
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
  @JsonKey(name: 'reference_id')
  String? get referenceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'posted_at')
  String? get postedAt => throw _privateConstructorUsedError;
  List<JournalLineModel> get lines => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_debit')
  String get totalDebit => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_credit')
  String get totalCredit => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  String? get deletedAt => throw _privateConstructorUsedError;

  /// Serializes this JournalEntryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalEntryModelCopyWith<JournalEntryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalEntryModelCopyWith<$Res> {
  factory $JournalEntryModelCopyWith(
    JournalEntryModel value,
    $Res Function(JournalEntryModel) then,
  ) = _$JournalEntryModelCopyWithImpl<$Res, JournalEntryModel>;
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
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'posted_at') String? postedAt,
    List<JournalLineModel> lines,
    @JsonKey(name: 'total_debit') String totalDebit,
    @JsonKey(name: 'total_credit') String totalCredit,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  });
}

/// @nodoc
class _$JournalEntryModelCopyWithImpl<$Res, $Val extends JournalEntryModel>
    implements $JournalEntryModelCopyWith<$Res> {
  _$JournalEntryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalEntryModel
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
    Object? referenceId = freezed,
    Object? postedAt = freezed,
    Object? lines = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
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
            referenceId: freezed == referenceId
                ? _value.referenceId
                : referenceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            postedAt: freezed == postedAt
                ? _value.postedAt
                : postedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            lines: null == lines
                ? _value.lines
                : lines // ignore: cast_nullable_to_non_nullable
                      as List<JournalLineModel>,
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
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as String,
            deletedAt: freezed == deletedAt
                ? _value.deletedAt
                : deletedAt // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$JournalEntryModelImplCopyWith<$Res>
    implements $JournalEntryModelCopyWith<$Res> {
  factory _$$JournalEntryModelImplCopyWith(
    _$JournalEntryModelImpl value,
    $Res Function(_$JournalEntryModelImpl) then,
  ) = __$$JournalEntryModelImplCopyWithImpl<$Res>;
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
    @JsonKey(name: 'reference_id') String? referenceId,
    @JsonKey(name: 'posted_at') String? postedAt,
    List<JournalLineModel> lines,
    @JsonKey(name: 'total_debit') String totalDebit,
    @JsonKey(name: 'total_credit') String totalCredit,
    @JsonKey(name: 'created_at') String createdAt,
    @JsonKey(name: 'updated_at') String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
  });
}

/// @nodoc
class __$$JournalEntryModelImplCopyWithImpl<$Res>
    extends _$JournalEntryModelCopyWithImpl<$Res, _$JournalEntryModelImpl>
    implements _$$JournalEntryModelImplCopyWith<$Res> {
  __$$JournalEntryModelImplCopyWithImpl(
    _$JournalEntryModelImpl _value,
    $Res Function(_$JournalEntryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of JournalEntryModel
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
    Object? referenceId = freezed,
    Object? postedAt = freezed,
    Object? lines = null,
    Object? totalDebit = null,
    Object? totalCredit = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(
      _$JournalEntryModelImpl(
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
        referenceId: freezed == referenceId
            ? _value.referenceId
            : referenceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        postedAt: freezed == postedAt
            ? _value.postedAt
            : postedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        lines: null == lines
            ? _value._lines
            : lines // ignore: cast_nullable_to_non_nullable
                  as List<JournalLineModel>,
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
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as String,
        deletedAt: freezed == deletedAt
            ? _value.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalEntryModelImpl implements _JournalEntryModel {
  const _$JournalEntryModelImpl({
    required this.id,
    @JsonKey(name: 'business_id') required this.businessId,
    @JsonKey(name: 'branch_id') this.branchId,
    @JsonKey(name: 'entry_number') required this.entryNumber,
    required this.status,
    @JsonKey(name: 'entry_date') required this.entryDate,
    this.description,
    @JsonKey(name: 'reference_type') this.referenceType,
    @JsonKey(name: 'reference_id') this.referenceId,
    @JsonKey(name: 'posted_at') this.postedAt,
    final List<JournalLineModel> lines = const [],
    @JsonKey(name: 'total_debit') required this.totalDebit,
    @JsonKey(name: 'total_credit') required this.totalCredit,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'deleted_at') this.deletedAt,
  }) : _lines = lines;

  factory _$JournalEntryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalEntryModelImplFromJson(json);

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
  @JsonKey(name: 'reference_id')
  final String? referenceId;
  @override
  @JsonKey(name: 'posted_at')
  final String? postedAt;
  final List<JournalLineModel> _lines;
  @override
  @JsonKey()
  List<JournalLineModel> get lines {
    if (_lines is EqualUnmodifiableListView) return _lines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lines);
  }

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
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @override
  String toString() {
    return 'JournalEntryModel(id: $id, businessId: $businessId, branchId: $branchId, entryNumber: $entryNumber, status: $status, entryDate: $entryDate, description: $description, referenceType: $referenceType, referenceId: $referenceId, postedAt: $postedAt, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalEntryModelImpl &&
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
            (identical(other.referenceId, referenceId) ||
                other.referenceId == referenceId) &&
            (identical(other.postedAt, postedAt) ||
                other.postedAt == postedAt) &&
            const DeepCollectionEquality().equals(other._lines, _lines) &&
            (identical(other.totalDebit, totalDebit) ||
                other.totalDebit == totalDebit) &&
            (identical(other.totalCredit, totalCredit) ||
                other.totalCredit == totalCredit) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
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
    referenceId,
    postedAt,
    const DeepCollectionEquality().hash(_lines),
    totalDebit,
    totalCredit,
    createdAt,
    updatedAt,
    deletedAt,
  );

  /// Create a copy of JournalEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalEntryModelImplCopyWith<_$JournalEntryModelImpl> get copyWith =>
      __$$JournalEntryModelImplCopyWithImpl<_$JournalEntryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalEntryModelImplToJson(this);
  }
}

abstract class _JournalEntryModel implements JournalEntryModel {
  const factory _JournalEntryModel({
    required final String id,
    @JsonKey(name: 'business_id') required final String businessId,
    @JsonKey(name: 'branch_id') final String? branchId,
    @JsonKey(name: 'entry_number') required final String entryNumber,
    required final String status,
    @JsonKey(name: 'entry_date') required final String entryDate,
    final String? description,
    @JsonKey(name: 'reference_type') final String? referenceType,
    @JsonKey(name: 'reference_id') final String? referenceId,
    @JsonKey(name: 'posted_at') final String? postedAt,
    final List<JournalLineModel> lines,
    @JsonKey(name: 'total_debit') required final String totalDebit,
    @JsonKey(name: 'total_credit') required final String totalCredit,
    @JsonKey(name: 'created_at') required final String createdAt,
    @JsonKey(name: 'updated_at') required final String updatedAt,
    @JsonKey(name: 'deleted_at') final String? deletedAt,
  }) = _$JournalEntryModelImpl;

  factory _JournalEntryModel.fromJson(Map<String, dynamic> json) =
      _$JournalEntryModelImpl.fromJson;

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
  @JsonKey(name: 'reference_id')
  String? get referenceId;
  @override
  @JsonKey(name: 'posted_at')
  String? get postedAt;
  @override
  List<JournalLineModel> get lines;
  @override
  @JsonKey(name: 'total_debit')
  String get totalDebit;
  @override
  @JsonKey(name: 'total_credit')
  String get totalCredit;
  @override
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  String? get deletedAt;

  /// Create a copy of JournalEntryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalEntryModelImplCopyWith<_$JournalEntryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
