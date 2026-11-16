// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalEntryListModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'entry_number') String get entryNumber; String get status;@JsonKey(name: 'entry_date') String get entryDate; String? get description;@JsonKey(name: 'reference_type') String? get referenceType;@JsonKey(name: 'posted_at') String? get postedAt;@JsonKey(name: 'total_debit') String get totalDebit;@JsonKey(name: 'total_credit') String get totalCredit;@JsonKey(name: 'created_at') String get createdAt;
/// Create a copy of JournalEntryListModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryListModelCopyWith<JournalEntryListModel> get copyWith => _$JournalEntryListModelCopyWithImpl<JournalEntryListModel>(this as JournalEntryListModel, _$identity);

  /// Serializes this JournalEntryListModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JournalEntryListModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryListModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.entryNumber, _this.entryNumber) || other.entryNumber == _this.entryNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.postedAt, _this.postedAt) || other.postedAt == _this.postedAt)&&(identical(other.totalDebit, _this.totalDebit) || other.totalDebit == _this.totalDebit)&&(identical(other.totalCredit, _this.totalCredit) || other.totalCredit == _this.totalCredit)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JournalEntryListModel;
  return Object.hash(runtimeType,_this.id,_this.businessId,_this.branchId,_this.entryNumber,_this.status,_this.entryDate,_this.description,_this.referenceType,_this.postedAt,_this.totalDebit,_this.totalCredit,_this.createdAt);
}

@override
String toString() {
  final _this = this as JournalEntryListModel;
  return 'JournalEntryListModel(id: ${_this.id}, businessId: ${_this.businessId}, branchId: ${_this.branchId}, entryNumber: ${_this.entryNumber}, status: ${_this.status}, entryDate: ${_this.entryDate}, description: ${_this.description}, referenceType: ${_this.referenceType}, postedAt: ${_this.postedAt}, totalDebit: ${_this.totalDebit}, totalCredit: ${_this.totalCredit}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $JournalEntryListModelCopyWith<$Res>  {
  factory $JournalEntryListModelCopyWith(JournalEntryListModel value, $Res Function(JournalEntryListModel) _then) = _$JournalEntryListModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'entry_number') String entryNumber, String status,@JsonKey(name: 'entry_date') String entryDate, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'posted_at') String? postedAt,@JsonKey(name: 'total_debit') String totalDebit,@JsonKey(name: 'total_credit') String totalCredit,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class _$JournalEntryListModelCopyWithImpl<$Res>
    implements $JournalEntryListModelCopyWith<$Res> {
  _$JournalEntryListModelCopyWithImpl(this._self, this._then);

  final JournalEntryListModel _self;
  final $Res Function(JournalEntryListModel) _then;

/// Create a copy of JournalEntryListModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? entryNumber = null,Object? status = null,Object? entryDate = null,Object? description = freezed,Object? referenceType = freezed,Object? postedAt = freezed,Object? totalDebit = null,Object? totalCredit = null,Object? createdAt = null,}) {
  return _then(JournalEntryListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryListModel].
extension JournalEntryListModelPatterns on JournalEntryListModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryListModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryListModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryListModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryListModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryListModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryListModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'posted_at')  String? postedAt, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryListModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.postedAt,_that.totalDebit,_that.totalCredit,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'posted_at')  String? postedAt, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryListModel():
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.postedAt,_that.totalDebit,_that.totalCredit,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'entry_number')  String entryNumber,  String status, @JsonKey(name: 'entry_date')  String entryDate,  String? description, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'posted_at')  String? postedAt, @JsonKey(name: 'total_debit')  String totalDebit, @JsonKey(name: 'total_credit')  String totalCredit, @JsonKey(name: 'created_at')  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryListModel() when $default != null:
return $default(_that.id,_that.businessId,_that.branchId,_that.entryNumber,_that.status,_that.entryDate,_that.description,_that.referenceType,_that.postedAt,_that.totalDebit,_that.totalCredit,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalEntryListModel implements JournalEntryListModel {
  const _JournalEntryListModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'entry_number') required this.entryNumber, required this.status, @JsonKey(name: 'entry_date') required this.entryDate, this.description, @JsonKey(name: 'reference_type') this.referenceType, @JsonKey(name: 'posted_at') this.postedAt, @JsonKey(name: 'total_debit') required this.totalDebit, @JsonKey(name: 'total_credit') required this.totalCredit, @JsonKey(name: 'created_at') required this.createdAt});
  factory _JournalEntryListModel.fromJson(Map<String, dynamic> json) => _$JournalEntryListModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'entry_number') final  String entryNumber;
@override final  String status;
@override@JsonKey(name: 'entry_date') final  String entryDate;
@override final  String? description;
@override@JsonKey(name: 'reference_type') final  String? referenceType;
@override@JsonKey(name: 'posted_at') final  String? postedAt;
@override@JsonKey(name: 'total_debit') final  String totalDebit;
@override@JsonKey(name: 'total_credit') final  String totalCredit;
@override@JsonKey(name: 'created_at') final  String createdAt;

/// Create a copy of JournalEntryListModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryListModelCopyWith<_JournalEntryListModel> get copyWith => __$JournalEntryListModelCopyWithImpl<_JournalEntryListModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalEntryListModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryListModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.entryNumber, entryNumber) || other.entryNumber == entryNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.totalDebit, totalDebit) || other.totalDebit == totalDebit)&&(identical(other.totalCredit, totalCredit) || other.totalCredit == totalCredit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,businessId,branchId,entryNumber,status,entryDate,description,referenceType,postedAt,totalDebit,totalCredit,createdAt);
}

@override
String toString() {
    return 'JournalEntryListModel(id: $id, businessId: $businessId, branchId: $branchId, entryNumber: $entryNumber, status: $status, entryDate: $entryDate, description: $description, referenceType: $referenceType, postedAt: $postedAt, totalDebit: $totalDebit, totalCredit: $totalCredit, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryListModelCopyWith<$Res> implements $JournalEntryListModelCopyWith<$Res> {
  factory _$JournalEntryListModelCopyWith(_JournalEntryListModel value, $Res Function(_JournalEntryListModel) _then) = __$JournalEntryListModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'entry_number') String entryNumber, String status,@JsonKey(name: 'entry_date') String entryDate, String? description,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'posted_at') String? postedAt,@JsonKey(name: 'total_debit') String totalDebit,@JsonKey(name: 'total_credit') String totalCredit,@JsonKey(name: 'created_at') String createdAt
});




}
/// @nodoc
class __$JournalEntryListModelCopyWithImpl<$Res>
    implements _$JournalEntryListModelCopyWith<$Res> {
  __$JournalEntryListModelCopyWithImpl(this._self, this._then);

  final _JournalEntryListModel _self;
  final $Res Function(_JournalEntryListModel) _then;

/// Create a copy of JournalEntryListModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? branchId = freezed,Object? entryNumber = null,Object? status = null,Object? entryDate = null,Object? description = freezed,Object? referenceType = freezed,Object? postedAt = freezed,Object? totalDebit = null,Object? totalCredit = null,Object? createdAt = null,}) {
  return _then(_JournalEntryListModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,entryNumber: null == entryNumber ? _self.entryNumber : entryNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as String?,totalDebit: null == totalDebit ? _self.totalDebit : totalDebit // ignore: cast_nullable_to_non_nullable
as String,totalCredit: null == totalCredit ? _self.totalCredit : totalCredit // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
