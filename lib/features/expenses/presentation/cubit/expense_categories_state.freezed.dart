// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseCategoriesState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoriesState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseCategoriesState()';
}


}

/// @nodoc
class $ExpenseCategoriesStateCopyWith<$Res>  {
$ExpenseCategoriesStateCopyWith(ExpenseCategoriesState _, $Res Function(ExpenseCategoriesState) __);
}


/// Adds pattern-matching-related methods to [ExpenseCategoriesState].
extension ExpenseCategoriesStatePatterns on ExpenseCategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ExpenseCategoriesInitial value)?  initial,TResult Function( ExpenseCategoriesLoading value)?  loading,TResult Function( ExpenseCategoriesLoaded value)?  loaded,TResult Function( ExpenseCategoriesError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ExpenseCategoriesInitial() when initial != null:
return initial(_that);case ExpenseCategoriesLoading() when loading != null:
return loading(_that);case ExpenseCategoriesLoaded() when loaded != null:
return loaded(_that);case ExpenseCategoriesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ExpenseCategoriesInitial value)  initial,required TResult Function( ExpenseCategoriesLoading value)  loading,required TResult Function( ExpenseCategoriesLoaded value)  loaded,required TResult Function( ExpenseCategoriesError value)  error,}){
final _that = this;
switch (_that) {
case ExpenseCategoriesInitial():
return initial(_that);case ExpenseCategoriesLoading():
return loading(_that);case ExpenseCategoriesLoaded():
return loaded(_that);case ExpenseCategoriesError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ExpenseCategoriesInitial value)?  initial,TResult? Function( ExpenseCategoriesLoading value)?  loading,TResult? Function( ExpenseCategoriesLoaded value)?  loaded,TResult? Function( ExpenseCategoriesError value)?  error,}){
final _that = this;
switch (_that) {
case ExpenseCategoriesInitial() when initial != null:
return initial(_that);case ExpenseCategoriesLoading() when loading != null:
return loading(_that);case ExpenseCategoriesLoaded() when loaded != null:
return loaded(_that);case ExpenseCategoriesError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ExpenseCategoryModel> categories)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ExpenseCategoriesInitial() when initial != null:
return initial();case ExpenseCategoriesLoading() when loading != null:
return loading();case ExpenseCategoriesLoaded() when loaded != null:
return loaded(_that.categories);case ExpenseCategoriesError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ExpenseCategoryModel> categories)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ExpenseCategoriesInitial():
return initial();case ExpenseCategoriesLoading():
return loading();case ExpenseCategoriesLoaded():
return loaded(_that.categories);case ExpenseCategoriesError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ExpenseCategoryModel> categories)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ExpenseCategoriesInitial() when initial != null:
return initial();case ExpenseCategoriesLoading() when loading != null:
return loading();case ExpenseCategoriesLoaded() when loaded != null:
return loaded(_that.categories);case ExpenseCategoriesError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ExpenseCategoriesInitial implements ExpenseCategoriesState {
  const ExpenseCategoriesInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoriesInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseCategoriesState.initial()';
}


}




/// @nodoc


class ExpenseCategoriesLoading implements ExpenseCategoriesState {
  const ExpenseCategoriesLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoriesLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ExpenseCategoriesState.loading()';
}


}




/// @nodoc


class ExpenseCategoriesLoaded implements ExpenseCategoriesState {
  const ExpenseCategoriesLoaded({required  List<ExpenseCategoryModel> categories}): _categories = categories;
  

 final  List<ExpenseCategoryModel> _categories;
 List<ExpenseCategoryModel> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of ExpenseCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCategoriesLoadedCopyWith<ExpenseCategoriesLoaded> get copyWith => _$ExpenseCategoriesLoadedCopyWithImpl<ExpenseCategoriesLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoriesLoaded&&const DeepCollectionEquality().equals(other.categories, _categories));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'ExpenseCategoriesState.loaded(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $ExpenseCategoriesLoadedCopyWith<$Res> implements $ExpenseCategoriesStateCopyWith<$Res> {
  factory $ExpenseCategoriesLoadedCopyWith(ExpenseCategoriesLoaded value, $Res Function(ExpenseCategoriesLoaded) _then) = _$ExpenseCategoriesLoadedCopyWithImpl;
@useResult
$Res call({
 List<ExpenseCategoryModel> categories
});




}
/// @nodoc
class _$ExpenseCategoriesLoadedCopyWithImpl<$Res>
    implements $ExpenseCategoriesLoadedCopyWith<$Res> {
  _$ExpenseCategoriesLoadedCopyWithImpl(this._self, this._then);

  final ExpenseCategoriesLoaded _self;
  final $Res Function(ExpenseCategoriesLoaded) _then;

/// Create a copy of ExpenseCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(ExpenseCategoriesLoaded(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategoryModel>,
  ));
}


}

/// @nodoc


class ExpenseCategoriesError implements ExpenseCategoriesState {
  const ExpenseCategoriesError(this.message);
  

 final  String message;

/// Create a copy of ExpenseCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCategoriesErrorCopyWith<ExpenseCategoriesError> get copyWith => _$ExpenseCategoriesErrorCopyWithImpl<ExpenseCategoriesError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoriesError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'ExpenseCategoriesState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ExpenseCategoriesErrorCopyWith<$Res> implements $ExpenseCategoriesStateCopyWith<$Res> {
  factory $ExpenseCategoriesErrorCopyWith(ExpenseCategoriesError value, $Res Function(ExpenseCategoriesError) _then) = _$ExpenseCategoriesErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ExpenseCategoriesErrorCopyWithImpl<$Res>
    implements $ExpenseCategoriesErrorCopyWith<$Res> {
  _$ExpenseCategoriesErrorCopyWithImpl(this._self, this._then);

  final ExpenseCategoriesError _self;
  final $Res Function(ExpenseCategoriesError) _then;

/// Create a copy of ExpenseCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ExpenseCategoriesError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
