// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entries_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEntriesListState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'JournalEntriesListState()';
}


}

/// @nodoc
class $JournalEntriesListStateCopyWith<$Res>  {
$JournalEntriesListStateCopyWith(JournalEntriesListState _, $Res Function(JournalEntriesListState) __);
}


/// Adds pattern-matching-related methods to [JournalEntriesListState].
extension JournalEntriesListStatePatterns on JournalEntriesListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( JournalEntriesListInitial value)?  initial,TResult Function( JournalEntriesListLoading value)?  loading,TResult Function( JournalEntriesListLoaded value)?  loaded,TResult Function( JournalEntriesListError value)?  error,TResult Function( JournalEntriesListAccessDenied value)?  accessDenied,required TResult orElse(),}){
final _that = this;
switch (_that) {
case JournalEntriesListInitial() when initial != null:
return initial(_that);case JournalEntriesListLoading() when loading != null:
return loading(_that);case JournalEntriesListLoaded() when loaded != null:
return loaded(_that);case JournalEntriesListError() when error != null:
return error(_that);case JournalEntriesListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( JournalEntriesListInitial value)  initial,required TResult Function( JournalEntriesListLoading value)  loading,required TResult Function( JournalEntriesListLoaded value)  loaded,required TResult Function( JournalEntriesListError value)  error,required TResult Function( JournalEntriesListAccessDenied value)  accessDenied,}){
final _that = this;
switch (_that) {
case JournalEntriesListInitial():
return initial(_that);case JournalEntriesListLoading():
return loading(_that);case JournalEntriesListLoaded():
return loaded(_that);case JournalEntriesListError():
return error(_that);case JournalEntriesListAccessDenied():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( JournalEntriesListInitial value)?  initial,TResult? Function( JournalEntriesListLoading value)?  loading,TResult? Function( JournalEntriesListLoaded value)?  loaded,TResult? Function( JournalEntriesListError value)?  error,TResult? Function( JournalEntriesListAccessDenied value)?  accessDenied,}){
final _that = this;
switch (_that) {
case JournalEntriesListInitial() when initial != null:
return initial(_that);case JournalEntriesListLoading() when loading != null:
return loading(_that);case JournalEntriesListLoaded() when loaded != null:
return loaded(_that);case JournalEntriesListError() when error != null:
return error(_that);case JournalEntriesListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<JournalEntryListModel> entries,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate)?  loaded,TResult Function( String message)?  error,TResult Function()?  accessDenied,required TResult orElse(),}) {final _that = this;
switch (_that) {
case JournalEntriesListInitial() when initial != null:
return initial();case JournalEntriesListLoading() when loading != null:
return loading();case JournalEntriesListLoaded() when loaded != null:
return loaded(_that.entries,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate);case JournalEntriesListError() when error != null:
return error(_that.message);case JournalEntriesListAccessDenied() when accessDenied != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<JournalEntryListModel> entries,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate)  loaded,required TResult Function( String message)  error,required TResult Function()  accessDenied,}) {final _that = this;
switch (_that) {
case JournalEntriesListInitial():
return initial();case JournalEntriesListLoading():
return loading();case JournalEntriesListLoaded():
return loaded(_that.entries,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate);case JournalEntriesListError():
return error(_that.message);case JournalEntriesListAccessDenied():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<JournalEntryListModel> entries,  String? statusFilter,  DateTime? dateFrom,  DateTime? dateTo,  bool canCreate)?  loaded,TResult? Function( String message)?  error,TResult? Function()?  accessDenied,}) {final _that = this;
switch (_that) {
case JournalEntriesListInitial() when initial != null:
return initial();case JournalEntriesListLoading() when loading != null:
return loading();case JournalEntriesListLoaded() when loaded != null:
return loaded(_that.entries,_that.statusFilter,_that.dateFrom,_that.dateTo,_that.canCreate);case JournalEntriesListError() when error != null:
return error(_that.message);case JournalEntriesListAccessDenied() when accessDenied != null:
return accessDenied();case _:
  return null;

}
}

}

/// @nodoc


class JournalEntriesListInitial implements JournalEntriesListState {
  const JournalEntriesListInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'JournalEntriesListState.initial()';
}


}




/// @nodoc


class JournalEntriesListLoading implements JournalEntriesListState {
  const JournalEntriesListLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'JournalEntriesListState.loading()';
}


}




/// @nodoc


class JournalEntriesListLoaded implements JournalEntriesListState {
  const JournalEntriesListLoaded({required  List<JournalEntryListModel> entries, this.statusFilter, this.dateFrom, this.dateTo, this.canCreate = false}): _entries = entries;
  

 final  List<JournalEntryListModel> _entries;
 List<JournalEntryListModel> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

 final  String? statusFilter;
 final  DateTime? dateFrom;
 final  DateTime? dateTo;
@JsonKey() final  bool canCreate;

/// Create a copy of JournalEntriesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntriesListLoadedCopyWith<JournalEntriesListLoaded> get copyWith => _$JournalEntriesListLoadedCopyWithImpl<JournalEntriesListLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListLoaded&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_entries),statusFilter,dateFrom,dateTo,canCreate);
}

@override
String toString() {
    return 'JournalEntriesListState.loaded(entries: $entries, statusFilter: $statusFilter, dateFrom: $dateFrom, dateTo: $dateTo, canCreate: $canCreate)';
}


}

/// @nodoc
abstract mixin class $JournalEntriesListLoadedCopyWith<$Res> implements $JournalEntriesListStateCopyWith<$Res> {
  factory $JournalEntriesListLoadedCopyWith(JournalEntriesListLoaded value, $Res Function(JournalEntriesListLoaded) _then) = _$JournalEntriesListLoadedCopyWithImpl;
@useResult
$Res call({
 List<JournalEntryListModel> entries, String? statusFilter, DateTime? dateFrom, DateTime? dateTo, bool canCreate
});




}
/// @nodoc
class _$JournalEntriesListLoadedCopyWithImpl<$Res>
    implements $JournalEntriesListLoadedCopyWith<$Res> {
  _$JournalEntriesListLoadedCopyWithImpl(this._self, this._then);

  final JournalEntriesListLoaded _self;
  final $Res Function(JournalEntriesListLoaded) _then;

/// Create a copy of JournalEntriesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entries = null,Object? statusFilter = freezed,Object? dateFrom = freezed,Object? dateTo = freezed,Object? canCreate = null,}) {
  return _then(JournalEntriesListLoaded(
entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<JournalEntryListModel>,statusFilter: freezed == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as String?,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class JournalEntriesListError implements JournalEntriesListState {
  const JournalEntriesListError(this.message);
  

 final  String message;

/// Create a copy of JournalEntriesListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntriesListErrorCopyWith<JournalEntriesListError> get copyWith => _$JournalEntriesListErrorCopyWithImpl<JournalEntriesListError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'JournalEntriesListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $JournalEntriesListErrorCopyWith<$Res> implements $JournalEntriesListStateCopyWith<$Res> {
  factory $JournalEntriesListErrorCopyWith(JournalEntriesListError value, $Res Function(JournalEntriesListError) _then) = _$JournalEntriesListErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$JournalEntriesListErrorCopyWithImpl<$Res>
    implements $JournalEntriesListErrorCopyWith<$Res> {
  _$JournalEntriesListErrorCopyWithImpl(this._self, this._then);

  final JournalEntriesListError _self;
  final $Res Function(JournalEntriesListError) _then;

/// Create a copy of JournalEntriesListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(JournalEntriesListError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class JournalEntriesListAccessDenied implements JournalEntriesListState {
  const JournalEntriesListAccessDenied();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntriesListAccessDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'JournalEntriesListState.accessDenied()';
}


}




// dart format on
