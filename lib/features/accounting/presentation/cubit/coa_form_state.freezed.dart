// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coa_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoaFormState {

 String? get accountId; String get accountCode; String get accountName; String get accountType; String? get accountSubtype; String? get parentId; String get description; bool get isActive; bool get isSystem; List<ChartOfAccountModel> get coaTreeRoots; bool get canManage; bool get isLoading; bool get isSubmitting; bool get isDeleting; Map<String, String> get errors;
/// Create a copy of CoaFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoaFormStateCopyWith<CoaFormState> get copyWith => _$CoaFormStateCopyWithImpl<CoaFormState>(this as CoaFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CoaFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaFormState&&(identical(other.accountId, _this.accountId) || other.accountId == _this.accountId)&&(identical(other.accountCode, _this.accountCode) || other.accountCode == _this.accountCode)&&(identical(other.accountName, _this.accountName) || other.accountName == _this.accountName)&&(identical(other.accountType, _this.accountType) || other.accountType == _this.accountType)&&(identical(other.accountSubtype, _this.accountSubtype) || other.accountSubtype == _this.accountSubtype)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.isSystem, _this.isSystem) || other.isSystem == _this.isSystem)&&const DeepCollectionEquality().equals(other.coaTreeRoots, _this.coaTreeRoots)&&(identical(other.canManage, _this.canManage) || other.canManage == _this.canManage)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as CoaFormState;
  return Object.hash(runtimeType,_this.accountId,_this.accountCode,_this.accountName,_this.accountType,_this.accountSubtype,_this.parentId,_this.description,_this.isActive,_this.isSystem,const DeepCollectionEquality().hash(_this.coaTreeRoots),_this.canManage,_this.isLoading,_this.isSubmitting,_this.isDeleting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as CoaFormState;
  return 'CoaFormState(accountId: ${_this.accountId}, accountCode: ${_this.accountCode}, accountName: ${_this.accountName}, accountType: ${_this.accountType}, accountSubtype: ${_this.accountSubtype}, parentId: ${_this.parentId}, description: ${_this.description}, isActive: ${_this.isActive}, isSystem: ${_this.isSystem}, coaTreeRoots: ${_this.coaTreeRoots}, canManage: ${_this.canManage}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, isDeleting: ${_this.isDeleting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $CoaFormStateCopyWith<$Res>  {
  factory $CoaFormStateCopyWith(CoaFormState value, $Res Function(CoaFormState) _then) = _$CoaFormStateCopyWithImpl;
@useResult
$Res call({
 String? accountId, String accountCode, String accountName, String accountType, String? accountSubtype, String? parentId, String description, bool isActive, bool isSystem, List<ChartOfAccountModel> coaTreeRoots, bool canManage, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class _$CoaFormStateCopyWithImpl<$Res>
    implements $CoaFormStateCopyWith<$Res> {
  _$CoaFormStateCopyWithImpl(this._self, this._then);

  final CoaFormState _self;
  final $Res Function(CoaFormState) _then;

/// Create a copy of CoaFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountId = freezed,Object? accountCode = null,Object? accountName = null,Object? accountType = null,Object? accountSubtype = freezed,Object? parentId = freezed,Object? description = null,Object? isActive = null,Object? isSystem = null,Object? coaTreeRoots = null,Object? canManage = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(CoaFormState(
accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,accountSubtype: freezed == accountSubtype ? _self.accountSubtype : accountSubtype // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,coaTreeRoots: null == coaTreeRoots ? _self.coaTreeRoots : coaTreeRoots // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CoaFormState].
extension CoaFormStatePatterns on CoaFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoaFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoaFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoaFormState value)  $default,){
final _that = this;
switch (_that) {
case _CoaFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoaFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CoaFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? accountId,  String accountCode,  String accountName,  String accountType,  String? accountSubtype,  String? parentId,  String description,  bool isActive,  bool isSystem,  List<ChartOfAccountModel> coaTreeRoots,  bool canManage,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoaFormState() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.parentId,_that.description,_that.isActive,_that.isSystem,_that.coaTreeRoots,_that.canManage,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? accountId,  String accountCode,  String accountName,  String accountType,  String? accountSubtype,  String? parentId,  String description,  bool isActive,  bool isSystem,  List<ChartOfAccountModel> coaTreeRoots,  bool canManage,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _CoaFormState():
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.parentId,_that.description,_that.isActive,_that.isSystem,_that.coaTreeRoots,_that.canManage,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? accountId,  String accountCode,  String accountName,  String accountType,  String? accountSubtype,  String? parentId,  String description,  bool isActive,  bool isSystem,  List<ChartOfAccountModel> coaTreeRoots,  bool canManage,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _CoaFormState() when $default != null:
return $default(_that.accountId,_that.accountCode,_that.accountName,_that.accountType,_that.accountSubtype,_that.parentId,_that.description,_that.isActive,_that.isSystem,_that.coaTreeRoots,_that.canManage,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _CoaFormState extends CoaFormState {
  const _CoaFormState({this.accountId, this.accountCode = '', this.accountName = '', this.accountType = AccountType.asset, this.accountSubtype, this.parentId, this.description = '', this.isActive = true, this.isSystem = false,  List<ChartOfAccountModel> coaTreeRoots = const [], this.canManage = false, this.isLoading = false, this.isSubmitting = false, this.isDeleting = false,  Map<String, String> errors = const {}}): _coaTreeRoots = coaTreeRoots,_errors = errors,super._();
  

@override final  String? accountId;
@override@JsonKey() final  String accountCode;
@override@JsonKey() final  String accountName;
@override@JsonKey() final  String accountType;
@override final  String? accountSubtype;
@override final  String? parentId;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  bool isSystem;
 final  List<ChartOfAccountModel> _coaTreeRoots;
@override@JsonKey() List<ChartOfAccountModel> get coaTreeRoots {
  if (_coaTreeRoots is EqualUnmodifiableListView) return _coaTreeRoots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_coaTreeRoots);
}

@override@JsonKey() final  bool canManage;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isDeleting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of CoaFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoaFormStateCopyWith<_CoaFormState> get copyWith => __$CoaFormStateCopyWithImpl<_CoaFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoaFormState&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.accountCode, accountCode) || other.accountCode == accountCode)&&(identical(other.accountName, accountName) || other.accountName == accountName)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.accountSubtype, accountSubtype) || other.accountSubtype == accountSubtype)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isSystem, isSystem) || other.isSystem == isSystem)&&const DeepCollectionEquality().equals(other.coaTreeRoots, _coaTreeRoots)&&(identical(other.canManage, canManage) || other.canManage == canManage)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,accountId,accountCode,accountName,accountType,accountSubtype,parentId,description,isActive,isSystem,const DeepCollectionEquality().hash(_coaTreeRoots),canManage,isLoading,isSubmitting,isDeleting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'CoaFormState(accountId: $accountId, accountCode: $accountCode, accountName: $accountName, accountType: $accountType, accountSubtype: $accountSubtype, parentId: $parentId, description: $description, isActive: $isActive, isSystem: $isSystem, coaTreeRoots: $coaTreeRoots, canManage: $canManage, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$CoaFormStateCopyWith<$Res> implements $CoaFormStateCopyWith<$Res> {
  factory _$CoaFormStateCopyWith(_CoaFormState value, $Res Function(_CoaFormState) _then) = __$CoaFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? accountId, String accountCode, String accountName, String accountType, String? accountSubtype, String? parentId, String description, bool isActive, bool isSystem, List<ChartOfAccountModel> coaTreeRoots, bool canManage, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class __$CoaFormStateCopyWithImpl<$Res>
    implements _$CoaFormStateCopyWith<$Res> {
  __$CoaFormStateCopyWithImpl(this._self, this._then);

  final _CoaFormState _self;
  final $Res Function(_CoaFormState) _then;

/// Create a copy of CoaFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountId = freezed,Object? accountCode = null,Object? accountName = null,Object? accountType = null,Object? accountSubtype = freezed,Object? parentId = freezed,Object? description = null,Object? isActive = null,Object? isSystem = null,Object? coaTreeRoots = null,Object? canManage = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(_CoaFormState(
accountId: freezed == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as String?,accountCode: null == accountCode ? _self.accountCode : accountCode // ignore: cast_nullable_to_non_nullable
as String,accountName: null == accountName ? _self.accountName : accountName // ignore: cast_nullable_to_non_nullable
as String,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,accountSubtype: freezed == accountSubtype ? _self.accountSubtype : accountSubtype // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isSystem: null == isSystem ? _self.isSystem : isSystem // ignore: cast_nullable_to_non_nullable
as bool,coaTreeRoots: null == coaTreeRoots ? _self._coaTreeRoots : coaTreeRoots // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
