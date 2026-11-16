// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntryModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'entry_number') String get entryNumber; String get status;@JsonKey(name: 'entry_date') String get entryDate; String? get description;@JsonKey(name: 'reference_type') String? get referenceType;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'posted_at') String? get postedAt; List<JournalLineModel> get lines;@JsonKey(name: 'total_debit') String get totalDebit;@JsonKey(name: 'total_credit') String get totalCredit;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt;@JsonKey(name: 'deleted_at') String? get deletedAt;
/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryModelCopyWith<JournalEntryModel> get copyWith => _$JournalEntryModelCopyWithImpl<JournalEntryModel>(this as JournalEntryModel, _$identity);

  /// Serializes this JournalEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JournalEntryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.entryNumber, _this.entryNumber) || other.entryNumber == _this.entryNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.referenceId, _this.referenceId) || other.referenceId == _this.referenceId)&&(identical(other.postedAt, _this.postedAt) || other.postedAt == _this.postedAt)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&(identical(other.totalDebit, _this.totalDebit) || other.totalDebit == _this.totalDebit)&&(identical(other.totalCredit, _this.totalCredit) || other.totalCredit == _this.totalCredit)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JournalEntryModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.entryNumber,_this.status,_this.entryDate,_this.description,_this.referenceType,_this.referenceId,_this.postedAt,const DeepCollectionEquality().hash(_this.lines),_this.totalDebit,_this.totalCredit,_this.createdAt,_this.updatedAt,_this.deletedAt);
}

@override
String toString() {
  final _this = this as JournalEntryModel;
  return 'JournalEntryModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, entryNumber: ${_this.entryNumber}, status: ${_this.status}, entryDate: ${_this.entryDate}, description: ${_this.description}, referenceType: ${_this.referenceType}, referenceId: ${_this.referenceId}, postedAt: ${_this.postedAt}, lines: ${_this.lines}, totalDebit: ${_this.totalDebit}, totalCredit: ${_this.totalCredit}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, deletedAt: ${_this.deletedAt})';
}


}

/// @nodoc
abstract mixin class $JournalEntryModelCopyWith<$Res>  {
  factory $JournalEntryModelCopyWith(JournalEntryModel value, $Res Function(JournalEntryModel) _then) = _$JournalEntryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'entry_number') String entryNumber, String status,@JsonKey(name: 'entry_date') String entryDate, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'posted_at') String? postedAt, List<JournalLineModel> lines,@JsonKey(name: 'total_debit') String totalDebit,@JsonKey(name: 'total_credit') String totalCredit,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class _$JournalEntryModelCopyWithImpl<$Res>
    implements $JournalEntryModelCopyWith<$Res> {
  _$JournalEntryModelCopyWithImpl(this._self, this._then);

  final JournalEntryModel _self;
  final $Res Function(JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? entryNumber = null,Object? status = null,Object? entryDate = null,Object? description = freezed,Object? referenceType = freezed,Object? referenceId = freezed,Object? postedAt = freezed,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(JournalEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineModel>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryModel].
extension JournalEntryModelPatterns on JournalEntryModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'posted_at')  String? postedAt,  List<JournalLineModel> lines, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.referenceId,_that.postedAt,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'posted_at')  String? postedAt,  List<JournalLineModel> lines, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.referenceId,_that.postedAt,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'posted_at')  String? postedAt,  List<JournalLineModel> lines, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt, @JsonKey(name: 'updated_at')  String updatedAt, @JsonKey(name: 'deleted_at')  String? deletedAt)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.referenceId,_that.postedAt,_that.lines,_that.totalDebit,_that.totalCredit,_that.createdAt,_that.updatedAt,_that.deletedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntryModel implements JournalEntryModel {
  const _JournalEntryModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'entry_number') required this.entryNumber, required this.status, @JsonKey(name: 'entry_date') required this.entryDate, this.description, @JsonKey(name: 'reference_type') this.referenceType, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'posted_at') this.postedAt,  List<JournalLineModel> lines = const [], @JsonKey(name: 'total_debit') required this.totalDebit, @JsonKey(name: 'total_credit') required this.totalCredit, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(name: 'deleted_at') this.deletedAt}): _lines = lines;
  factory _JournalEntryModel.fromJson(Map<String, dynamic> json) => _$JournalEntryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'entry_number') final  String entryNumber;
@override final  String status;
@override@JsonKey(name: 'entry_date') final  String entryDate;
@override final  String? description;
@override@JsonKey(name: 'reference_type') final  String? referenceType;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'posted_at') final  String? postedAt;
 final  List<JournalLineModel> _lines;
@override@JsonKey() List<JournalLineModel> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

@override@JsonKey(name: 'total_debit') final  String totalDebit;
@override@JsonKey(name: 'total_credit') final  String totalCredit;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override@JsonKey(name: 'deleted_at') final  String? deletedAt;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryModelCopyWith<_JournalEntryModel> get copyWith => __$JournalEntryModelCopyWithImpl<_JournalEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.entryNumber, entryNumber) || other.entryNumber == entryNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&const DeepCollectionEquality().equals(other.lines, _lines)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,entryNumber,status,entryDate,description,referenceType,referenceId,postedAt,const DeepCollectionEquality().hash(_lines),totalDebit,totalCredit,createdAt,updatedAt,deletedAt);
}

@override
String toString() {
    return 'JournalEntryModel(id: $id, businessId: $businessId, branchId: $branchId, entryNumber: $entryNumber, status: $status, entryDate: $entryDate, description: $description, referenceType: $referenceType, referenceId: $referenceId, postedAt: $postedAt, lines: $lines, totalDebit: $totalDebit, totalCredit: $totalCredit, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryModelCopyWith<$Res> implements $JournalEntryModelCopyWith<$Res> {
  factory _$JournalEntryModelCopyWith(_JournalEntryModel value, $Res Function(_JournalEntryModel) _then) = __$JournalEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'entry_number') String entryNumber, String status,@JsonKey(name: 'entry_date') String entryDate, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'posted_at') String? postedAt, List<JournalLineModel> lines,@JsonKey(name: 'total_debit') String totalDebit,@JsonKey(name: 'total_credit') String totalCredit,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt,@JsonKey(name: 'deleted_at') String? deletedAt
});




}
/// @nodoc
class __$JournalEntryModelCopyWithImpl<$Res>
    implements _$JournalEntryModelCopyWith<$Res> {
  __$JournalEntryModelCopyWithImpl(this._self, this._then);

  final _JournalEntryModel _self;
  final $Res Function(_JournalEntryModel) _then;

/// Create a copy of JournalEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? entryNumber = null,Object? status = null,Object? entryDate = null,Object? description = freezed,Object? referenceType = freezed,Object? referenceId = freezed,Object? postedAt = freezed,Object? lines = null,Object? totalDebit = null,Object? totalCredit = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,}) {
  return _then(_JournalEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineModel>,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
