// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinLoginState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PinLoginState()';
}


}

/// @nodoc
class $PinLoginStateCopyWith<$Res>  {
$PinLoginStateCopyWith(PinLoginState _, $Res Function(PinLoginState) __);
}


/// Adds pattern-matching-related methods to [PinLoginState].
extension PinLoginStatePatterns on PinLoginState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PinLoginInitial value)?  initial,TResult Function( PinLoginLoading value)?  loading,TResult Function( PinLoginNeedsSetup value)?  needsSetup,TResult Function( PinLoginReady value)?  ready,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PinLoginInitial() when initial != null:
return initial(_that);case PinLoginLoading() when loading != null:
return loading(_that);case PinLoginNeedsSetup() when needsSetup != null:
return needsSetup(_that);case PinLoginReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PinLoginInitial value)  initial,required TResult Function( PinLoginLoading value)  loading,required TResult Function( PinLoginNeedsSetup value)  needsSetup,required TResult Function( PinLoginReady value)  ready,}){
final _that = this;
switch (_that) {
case PinLoginInitial():
return initial(_that);case PinLoginLoading():
return loading(_that);case PinLoginNeedsSetup():
return needsSetup(_that);case PinLoginReady():
return ready(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PinLoginInitial value)?  initial,TResult? Function( PinLoginLoading value)?  loading,TResult? Function( PinLoginNeedsSetup value)?  needsSetup,TResult? Function( PinLoginReady value)?  ready,}){
final _that = this;
switch (_that) {
case PinLoginInitial() when initial != null:
return initial(_that);case PinLoginLoading() when loading != null:
return loading(_that);case PinLoginNeedsSetup() when needsSetup != null:
return needsSetup(_that);case PinLoginReady() when ready != null:
return ready(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  needsSetup,TResult Function( String businessSlug,  List<PinStaffEntry> staff,  String selectedStaffId)?  ready,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PinLoginInitial() when initial != null:
return initial();case PinLoginLoading() when loading != null:
return loading();case PinLoginNeedsSetup() when needsSetup != null:
return needsSetup();case PinLoginReady() when ready != null:
return ready(_that.businessSlug,_that.staff,_that.selectedStaffId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  needsSetup,required TResult Function( String businessSlug,  List<PinStaffEntry> staff,  String selectedStaffId)  ready,}) {final _that = this;
switch (_that) {
case PinLoginInitial():
return initial();case PinLoginLoading():
return loading();case PinLoginNeedsSetup():
return needsSetup();case PinLoginReady():
return ready(_that.businessSlug,_that.staff,_that.selectedStaffId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  needsSetup,TResult? Function( String businessSlug,  List<PinStaffEntry> staff,  String selectedStaffId)?  ready,}) {final _that = this;
switch (_that) {
case PinLoginInitial() when initial != null:
return initial();case PinLoginLoading() when loading != null:
return loading();case PinLoginNeedsSetup() when needsSetup != null:
return needsSetup();case PinLoginReady() when ready != null:
return ready(_that.businessSlug,_that.staff,_that.selectedStaffId);case _:
  return null;

}
}

}

/// @nodoc


class PinLoginInitial implements PinLoginState {
  const PinLoginInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PinLoginState.initial()';
}


}




/// @nodoc


class PinLoginLoading implements PinLoginState {
  const PinLoginLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PinLoginState.loading()';
}


}




/// @nodoc


class PinLoginNeedsSetup implements PinLoginState {
  const PinLoginNeedsSetup();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginNeedsSetup);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PinLoginState.needsSetup()';
}


}




/// @nodoc


class PinLoginReady implements PinLoginState {
  const PinLoginReady({required this.businessSlug, required  List<PinStaffEntry> staff, required this.selectedStaffId}): _staff = staff;
  

 final  String businessSlug;
 final  List<PinStaffEntry> _staff;
 List<PinStaffEntry> get staff {
  if (_staff is EqualUnmodifiableListView) return _staff;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staff);
}

 final  String selectedStaffId;

/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinLoginReadyCopyWith<PinLoginReady> get copyWith => _$PinLoginReadyCopyWithImpl<PinLoginReady>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PinLoginReady&&(identical(other.businessSlug, businessSlug) || other.businessSlug == businessSlug)&&const DeepCollectionEquality().equals(other.staff, _staff)&&(identical(other.selectedStaffId, selectedStaffId) || other.selectedStaffId == selectedStaffId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,businessSlug,const DeepCollectionEquality().hash(_staff),selectedStaffId);
}

@override
String toString() {
    return 'PinLoginState.ready(businessSlug: $businessSlug, staff: $staff, selectedStaffId: $selectedStaffId)';
}


}

/// @nodoc
abstract mixin class $PinLoginReadyCopyWith<$Res> implements $PinLoginStateCopyWith<$Res> {
  factory $PinLoginReadyCopyWith(PinLoginReady value, $Res Function(PinLoginReady) _then) = _$PinLoginReadyCopyWithImpl;
@useResult
$Res call({
 String businessSlug, List<PinStaffEntry> staff, String selectedStaffId
});




}
/// @nodoc
class _$PinLoginReadyCopyWithImpl<$Res>
    implements $PinLoginReadyCopyWith<$Res> {
  _$PinLoginReadyCopyWithImpl(this._self, this._then);

  final PinLoginReady _self;
  final $Res Function(PinLoginReady) _then;

/// Create a copy of PinLoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? businessSlug = null,Object? staff = null,Object? selectedStaffId = null,}) {
  return _then(PinLoginReady(
businessSlug: null == businessSlug ? _self.businessSlug : businessSlug // ignore: cast_nullable_to_non_nullable
as String,staff: null == staff ? _self._staff : staff // ignore: cast_nullable_to_non_nullable
as List<PinStaffEntry>,selectedStaffId: null == selectedStaffId ? _self.selectedStaffId : selectedStaffId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
