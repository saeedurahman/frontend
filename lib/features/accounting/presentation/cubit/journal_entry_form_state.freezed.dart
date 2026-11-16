// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journal_entry_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JournalEntryFormState {

 String? get entryId; String get entryDate; String get description; List<JournalLineDraft> get lines; List<ChartOfAccountModel> get accounts; bool get canEdit; bool get isLoading; bool get isSubmitting; bool get isDeleting; Map<String, String> get errors;
/// Create a copy of JournalEntryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JournalEntryFormStateCopyWith<JournalEntryFormState> get copyWith => _$JournalEntryFormStateCopyWithImpl<JournalEntryFormState>(this as JournalEntryFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JournalEntryFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JournalEntryFormState&&(identical(other.entryId, _this.entryId) || other.entryId == _this.entryId)&&(identical(other.entryDate, _this.entryDate) || other.entryDate == _this.entryDate)&&(identical(other.description, _this.description) || other.description == _this.description)&&const DeepCollectionEquality().equals(other.lines, _this.lines)&&const DeepCollectionEquality().equals(other.accounts, _this.accounts)&&(identical(other.canEdit, _this.canEdit) || other.canEdit == _this.canEdit)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as JournalEntryFormState;
  return Object.hash(runtimeType,_this.entryId,_this.entryDate,_this.description,const DeepCollectionEquality().hash(_this.lines),const DeepCollectionEquality().hash(_this.accounts),_this.canEdit,_this.isLoading,_this.isSubmitting,_this.isDeleting,const DeepCollectionEquality().hash(_this.errors));
}

@override
String toString() {
  final _this = this as JournalEntryFormState;
  return 'JournalEntryFormState(entryId: ${_this.entryId}, entryDate: ${_this.entryDate}, description: ${_this.description}, lines: ${_this.lines}, accounts: ${_this.accounts}, canEdit: ${_this.canEdit}, isLoading: ${_this.isLoading}, isSubmitting: ${_this.isSubmitting}, isDeleting: ${_this.isDeleting}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $JournalEntryFormStateCopyWith<$Res>  {
  factory $JournalEntryFormStateCopyWith(JournalEntryFormState value, $Res Function(JournalEntryFormState) _then) = _$JournalEntryFormStateCopyWithImpl;
@useResult
$Res call({
 String? entryId, String entryDate, String description, List<JournalLineDraft> lines, List<ChartOfAccountModel> accounts, bool canEdit, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class _$JournalEntryFormStateCopyWithImpl<$Res>
    implements $JournalEntryFormStateCopyWith<$Res> {
  _$JournalEntryFormStateCopyWithImpl(this._self, this._then);

  final JournalEntryFormState _self;
  final $Res Function(JournalEntryFormState) _then;

/// Create a copy of JournalEntryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = freezed,Object? entryDate = null,Object? description = null,Object? lines = null,Object? accounts = null,Object? canEdit = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(JournalEntryFormState(
entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineDraft>,accounts: null == accounts ? _self.accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [JournalEntryFormState].
extension JournalEntryFormStatePatterns on JournalEntryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JournalEntryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JournalEntryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JournalEntryFormState value)  $default,){
final _that = this;
switch (_that) {
case _JournalEntryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JournalEntryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _JournalEntryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? entryId,  String entryDate,  String description,  List<JournalLineDraft> lines,  List<ChartOfAccountModel> accounts,  bool canEdit,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JournalEntryFormState() when $default != null:
return $default(_that.entryId,_that.entryDate,_that.description,_that.lines,_that.accounts,_that.canEdit,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? entryId,  String entryDate,  String description,  List<JournalLineDraft> lines,  List<ChartOfAccountModel> accounts,  bool canEdit,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _JournalEntryFormState():
return $default(_that.entryId,_that.entryDate,_that.description,_that.lines,_that.accounts,_that.canEdit,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? entryId,  String entryDate,  String description,  List<JournalLineDraft> lines,  List<ChartOfAccountModel> accounts,  bool canEdit,  bool isLoading,  bool isSubmitting,  bool isDeleting,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _JournalEntryFormState() when $default != null:
return $default(_that.entryId,_that.entryDate,_that.description,_that.lines,_that.accounts,_that.canEdit,_that.isLoading,_that.isSubmitting,_that.isDeleting,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _JournalEntryFormState extends JournalEntryFormState {
  const _JournalEntryFormState({this.entryId, this.entryDate = '', this.description = '',  List<JournalLineDraft> lines = const [],  List<ChartOfAccountModel> accounts = const [], this.canEdit = false, this.isLoading = false, this.isSubmitting = false, this.isDeleting = false,  Map<String, String> errors = const {}}): _lines = lines,_accounts = accounts,_errors = errors,super._();
  

@override final  String? entryId;
@override@JsonKey() final  String entryDate;
@override@JsonKey() final  String description;
 final  List<JournalLineDraft> _lines;
@override@JsonKey() List<JournalLineDraft> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}

 final  List<ChartOfAccountModel> _accounts;
@override@JsonKey() List<ChartOfAccountModel> get accounts {
  if (_accounts is EqualUnmodifiableListView) return _accounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_accounts);
}

@override@JsonKey() final  bool canEdit;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isDeleting;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of JournalEntryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JournalEntryFormStateCopyWith<_JournalEntryFormState> get copyWith => __$JournalEntryFormStateCopyWithImpl<_JournalEntryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JournalEntryFormState&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.entryDate, entryDate) || other.entryDate == entryDate)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.lines, _lines)&&const DeepCollectionEquality().equals(other.accounts, _accounts)&&(identical(other.canEdit, canEdit) || other.canEdit == canEdit)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entryId,entryDate,description,const DeepCollectionEquality().hash(_lines),const DeepCollectionEquality().hash(_accounts),canEdit,isLoading,isSubmitting,isDeleting,const DeepCollectionEquality().hash(_errors));
}

@override
String toString() {
    return 'JournalEntryFormState(entryId: $entryId, entryDate: $entryDate, description: $description, lines: $lines, accounts: $accounts, canEdit: $canEdit, isLoading: $isLoading, isSubmitting: $isSubmitting, isDeleting: $isDeleting, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$JournalEntryFormStateCopyWith<$Res> implements $JournalEntryFormStateCopyWith<$Res> {
  factory _$JournalEntryFormStateCopyWith(_JournalEntryFormState value, $Res Function(_JournalEntryFormState) _then) = __$JournalEntryFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? entryId, String entryDate, String description, List<JournalLineDraft> lines, List<ChartOfAccountModel> accounts, bool canEdit, bool isLoading, bool isSubmitting, bool isDeleting, Map<String, String> errors
});




}
/// @nodoc
class __$JournalEntryFormStateCopyWithImpl<$Res>
    implements _$JournalEntryFormStateCopyWith<$Res> {
  __$JournalEntryFormStateCopyWithImpl(this._self, this._then);

  final _JournalEntryFormState _self;
  final $Res Function(_JournalEntryFormState) _then;

/// Create a copy of JournalEntryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = freezed,Object? entryDate = null,Object? description = null,Object? lines = null,Object? accounts = null,Object? canEdit = null,Object? isLoading = null,Object? isSubmitting = null,Object? isDeleting = null,Object? errors = null,}) {
  return _then(_JournalEntryFormState(
entryId: freezed == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String?,entryDate: null == entryDate ? _self.entryDate : entryDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<JournalLineDraft>,accounts: null == accounts ? _self._accounts : accounts // ignore: cast_nullable_to_non_nullable
as List<ChartOfAccountModel>,canEdit: null == canEdit ? _self.canEdit : canEdit // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
