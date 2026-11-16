// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coa_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoaListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoaListState()';
}


}

/// @nodoc
class $CoaListStateCopyWith<$Res>  {
$CoaListStateCopyWith(CoaListState _, $Res Function(CoaListState) __);
}


/// Adds pattern-matching-related methods to [CoaListState].
extension CoaListStatePatterns on CoaListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CoaListInitial value)?  initial,TResult Function( CoaListLoading value)?  loading,TResult Function( CoaListLoaded value)?  loaded,TResult Function( CoaListError value)?  error,TResult Function( CoaListAccessDenied value)?  accessDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CoaListInitial() when initial != null:
return initial(_that);case CoaListLoading() when loading != null:
return loading(_that);case CoaListLoaded() when loaded != null:
return loaded(_that);case CoaListError() when error != null:
return error(_that);case CoaListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CoaListInitial value)  initial,required TResult Function( CoaListLoading value)  loading,required TResult Function( CoaListLoaded value)  loaded,required TResult Function( CoaListError value)  error,required TResult Function( CoaListAccessDenied value)  accessDenied,}){
final _that = this;
switch (_that) {
case CoaListInitial():
return initial(_that);case CoaListLoading():
return loading(_that);case CoaListLoaded():
return loaded(_that);case CoaListError():
return error(_that);case CoaListAccessDenied():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CoaListInitial value)?  initial,TResult? Function( CoaListLoading value)?  loading,TResult? Function( CoaListLoaded value)?  loaded,TResult? Function( CoaListError value)?  error,TResult? Function( CoaListAccessDenied value)?  accessDenied,}){
final _that = this;
switch (_that) {
case CoaListInitial() when initial != null:
return initial(_that);case CoaListLoading() when loading != null:
return loading(_that);case CoaListLoaded() when loaded != null:
return loaded(_that);case CoaListError() when error != null:
return error(_that);case CoaListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ChartOfAccountModel> treeRoots,  List<FlatCoaNode> filteredNodes,  bool activeOnlyFilter,  String searchQuery,  bool canManage)?  loaded,TResult Function( String message)?  error,TResult Function()?  accessDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CoaListInitial() when initial != null:
return initial();case CoaListLoading() when loading != null:
return loading();case CoaListLoaded() when loaded != null:
return loaded(_that.treeRoots,_that.filteredNodes,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case CoaListError() when error != null:
return error(_that.message);case CoaListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ChartOfAccountModel> treeRoots,  List<FlatCoaNode> filteredNodes,  bool activeOnlyFilter,  String searchQuery,  bool canManage)  loaded,required TResult Function( String message)  error,required TResult Function()  accessDenied,}) {final _that = this;
switch (_that) {
case CoaListInitial():
return initial();case CoaListLoading():
return loading();case CoaListLoaded():
return loaded(_that.treeRoots,_that.filteredNodes,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case CoaListError():
return error(_that.message);case CoaListAccessDenied():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ChartOfAccountModel> treeRoots,  List<FlatCoaNode> filteredNodes,  bool activeOnlyFilter,  String searchQuery,  bool canManage)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  accessDenied,}) {final _that = this;
switch (_that) {
case CoaListInitial() when initial != null:
return initial();case CoaListLoading() when loading != null:
return loading();case CoaListLoaded() when loaded != null:
return loaded(_that.treeRoots,_that.filteredNodes,_that.activeOnlyFilter,_that.searchQuery,_that.canManage);case CoaListError() when error != null:
return error(_that.message);case CoaListAccessDenied() when accessDenied != null:
return accessDenied();case _:
  return null;

}
}

}

/// @nodoc


class CoaListInitial implements CoaListState {
  const CoaListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoaListState.initial()';
}


}




/// @nodoc


class CoaListLoading implements CoaListState {
  const CoaListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoaListState.loading()';
}


}




/// @nodoc


class CoaListLoaded implements CoaListState {
  const CoaListLoaded({required  List<ChartOfAccountModel> treeRoots, required  List<FlatCoaNode> filteredNodes, this.activeOnlyFilter = false, this.searchQuery = '', this.canManage = false}): _treeRoots = treeRoots,_filteredNodes = filteredNodes;
  

 final  List<ChartOfAccountModel> _treeRoots;
 List<ChartOfAccountModel> get treeRoots {
  if (_treeRoots is EqualUnmodifiableListView) return _treeRoots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_treeRoots);
}

 final  List<FlatCoaNode> _filteredNodes;
 List<FlatCoaNode> get filteredNodes {
  if (_filteredNodes is EqualUnmodifiableListView) return _filteredNodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredNodes);
}

@JsonKey() final  bool activeOnlyFilter;
@JsonKey() final  String searchQuery;
@JsonKey() final  bool canManage;

/// Create a copy of CoaListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoaListLoadedCopyWith<CoaListLoaded> get copyWith => _$CoaListLoadedCopyWithImpl<CoaListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListLoaded&&const DeepCollectionEquality().equals(other.treeRoots, _treeRoots)&&const DeepCollectionEquality().equals(other.filteredNodes, _filteredNodes)&&(identical(other.activeOnlyFilter, activeOnlyFilter) || other.activeOnlyFilter == activeOnlyFilter)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.canManage, canManage) || other.canManage == canManage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_treeRoots),const DeepCollectionEquality().hash(_filteredNodes),activeOnlyFilter,searchQuery,canManage);
}

@override
String toString() {
    return 'CoaListState.loaded(treeRoots: $treeRoots, filteredNodes: $filteredNodes, activeOnlyFilter: $activeOnlyFilter, searchQuery: $searchQuery, canManage: $canManage)';
}


}

/// @nodoc
abstract mixin class $CoaListLoadedCopyWith<$Res> implements $CoaListStateCopyWith<$Res> {
  factory $CoaListLoadedCopyWith(CoaListLoaded value, $Res Function(CoaListLoaded) _then) = _$CoaListLoadedCopyWithImpl;
@useResult
$Res call({
 List<ChartOfAccountModel> treeRoots, List<FlatCoaNode> filteredNodes, bool activeOnlyFilter, String searchQuery, bool canManage
});




}
/// @nodoc
class _$CoaListLoadedCopyWithImpl<$Res>
    implements $CoaListLoadedCopyWith<$Res> {
  _$CoaListLoadedCopyWithImpl(this._self, this._then);

  final CoaListLoaded _self;
  final $Res Function(CoaListLoaded) _then;

/// Create a copy of CoaListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? treeRoots = null,Object? filteredNodes = null,Object? activeOnlyFilter = null,Object? searchQuery = null,Object? canManage = null,}) {
  return _then(CoaListLoaded(
treeRoots: null == treeRoots ? _self._treeRoots : treeRoots // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,filteredNodes: null == filteredNodes ? _self._filteredNodes : filteredNodes // ignore: cast_nullable_to_non_nullable
as List<FlatCoaNode>,activeOnlyFilter: null == activeOnlyFilter ? _self.activeOnlyFilter : activeOnlyFilter // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,canManage: null == canManage ? _self.canManage : canManage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CoaListError implements CoaListState {
  const CoaListError(this.message);
  

 final  String message;

/// Create a copy of CoaListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoaListErrorCopyWith<CoaListError> get copyWith => _$CoaListErrorCopyWithImpl<CoaListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CoaListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CoaListErrorCopyWith<$Res> implements $CoaListStateCopyWith<$Res> {
  factory $CoaListErrorCopyWith(CoaListError value, $Res Function(CoaListError) _then) = _$CoaListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CoaListErrorCopyWithImpl<$Res>
    implements $CoaListErrorCopyWith<$Res> {
  _$CoaListErrorCopyWithImpl(this._self, this._then);

  final CoaListError _self;
  final $Res Function(CoaListError) _then;

/// Create a copy of CoaListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CoaListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class CoaListAccessDenied implements CoaListState {
  const CoaListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CoaListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CoaListState.accessDenied()';
}


}




// dart format on
