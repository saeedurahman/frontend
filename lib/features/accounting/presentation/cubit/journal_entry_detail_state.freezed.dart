// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEntryDetailState {

 JournalEntryModel? get entry; bool get isLoading; bool get isPosting; bool get isDeleting; bool get canCreate; bool get canPost; String? get loadError;
/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryDetailStateCopyWith<JournalEntryDetailState> get copyWith => _$JournalEntryDetailStateCopyWithImpl<JournalEntryDetailState>(this as JournalEntryDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JournalEntryDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryDetailState&&(identical(other.entry, _this.entry) || other.entry == _this.entry)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isPosting, _this.isPosting) || other.isPosting == _this.isPosting)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.canCreate, _this.canCreate) || other.canCreate == _this.canCreate)&&(identical(other.canPost, _this.canPost) || other.canPost == _this.canPost)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError));
}


@override
int get hashCode {
  final _this = this as JournalEntryDetailState;
  return Object.hash(runtimeType,_this.entry,_this.isLoading,_this.isPosting,_this.isDeleting,_this.canCreate,_this.canPost,_this.loadError);
}

@override
String toString() {
  final _this = this as JournalEntryDetailState;
  return 'JournalEntryDetailState(entry: ${_this.entry}, isLoading: ${_this.isLoading}, isPosting: ${_this.isPosting}, isDeleting: ${_this.isDeleting}, canCreate: ${_this.canCreate}, canPost: ${_this.canPost}, loadError: ${_this.loadError})';
}


}

/// @nodoc
abstract mixin class $JournalEntryDetailStateCopyWith<$Res>  {
  factory $JournalEntryDetailStateCopyWith(JournalEntryDetailState value, $Res Function(JournalEntryDetailState) _then) = _$JournalEntryDetailStateCopyWithImpl;
@useResult
$Res call({
 JournalEntryModel? entry, bool isLoading, bool isPosting, bool isDeleting, bool canCreate, bool canPost, String? loadError
});


$JournalEntryModelCopyWith<$Res>? get entry;

}
/// @nodoc
class _$JournalEntryDetailStateCopyWithImpl<$Res>
    implements $JournalEntryDetailStateCopyWith<$Res> {
  _$JournalEntryDetailStateCopyWithImpl(this._self, this._then);

  final JournalEntryDetailState _self;
  final $Res Function(JournalEntryDetailState) _then;

/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entry = freezed,Object? isLoading = null,Object? isPosting = null,Object? isDeleting = null,Object? canCreate = null,Object? canPost = null,Object? loadError = freezed,}) {
  return _then(JournalEntryDetailState(
entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as JournalEntryModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPosting: null == isPosting ? _self.isPosting : isPosting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryModelCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $JournalEntryModelCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// Adds pattern-matching-related methods to [JournalEntryDetailState].
extension JournalEntryDetailStatePatterns on JournalEntryDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryDetailState value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( JournalEntryModel? entry,  bool isLoading,  bool isPosting,  bool isDeleting,  bool canCreate,  bool canPost,  String? loadError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryDetailState() when $default != null:
return $default(_that.entry,_that.isLoading,_that.isPosting,_that.isDeleting,_that.canCreate,_that.canPost,_that.loadError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( JournalEntryModel? entry,  bool isLoading,  bool isPosting,  bool isDeleting,  bool canCreate,  bool canPost,  String? loadError)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryDetailState():
return $default(_that.entry,_that.isLoading,_that.isPosting,_that.isDeleting,_that.canCreate,_that.canPost,_that.loadError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( JournalEntryModel? entry,  bool isLoading,  bool isPosting,  bool isDeleting,  bool canCreate,  bool canPost,  String? loadError)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryDetailState() when $default != null:
return $default(_that.entry,_that.isLoading,_that.isPosting,_that.isDeleting,_that.canCreate,_that.canPost,_that.loadError);case _:
  return null;

}
}

}

/// @nodoc


class _JournalEntryDetailState implements JournalEntryDetailState {
  const _JournalEntryDetailState({this.entry, this.isLoading = false, this.isPosting = false, this.isDeleting = false, this.canCreate = false, this.canPost = false, this.loadError});
  

@override final  JournalEntryModel? entry;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isPosting;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool canCreate;
@override@JsonKey() final  bool canPost;
@override final  String? loadError;

/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryDetailStateCopyWith<_JournalEntryDetailState> get copyWith => __$JournalEntryDetailStateCopyWithImpl<_JournalEntryDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryDetailState&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPosting, isPosting) || other.isPosting == isPosting)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.canCreate, canCreate) || other.canCreate == canCreate)&&(identical(other.canPost, canPost) || other.canPost == canPost)&&(identical(other.loadError, loadError) || other.loadError == loadError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entry,isLoading,isPosting,isDeleting,canCreate,canPost,loadError);
}

@override
String toString() {
    return 'JournalEntryDetailState(entry: $entry, isLoading: $isLoading, isPosting: $isPosting, isDeleting: $isDeleting, canCreate: $canCreate, canPost: $canPost, loadError: $loadError)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryDetailStateCopyWith<$Res> implements $JournalEntryDetailStateCopyWith<$Res> {
  factory _$JournalEntryDetailStateCopyWith(_JournalEntryDetailState value, $Res Function(_JournalEntryDetailState) _then) = __$JournalEntryDetailStateCopyWithImpl;
@override @useResult
$Res call({
 JournalEntryModel? entry, bool isLoading, bool isPosting, bool isDeleting, bool canCreate, bool canPost, String? loadError
});


@override $JournalEntryModelCopyWith<$Res>? get entry;

}
/// @nodoc
class __$JournalEntryDetailStateCopyWithImpl<$Res>
    implements _$JournalEntryDetailStateCopyWith<$Res> {
  __$JournalEntryDetailStateCopyWithImpl(this._self, this._then);

  final _JournalEntryDetailState _self;
  final $Res Function(_JournalEntryDetailState) _then;

/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entry = freezed,Object? isLoading = null,Object? isPosting = null,Object? isDeleting = null,Object? canCreate = null,Object? canPost = null,Object? loadError = freezed,}) {
  return _then(_JournalEntryDetailState(
entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as JournalEntryModel?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPosting: null == isPosting ? _self.isPosting : isPosting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,canCreate: null == canCreate ? _self.canCreate : canCreate // ignore: cast_nullable_to_non_nullable
as bool,canPost: null == canPost ? _self.canPost : canPost // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of JournalEntryDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JournalEntryModelCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $JournalEntryModelCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

// dart format on
