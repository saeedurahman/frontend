// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_line_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JournalLineModel {

 String get id;@JsonKey(name: 'account_id') String get accountId;@JsonKey(name: 'account_code') String get accountCode;@JsonKey(name: 'account_name') String get accountName;@JsonKey(name: 'debit_amount') String get debitAmount;@JsonKey(name: 'credit_amount') String get creditAmount; String? get description;@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int get lineOrder;
/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalLineModelCopyWith<JournalLineModel> get copyWith => _$JournalLineModelCopyWithImpl<JournalLineModel>(this as JournalLineModel, _$identity);

  /// Serializes this JournalLineModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JournalLineModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalLineModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.debitAmount, _this.debitAmount) || other.debitAmount == _this.debitAmount)&&(identical(other.creditAmount, _this.creditAmount) || other.creditAmount == _this.creditAmount)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.lineOrder, _this.lineOrder) || other.lineOrder == _this.lineOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JournalLineModel;
  return Object.hash(runtimeType,_this.id,_this.accountId,_this.accountCode,_this.accountName,_this.debitAmount,_this.creditAmount,_this.description,_this.lineOrder);
}

@override
String toString() {
  final _this = this as JournalLineModel;
  return 'JournalLineModel(id: ${_this.id}, accountId: ${_this.accountId}, accountCode: ${_this.accountCode}, accountName: ${_this.accountName}, debitAmount: ${_this.debitAmount}, creditAmount: ${_this.creditAmount}, description: ${_this.description}, lineOrder: ${_this.lineOrder})';
}


}

/// @nodoc
abstract mixin class $JournalLineModelCopyWith<$Res>  {
  factory $JournalLineModelCopyWith(JournalLineModel value, $Res Function(JournalLineModel) _then) = _$JournalLineModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_code') String accountCode,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'debit_amount') String debitAmount,@JsonKey(name: 'credit_amount') String creditAmount, String? description,@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int lineOrder
});




}
/// @nodoc
class _$JournalLineModelCopyWithImpl<$Res>
    implements $JournalLineModelCopyWith<$Res> {
  _$JournalLineModelCopyWithImpl(this._self, this._then);

  final JournalLineModel _self;
  final $Res Function(JournalLineModel) _then;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? debitAmount = null,Object? creditAmount = null,Object? description = freezed,Object? lineOrder = null,}) {
  return _then(JournalLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debitAmount: null == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as String,creditAmount: null == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalLineModel].
extension JournalLineModelPatterns on JournalLineModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalLineModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalLineModel value)  $default,){
final _that = this;
switch (_that) {
case _JournalLineModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalLineModel value)?  $default,){
final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'debit_amount')  String debitAmount, @JsonKey(name: 'credit_amount')  String creditAmount,  String? description, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.debitAmount,_that.creditAmount,_that.description,_that.lineOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'debit_amount')  String debitAmount, @JsonKey(name: 'credit_amount')  String creditAmount,  String? description, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder)  $default,) {final _that = this;
switch (_that) {
case _JournalLineModel():
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.debitAmount,_that.creditAmount,_that.description,_that.lineOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'account_id')  String accountId, @JsonKey(name: 'account_code')  String accountCode, @JsonKey(name: 'account_name')  String accountName, @JsonKey(name: 'debit_amount')  String debitAmount, @JsonKey(name: 'credit_amount')  String creditAmount,  String? description, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr)  int lineOrder)?  $default,) {final _that = this;
switch (_that) {
case _JournalLineModel() when $default != null:
return $default(_that.id,_that.accountId,_that.accountCode,_that.accountName,_that.debitAmount,_that.creditAmount,_that.description,_that.lineOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JournalLineModel implements JournalLineModel {
  const _JournalLineModel({required this.id, @JsonKey(name: 'account_id') required this.accountId, @JsonKey(name: 'account_code') required this.accountCode, @JsonKey(name: 'account_name') required this.accountName, @JsonKey(name: 'debit_amount') required this.debitAmount, @JsonKey(name: 'credit_amount') required this.creditAmount, this.description, @JsonKey(name: 'line_order', fromJson: JsonNum.intOr) this.lineOrder = 0});
  factory _JournalLineModel.fromJson(Map<String, dynamic> json) => _$JournalLineModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'account_id') final  String accountId;
@override@JsonKey(name: 'account_code') final  String accountCode;
@override@JsonKey(name: 'account_name') final  String accountName;
@override@JsonKey(name: 'debit_amount') final  String debitAmount;
@override@JsonKey(name: 'credit_amount') final  String creditAmount;
@override final  String? description;
@override@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) final  int lineOrder;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalLineModelCopyWith<_JournalLineModel> get copyWith => __$JournalLineModelCopyWithImpl<_JournalLineModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JournalLineModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalLineModel&&(identical(other.id, id) || other.id == id)&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.debitAmount, debitAmount) || other.debitAmount == debitAmount)&&(identical(other.creditAmount, creditAmount) || other.creditAmount == creditAmount)&&(identical(other.description, description) || other.description == description)&&(identical(other.lineOrder, lineOrder) || other.lineOrder == lineOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,accountId,accountCode,accountName,debitAmount,creditAmount,description,lineOrder);
}

@override
String toString() {
    return 'JournalLineModel(id: $id, accountId: $accountId, accountCode: $accountCode, accountName: $accountName, debitAmount: $debitAmount, creditAmount: $creditAmount, description: $description, lineOrder: $lineOrder)';
}


}

/// @nodoc
abstract mixin class _$JournalLineModelCopyWith<$Res> implements $JournalLineModelCopyWith<$Res> {
  factory _$JournalLineModelCopyWith(_JournalLineModel value, $Res Function(_JournalLineModel) _then) = __$JournalLineModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'account_id') String accountId,@JsonKey(name: 'account_code') String accountCode,@JsonKey(name: 'account_name') String accountName,@JsonKey(name: 'debit_amount') String debitAmount,@JsonKey(name: 'credit_amount') String creditAmount, String? description,@JsonKey(name: 'line_order', fromJson: JsonNum.intOr) int lineOrder
});




}
/// @nodoc
class __$JournalLineModelCopyWithImpl<$Res>
    implements _$JournalLineModelCopyWith<$Res> {
  __$JournalLineModelCopyWithImpl(this._self, this._then);

  final _JournalLineModel _self;
  final $Res Function(_JournalLineModel) _then;

/// Create a copy of JournalLineModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? accountId = null,Object? accountCode = null,Object? accountName = null,Object? debitAmount = null,Object? creditAmount = null,Object? description = freezed,Object? lineOrder = null,}) {
  return _then(_JournalLineModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,accountId: null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,debitAmount: null == debitAmount ? _self.debitAmount : debitAmount // ignore: cast_nullable_to_non_nullable
as String,creditAmount: null == creditAmount ? _self.creditAmount : creditAmount // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,lineOrder: null == lineOrder ? _self.lineOrder : lineOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
