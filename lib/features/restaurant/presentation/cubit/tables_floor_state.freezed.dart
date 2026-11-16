// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tables_floor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TablesFloorState {

 TablesFloorStatus get status; FloorLayoutModel? get layout; String? get selectedFloorPlanId; bool get isRefreshing; bool get accessDenied; String? get errorMessage;
/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TablesFloorStateCopyWith<TablesFloorState> get copyWith => _$TablesFloorStateCopyWithImpl<TablesFloorState>(this as TablesFloorState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TablesFloorState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TablesFloorState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.layout, _this.layout) || other.layout == _this.layout)&&(identical(other.selectedFloorPlanId, _this.selectedFloorPlanId) || other.selectedFloorPlanId == _this.selectedFloorPlanId)&&(identical(other.isRefreshing, _this.isRefreshing) || other.isRefreshing == _this.isRefreshing)&&(identical(other.accessDenied, _this.accessDenied) || other.accessDenied == _this.accessDenied)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as TablesFloorState;
  return Object.hash(runtimeType,_this.status,_this.layout,_this.selectedFloorPlanId,_this.isRefreshing,_this.accessDenied,_this.errorMessage);
}

@override
String toString() {
  final _this = this as TablesFloorState;
  return 'TablesFloorState(status: ${_this.status}, layout: ${_this.layout}, selectedFloorPlanId: ${_this.selectedFloorPlanId}, isRefreshing: ${_this.isRefreshing}, accessDenied: ${_this.accessDenied}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $TablesFloorStateCopyWith<$Res>  {
  factory $TablesFloorStateCopyWith(TablesFloorState value, $Res Function(TablesFloorState) _then) = _$TablesFloorStateCopyWithImpl;
@useResult
$Res call({
 TablesFloorStatus status, FloorLayoutModel? layout, String? selectedFloorPlanId, bool isRefreshing, bool accessDenied, String? errorMessage
});


$FloorLayoutModelCopyWith<$Res>? get layout;

}
/// @nodoc
class _$TablesFloorStateCopyWithImpl<$Res>
    implements $TablesFloorStateCopyWith<$Res> {
  _$TablesFloorStateCopyWithImpl(this._self, this._then);

  final TablesFloorState _self;
  final $Res Function(TablesFloorState) _then;

/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? layout = freezed,Object? selectedFloorPlanId = freezed,Object? isRefreshing = null,Object? accessDenied = null,Object? errorMessage = freezed,}) {
  return _then(TablesFloorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TablesFloorStatus,layout: freezed == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FloorLayoutModel?,selectedFloorPlanId: freezed == selectedFloorPlanId ? _self.selectedFloorPlanId : selectedFloorPlanId // ignore: cast_nullable_to_non_nullable
as String?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorLayoutModelCopyWith<$Res>? get layout {
    if (_self.layout == null) {
    return null;
  }

  return $FloorLayoutModelCopyWith<$Res>(_self.layout!, (value) {
    return _then(_self.copyWith(layout: value));
  });
}
}


/// Adds pattern-matching-related methods to [TablesFloorState].
extension TablesFloorStatePatterns on TablesFloorState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TablesFloorState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TablesFloorState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TablesFloorState value)  $default,){
final _that = this;
switch (_that) {
case _TablesFloorState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TablesFloorState value)?  $default,){
final _that = this;
switch (_that) {
case _TablesFloorState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TablesFloorStatus status,  FloorLayoutModel? layout,  String? selectedFloorPlanId,  bool isRefreshing,  bool accessDenied,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TablesFloorState() when $default != null:
return $default(_that.status,_that.layout,_that.selectedFloorPlanId,_that.isRefreshing,_that.accessDenied,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TablesFloorStatus status,  FloorLayoutModel? layout,  String? selectedFloorPlanId,  bool isRefreshing,  bool accessDenied,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _TablesFloorState():
return $default(_that.status,_that.layout,_that.selectedFloorPlanId,_that.isRefreshing,_that.accessDenied,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TablesFloorStatus status,  FloorLayoutModel? layout,  String? selectedFloorPlanId,  bool isRefreshing,  bool accessDenied,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _TablesFloorState() when $default != null:
return $default(_that.status,_that.layout,_that.selectedFloorPlanId,_that.isRefreshing,_that.accessDenied,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _TablesFloorState extends TablesFloorState {
  const _TablesFloorState({this.status = TablesFloorStatus.initial, this.layout, this.selectedFloorPlanId, this.isRefreshing = false, this.accessDenied = false, this.errorMessage}): super._();
  

@override@JsonKey() final  TablesFloorStatus status;
@override final  FloorLayoutModel? layout;
@override final  String? selectedFloorPlanId;
@override@JsonKey() final  bool isRefreshing;
@override@JsonKey() final  bool accessDenied;
@override final  String? errorMessage;

/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TablesFloorStateCopyWith<_TablesFloorState> get copyWith => __$TablesFloorStateCopyWithImpl<_TablesFloorState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TablesFloorState&&(identical(other.status, status) || other.status == status)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.selectedFloorPlanId, selectedFloorPlanId) || other.selectedFloorPlanId == selectedFloorPlanId)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.accessDenied, accessDenied) || other.accessDenied == accessDenied)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,layout,selectedFloorPlanId,isRefreshing,accessDenied,errorMessage);
}

@override
String toString() {
    return 'TablesFloorState(status: $status, layout: $layout, selectedFloorPlanId: $selectedFloorPlanId, isRefreshing: $isRefreshing, accessDenied: $accessDenied, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$TablesFloorStateCopyWith<$Res> implements $TablesFloorStateCopyWith<$Res> {
  factory _$TablesFloorStateCopyWith(_TablesFloorState value, $Res Function(_TablesFloorState) _then) = __$TablesFloorStateCopyWithImpl;
@override @useResult
$Res call({
 TablesFloorStatus status, FloorLayoutModel? layout, String? selectedFloorPlanId, bool isRefreshing, bool accessDenied, String? errorMessage
});


@override $FloorLayoutModelCopyWith<$Res>? get layout;

}
/// @nodoc
class __$TablesFloorStateCopyWithImpl<$Res>
    implements _$TablesFloorStateCopyWith<$Res> {
  __$TablesFloorStateCopyWithImpl(this._self, this._then);

  final _TablesFloorState _self;
  final $Res Function(_TablesFloorState) _then;

/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? layout = freezed,Object? selectedFloorPlanId = freezed,Object? isRefreshing = null,Object? accessDenied = null,Object? errorMessage = freezed,}) {
  return _then(_TablesFloorState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TablesFloorStatus,layout: freezed == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as FloorLayoutModel?,selectedFloorPlanId: freezed == selectedFloorPlanId ? _self.selectedFloorPlanId : selectedFloorPlanId // ignore: cast_nullable_to_non_nullable
as String?,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,accessDenied: null == accessDenied ? _self.accessDenied : accessDenied // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TablesFloorState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FloorLayoutModelCopyWith<$Res>? get layout {
    if (_self.layout == null) {
    return null;
  }

  return $FloorLayoutModelCopyWith<$Res>(_self.layout!, (value) {
    return _then(_self.copyWith(layout: value));
  });
}
}

// dart format on
