// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_ledger_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomerLedgerEntryModel {

 String get id;@JsonKey(name: 'business_id') String get businessId;@JsonKey(name: 'customer_id') String get customerId;@JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment) LedgerEntryType get entryType; String get amount;@JsonKey(name: 'reference_type') String? get referenceType;@JsonKey(name: 'reference_id') String? get referenceId;@JsonKey(name: 'entry_at') String? get entryAt; String? get notes;@JsonKey(name: 'created_at') String? get createdAt;@JsonKey(name: 'branch_id') String? get branchId;@JsonKey(name: 'payment_source') String? get paymentSource;@JsonKey(name: 'reference_no') String? get referenceNo;@JsonKey(name: 'register_shift_id') String? get registerShiftId;@JsonKey(name: 'reversal_of_id') String? get reversalOfId;@JsonKey(name: 'reversed_by_id') String? get reversedById;@JsonKey(name: 'reversed_at') String? get reversedAt;@JsonKey(name: 'is_reversed') bool get isReversed;@JsonKey(name: 'is_reversal') bool get isReversal;@JsonKey(name: 'running_balance') String? get runningBalance;
/// Create a copy of CustomerLedgerEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerLedgerEntryModelCopyWith<CustomerLedgerEntryModel> get copyWith => _$CustomerLedgerEntryModelCopyWithImpl<CustomerLedgerEntryModel>(this as CustomerLedgerEntryModel, _$identity);

  /// Serializes this CustomerLedgerEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CustomerLedgerEntryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerEntryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.businessId, _this.businessId) || other.businessId == _this.businessId)&&(identical(other.customerId, _this.customerId) || other.customerId == _this.customerId)&&(identical(other.entryType, _this.entryType) || other.entryType == _this.entryType)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.referenceType, _this.referenceType) || other.referenceType == _this.referenceType)&&(identical(other.referenceId, _this.referenceId) || other.referenceId == _this.referenceId)&&(identical(other.entryAt, _this.entryAt) || other.entryAt == _this.entryAt)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.paymentSource, _this.paymentSource) || other.paymentSource == _this.paymentSource)&&(identical(other.referenceNo, _this.referenceNo) || other.referenceNo == _this.referenceNo)&&(identical(other.registerShiftId, _this.registerShiftId) || other.registerShiftId == _this.registerShiftId)&&(identical(other.reversalOfId, _this.reversalOfId) || other.reversalOfId == _this.reversalOfId)&&(identical(other.reversedById, _this.reversedById) || other.reversedById == _this.reversedById)&&(identical(other.reversedAt, _this.reversedAt) || other.reversedAt == _this.reversedAt)&&(identical(other.isReversed, _this.isReversed) || other.isReversed == _this.isReversed)&&(identical(other.isReversal, _this.isReversal) || other.isReversal == _this.isReversal)&&(identical(other.runningBalance, _this.runningBalance) || other.runningBalance == _this.runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CustomerLedgerEntryModel;
  return Object.hashAll([runtimeType,_this.id,_this.businessId,_this.customerId,_this.entryType,_this.amount,_this.referenceType,_this.referenceId,_this.entryAt,_this.notes,_this.createdAt,_this.branchId,_this.paymentSource,_this.referenceNo,_this.registerShiftId,_this.reversalOfId,_this.reversedById,_this.reversedAt,_this.isReversed,_this.isReversal,_this.runningBalance]);
}

@override
String toString() {
  final _this = this as CustomerLedgerEntryModel;
  return 'CustomerLedgerEntryModel(id: ${_this.id}, businessId: ${_this.businessId}, customerId: ${_this.customerId}, entryType: ${_this.entryType}, amount: ${_this.amount}, referenceType: ${_this.referenceType}, referenceId: ${_this.referenceId}, entryAt: ${_this.entryAt}, notes: ${_this.notes}, createdAt: ${_this.createdAt}, branchId: ${_this.branchId}, paymentSource: ${_this.paymentSource}, referenceNo: ${_this.referenceNo}, registerShiftId: ${_this.registerShiftId}, reversalOfId: ${_this.reversalOfId}, reversedById: ${_this.reversedById}, reversedAt: ${_this.reversedAt}, isReversed: ${_this.isReversed}, isReversal: ${_this.isReversal}, runningBalance: ${_this.runningBalance})';
}


}

/// @nodoc
abstract mixin class $CustomerLedgerEntryModelCopyWith<$Res>  {
  factory $CustomerLedgerEntryModelCopyWith(CustomerLedgerEntryModel value, $Res Function(CustomerLedgerEntryModel) _then) = _$CustomerLedgerEntryModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment) LedgerEntryType entryType, String amount,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'entry_at') String? entryAt, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'payment_source') String? paymentSource,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'reversal_of_id') String? reversalOfId,@JsonKey(name: 'reversed_by_id') String? reversedById,@JsonKey(name: 'reversed_at') String? reversedAt,@JsonKey(name: 'is_reversed') bool isReversed,@JsonKey(name: 'is_reversal') bool isReversal,@JsonKey(name: 'running_balance') String? runningBalance
});




}
/// @nodoc
class _$CustomerLedgerEntryModelCopyWithImpl<$Res>
    implements $CustomerLedgerEntryModelCopyWith<$Res> {
  _$CustomerLedgerEntryModelCopyWithImpl(this._self, this._then);

  final CustomerLedgerEntryModel _self;
  final $Res Function(CustomerLedgerEntryModel) _then;

/// Create a copy of CustomerLedgerEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? businessId = null,Object? customerId = null,Object? entryType = null,Object? amount = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? entryAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? branchId = freezed,Object? paymentSource = freezed,Object? referenceNo = freezed,Object? registerShiftId = freezed,Object? reversalOfId = freezed,Object? reversedById = freezed,Object? reversedAt = freezed,Object? isReversed = null,Object? isReversal = null,Object? runningBalance = freezed,}) {
  return _then(CustomerLedgerEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as LedgerEntryType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,entryAt: freezed == entryAt ? _self.entryAt : entryAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,paymentSource: freezed == paymentSource ? _self.paymentSource : paymentSource // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,reversedById: freezed == reversedById ? _self.reversedById : reversedById // ignore: cast_nullable_to_non_nullable
as String?,reversedAt: freezed == reversedAt ? _self.reversedAt : reversedAt // ignore: cast_nullable_to_non_nullable
as String?,isReversed: null == isReversed ? _self.isReversed : isReversed // ignore: cast_nullable_to_non_nullable
as bool,isReversal: null == isReversal ? _self.isReversal : isReversal // ignore: cast_nullable_to_non_nullable
as bool,runningBalance: freezed == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerLedgerEntryModel].
extension CustomerLedgerEntryModelPatterns on CustomerLedgerEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerLedgerEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerLedgerEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerLedgerEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment)  LedgerEntryType entryType,  String amount, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'entry_at')  String? entryAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'reversal_of_id')  String? reversalOfId, @JsonKey(name: 'reversed_by_id')  String? reversedById, @JsonKey(name: 'reversed_at')  String? reversedAt, @JsonKey(name: 'is_reversed')  bool isReversed, @JsonKey(name: 'is_reversal')  bool isReversal, @JsonKey(name: 'running_balance')  String? runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel() when $default != null:
return $default(_that.id,_that.businessId,_that.customerId,_that.entryType,_that.amount,_that.referenceType,_that.referenceId,_that.entryAt,_that.notes,_that.createdAt,_that.branchId,_that.paymentSource,_that.referenceNo,_that.registerShiftId,_that.reversalOfId,_that.reversedById,_that.reversedAt,_that.isReversed,_that.isReversal,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment)  LedgerEntryType entryType,  String amount, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'entry_at')  String? entryAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'reversal_of_id')  String? reversalOfId, @JsonKey(name: 'reversed_by_id')  String? reversedById, @JsonKey(name: 'reversed_at')  String? reversedAt, @JsonKey(name: 'is_reversed')  bool isReversed, @JsonKey(name: 'is_reversal')  bool isReversal, @JsonKey(name: 'running_balance')  String? runningBalance)  $default,) {final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel():
return $default(_that.id,_that.businessId,_that.customerId,_that.entryType,_that.amount,_that.referenceType,_that.referenceId,_that.entryAt,_that.notes,_that.createdAt,_that.branchId,_that.paymentSource,_that.referenceNo,_that.registerShiftId,_that.reversalOfId,_that.reversedById,_that.reversedAt,_that.isReversed,_that.isReversal,_that.runningBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'business_id')  String businessId, @JsonKey(name: 'customer_id')  String customerId, @JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment)  LedgerEntryType entryType,  String amount, @JsonKey(name: 'reference_type')  String? referenceType, @JsonKey(name: 'reference_id')  String? referenceId, @JsonKey(name: 'entry_at')  String? entryAt,  String? notes, @JsonKey(name: 'created_at')  String? createdAt, @JsonKey(name: 'branch_id')  String? branchId, @JsonKey(name: 'payment_source')  String? paymentSource, @JsonKey(name: 'reference_no')  String? referenceNo, @JsonKey(name: 'register_shift_id')  String? registerShiftId, @JsonKey(name: 'reversal_of_id')  String? reversalOfId, @JsonKey(name: 'reversed_by_id')  String? reversedById, @JsonKey(name: 'reversed_at')  String? reversedAt, @JsonKey(name: 'is_reversed')  bool isReversed, @JsonKey(name: 'is_reversal')  bool isReversal, @JsonKey(name: 'running_balance')  String? runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _CustomerLedgerEntryModel() when $default != null:
return $default(_that.id,_that.businessId,_that.customerId,_that.entryType,_that.amount,_that.referenceType,_that.referenceId,_that.entryAt,_that.notes,_that.createdAt,_that.branchId,_that.paymentSource,_that.referenceNo,_that.registerShiftId,_that.reversalOfId,_that.reversedById,_that.reversedAt,_that.isReversed,_that.isReversal,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerLedgerEntryModel implements CustomerLedgerEntryModel {
  const _CustomerLedgerEntryModel({required this.id, @JsonKey(name: 'business_id') required this.businessId, @JsonKey(name: 'customer_id') required this.customerId, @JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment) required this.entryType, required this.amount, @JsonKey(name: 'reference_type') this.referenceType, @JsonKey(name: 'reference_id') this.referenceId, @JsonKey(name: 'entry_at') this.entryAt, this.notes, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'branch_id') this.branchId, @JsonKey(name: 'payment_source') this.paymentSource, @JsonKey(name: 'reference_no') this.referenceNo, @JsonKey(name: 'register_shift_id') this.registerShiftId, @JsonKey(name: 'reversal_of_id') this.reversalOfId, @JsonKey(name: 'reversed_by_id') this.reversedById, @JsonKey(name: 'reversed_at') this.reversedAt, @JsonKey(name: 'is_reversed') this.isReversed = false, @JsonKey(name: 'is_reversal') this.isReversal = false, @JsonKey(name: 'running_balance') this.runningBalance});
  factory _CustomerLedgerEntryModel.fromJson(Map<String, dynamic> json) => _$CustomerLedgerEntryModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'business_id') final  String businessId;
@override@JsonKey(name: 'customer_id') final  String customerId;
@override@JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment) final  LedgerEntryType entryType;
@override final  String amount;
@override@JsonKey(name: 'reference_type') final  String? referenceType;
@override@JsonKey(name: 'reference_id') final  String? referenceId;
@override@JsonKey(name: 'entry_at') final  String? entryAt;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String? createdAt;
@override@JsonKey(name: 'branch_id') final  String? branchId;
@override@JsonKey(name: 'payment_source') final  String? paymentSource;
@override@JsonKey(name: 'reference_no') final  String? referenceNo;
@override@JsonKey(name: 'register_shift_id') final  String? registerShiftId;
@override@JsonKey(name: 'reversal_of_id') final  String? reversalOfId;
@override@JsonKey(name: 'reversed_by_id') final  String? reversedById;
@override@JsonKey(name: 'reversed_at') final  String? reversedAt;
@override@JsonKey(name: 'is_reversed') final  bool isReversed;
@override@JsonKey(name: 'is_reversal') final  bool isReversal;
@override@JsonKey(name: 'running_balance') final  String? runningBalance;

/// Create a copy of CustomerLedgerEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerLedgerEntryModelCopyWith<_CustomerLedgerEntryModel> get copyWith => __$CustomerLedgerEntryModelCopyWithImpl<_CustomerLedgerEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerLedgerEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerLedgerEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.businessId, businessId) || other.businessId == businessId)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.entryType, entryType) || other.entryType == entryType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.referenceType, referenceType) || other.referenceType == referenceType)&&(identical(other.referenceId, referenceId) || other.referenceId == referenceId)&&(identical(other.entryAt, entryAt) || other.entryAt == entryAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.paymentSource, paymentSource) || other.paymentSource == paymentSource)&&(identical(other.referenceNo, referenceNo) || other.referenceNo == referenceNo)&&(identical(other.registerShiftId, registerShiftId) || other.registerShiftId == registerShiftId)&&(identical(other.reversalOfId, reversalOfId) || other.reversalOfId == reversalOfId)&&(identical(other.reversedById, reversedById) || other.reversedById == reversedById)&&(identical(other.reversedAt, reversedAt) || other.reversedAt == reversedAt)&&(identical(other.isReversed, isReversed) || other.isReversed == isReversed)&&(identical(other.isReversal, isReversal) || other.isReversal == isReversal)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,businessId,customerId,entryType,amount,referenceType,referenceId,entryAt,notes,createdAt,branchId,paymentSource,referenceNo,registerShiftId,reversalOfId,reversedById,reversedAt,isReversed,isReversal,runningBalance]);
}

@override
String toString() {
    return 'CustomerLedgerEntryModel(id: $id, businessId: $businessId, customerId: $customerId, entryType: $entryType, amount: $amount, referenceType: $referenceType, referenceId: $referenceId, entryAt: $entryAt, notes: $notes, createdAt: $createdAt, branchId: $branchId, paymentSource: $paymentSource, referenceNo: $referenceNo, registerShiftId: $registerShiftId, reversalOfId: $reversalOfId, reversedById: $reversedById, reversedAt: $reversedAt, isReversed: $isReversed, isReversal: $isReversal, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$CustomerLedgerEntryModelCopyWith<$Res> implements $CustomerLedgerEntryModelCopyWith<$Res> {
  factory _$CustomerLedgerEntryModelCopyWith(_CustomerLedgerEntryModel value, $Res Function(_CustomerLedgerEntryModel) _then) = __$CustomerLedgerEntryModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'business_id') String businessId,@JsonKey(name: 'customer_id') String customerId,@JsonKey(name: 'entry_type', unknownEnumValue: LedgerEntryType.adjustment) LedgerEntryType entryType, String amount,@JsonKey(name: 'reference_type') String? referenceType,@JsonKey(name: 'reference_id') String? referenceId,@JsonKey(name: 'entry_at') String? entryAt, String? notes,@JsonKey(name: 'created_at') String? createdAt,@JsonKey(name: 'branch_id') String? branchId,@JsonKey(name: 'payment_source') String? paymentSource,@JsonKey(name: 'reference_no') String? referenceNo,@JsonKey(name: 'register_shift_id') String? registerShiftId,@JsonKey(name: 'reversal_of_id') String? reversalOfId,@JsonKey(name: 'reversed_by_id') String? reversedById,@JsonKey(name: 'reversed_at') String? reversedAt,@JsonKey(name: 'is_reversed') bool isReversed,@JsonKey(name: 'is_reversal') bool isReversal,@JsonKey(name: 'running_balance') String? runningBalance
});




}
/// @nodoc
class __$CustomerLedgerEntryModelCopyWithImpl<$Res>
    implements _$CustomerLedgerEntryModelCopyWith<$Res> {
  __$CustomerLedgerEntryModelCopyWithImpl(this._self, this._then);

  final _CustomerLedgerEntryModel _self;
  final $Res Function(_CustomerLedgerEntryModel) _then;

/// Create a copy of CustomerLedgerEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? businessId = null,Object? customerId = null,Object? entryType = null,Object? amount = null,Object? referenceType = freezed,Object? referenceId = freezed,Object? entryAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? branchId = freezed,Object? paymentSource = freezed,Object? referenceNo = freezed,Object? registerShiftId = freezed,Object? reversalOfId = freezed,Object? reversedById = freezed,Object? reversedAt = freezed,Object? isReversed = null,Object? isReversal = null,Object? runningBalance = freezed,}) {
  return _then(_CustomerLedgerEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,businessId: null == businessId ? _self.businessId : businessId // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,entryType: null == entryType ? _self.entryType : entryType // ignore: cast_nullable_to_non_nullable
as LedgerEntryType,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,referenceType: freezed == referenceType ? _self.referenceType : referenceType // ignore: cast_nullable_to_non_nullable
as String?,referenceId: freezed == referenceId ? _self.referenceId : referenceId // ignore: cast_nullable_to_non_nullable
as String?,entryAt: freezed == entryAt ? _self.entryAt : entryAt // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,paymentSource: freezed == paymentSource ? _self.paymentSource : paymentSource // ignore: cast_nullable_to_non_nullable
as String?,referenceNo: freezed == referenceNo ? _self.referenceNo : referenceNo // ignore: cast_nullable_to_non_nullable
as String?,registerShiftId: freezed == registerShiftId ? _self.registerShiftId : registerShiftId // ignore: cast_nullable_to_non_nullable
as String?,reversalOfId: freezed == reversalOfId ? _self.reversalOfId : reversalOfId // ignore: cast_nullable_to_non_nullable
as String?,reversedById: freezed == reversedById ? _self.reversedById : reversedById // ignore: cast_nullable_to_non_nullable
as String?,reversedAt: freezed == reversedAt ? _self.reversedAt : reversedAt // ignore: cast_nullable_to_non_nullable
as String?,isReversed: null == isReversed ? _self.isReversed : isReversed // ignore: cast_nullable_to_non_nullable
as bool,isReversal: null == isReversal ? _self.isReversal : isReversal // ignore: cast_nullable_to_non_nullable
as bool,runningBalance: freezed == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
