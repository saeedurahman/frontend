// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'boms_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BomsListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BomsListState()';
}


}

/// @nodoc
class $BomsListStateCopyWith<$Res>  {
$BomsListStateCopyWith(BomsListState _, $Res Function(BomsListState) __);
}


/// Adds pattern-matching-related methods to [BomsListState].
extension BomsListStatePatterns on BomsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BomsListInitial value)?  initial,TResult Function( BomsListLoading value)?  loading,TResult Function( BomsListLoaded value)?  loaded,TResult Function( BomsListError value)?  error,TResult Function( BomsListAccessDenied value)?  accessDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BomsListInitial() when initial != null:
return initial(_that);case BomsListLoading() when loading != null:
return loading(_that);case BomsListLoaded() when loaded != null:
return loaded(_that);case BomsListError() when error != null:
return error(_that);case BomsListAccessDenied() when accessDenied != null:
return accessDenied(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BomsListInitial value)  initial,required TResult Function( BomsListLoading value)  loading,required TResult Function( BomsListLoaded value)  loaded,required TResult Function( BomsListError value)  error,required TResult Function( BomsListAccessDenied value)  accessDenied,}){
final _that = this;
switch (_that) {
case BomsListInitial():
return initial(_that);case BomsListLoading():
return loading(_that);case BomsListLoaded():
return loaded(_that);case BomsListError():
return error(_that);case BomsListAccessDenied():
return accessDenied(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BomsListInitial value)?  initial,TResult? Function( BomsListLoading value)?  loading,TResult? Function( BomsListLoaded value)?  loaded,TResult? Function( BomsListError value)?  error,TResult? Function( BomsListAccessDenied value)?  accessDenied,}){
final _that = this;
switch (_that) {
case BomsListInitial() when initial != null:
return initial(_that);case BomsListLoading() when loading != null:
return loading(_that);case BomsListLoaded() when loaded != null:
return loaded(_that);case BomsListError() when error != null:
return error(_that);case BomsListAccessDenied() when accessDenied != null:
return accessDenied(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BomHeaderModel> allBoms,  List<BomHeaderModel> filteredBoms,  bool activeOnlyFilter,  String searchQuery,  bool canManage)?  loaded,TResult Function( String message)?  error,TResult Function()?  accessDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BomsListInitial() when initial != null:
return initial();case BomsListLoading() when loading != null:
return loading();case BomsListLoaded() when loaded != null:
return loaded(_that.allBoms,_that.filteredBoms,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case BomsListError() when error != null:
return error(_that.message);case BomsListAccessDenied() when accessDenied != null:
return accessDenied();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BomHeaderModel> allBoms,  List<BomHeaderModel> filteredBoms,  bool activeOnlyFilter,  String searchQuery,  bool canManage)  loaded,required TResult Function( String message)  error,required TResult Function()  accessDenied,}) {final _that = this;
switch (_that) {
case BomsListInitial():
return initial();case BomsListLoading():
return loading();case BomsListLoaded():
return loaded(_that.allBoms,_that.filteredBoms,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case BomsListError():
return error(_that.message);case BomsListAccessDenied():
return accessDenied();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BomHeaderModel> allBoms,  List<BomHeaderModel> filteredBoms,  bool activeOnlyFilter,  String searchQuery,  bool canManage)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  accessDenied,}) {final _that = this;
switch (_that) {
case BomsListInitial() when initial != null:
return initial();case BomsListLoading() when loading != null:
return loading();case BomsListLoaded() when loaded != null:
return loaded(_that.allBoms,_that.filteredBoms,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case BomsListError() when error != null:
return error(_that.message);case BomsListAccessDenied() when accessDenied != null:
return accessDenied();case _:
  return null;

}
}

}

/// @nodoc


class BomsListInitial implements BomsListState {
  const BomsListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BomsListState.initial()';
}


}




/// @nodoc


class BomsListLoading implements BomsListState {
  const BomsListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BomsListState.loading()';
}


}




/// @nodoc


class BomsListLoaded implements BomsListState {
  const BomsListLoaded({required  List<BomHeaderModel> allBoms, required  List<BomHeaderModel> filteredBoms, this.activeOnlyFilter = false, this.searchQuery = '', this.canManage = false}): _allBoms = allBoms,_filteredBoms = filteredBoms;
  

 final  List<BomHeaderModel> _allBoms;
 List<BomHeaderModel> get allBoms {
  if (_allBoms is EqualUnmodifiableListView) return _allBoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allBoms);
}

 final  List<BomHeaderModel> _filteredBoms;
 List<BomHeaderModel> get filteredBoms {
  if (_filteredBoms is EqualUnmodifiableListView) return _filteredBoms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredBoms);
}

@JsonKey() final  bool activeOnlyFilter;
@JsonKey() final  String searchQuery;
@JsonKey() final  bool canManage;

/// Create a copy of BomsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomsListLoadedCopyWith<BomsListLoaded> get copyWith => _$BomsListLoadedCopyWithImpl<BomsListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListLoaded&&const DeepCollectionEquality().equals(other.allBoms, _allBoms)&&const DeepCollectionEquality().equals(other.filteredBoms, _filteredBoms)&&(identical(other.activeOnlyFilter, activeOnlyFilter) || other.activeOnlyFilter == activeOnlyFilter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.canManage, canManage) || other.canManage == canManage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_allBoms),const DeepCollectionEquality().hash(_filteredBoms),activeOnlyFilter,searchQuery,canManage);
}

@override
String toString() {
    return 'BomsListState.loaded(allBoms: $allBoms, filteredBoms: $filteredBoms, activeOnlyFilter: $activeOnlyFilter, searchQuery: $searchQuery, canManage: $canManage)';
}


}

/// @nodoc
abstract mixin class $BomsListLoadedCopyWith<$Res> implements $BomsListStateCopyWith<$Res> {
  factory $BomsListLoadedCopyWith(BomsListLoaded value, $Res Function(BomsListLoaded) _then) = _$BomsListLoadedCopyWithImpl;
@useResult
$Res call({
 List<BomHeaderModel> allBoms, List<BomHeaderModel> filteredBoms, bool activeOnlyFilter, String searchQuery, bool canManage
});




}
/// @nodoc
class _$BomsListLoadedCopyWithImpl<$Res>
    implements $BomsListLoadedCopyWith<$Res> {
  _$BomsListLoadedCopyWithImpl(this._self, this._then);

  final BomsListLoaded _self;
  final $Res Function(BomsListLoaded) _then;

/// Create a copy of BomsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allBoms = null,Object? filteredBoms = null,Object? activeOnlyFilter = null,Object? searchQuery = null,Object? canManage = null,}) {
  return _then(BomsListLoaded(
allBoms: null == allBoms ? _self._allBoms : allBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,filteredBoms: null == filteredBoms ? _self._filteredBoms : filteredBoms // ignore: cast_nullable_to_non_nullable
as List<BomHeaderModel>,activeOnlyFilter: null == activeOnlyFilter ? _self.activeOnlyFilter : activeOnlyFilter // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class BomsListError implements BomsListState {
  const BomsListError(this.message);
  

 final  String message;

/// Create a copy of BomsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BomsListErrorCopyWith<BomsListError> get copyWith => _$BomsListErrorCopyWithImpl<BomsListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'BomsListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BomsListErrorCopyWith<$Res> implements $BomsListStateCopyWith<$Res> {
  factory $BomsListErrorCopyWith(BomsListError value, $Res Function(BomsListError) _then) = _$BomsListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BomsListErrorCopyWithImpl<$Res>
    implements $BomsListErrorCopyWith<$Res> {
  _$BomsListErrorCopyWithImpl(this._self, this._then);

  final BomsListError _self;
  final $Res Function(BomsListError) _then;

/// Create a copy of BomsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BomsListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class BomsListAccessDenied implements BomsListState {
  const BomsListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is BomsListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'BomsListState.accessDenied()';
}


}




// dart format on
