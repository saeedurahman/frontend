// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'units_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UnitsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UnitModel> units) loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UnitModel> units)? loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UnitModel> units)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnitsInitial value) initial,
    required TResult Function(UnitsLoading value) loading,
    required TResult Function(UnitsLoaded value) loaded,
    required TResult Function(UnitsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnitsInitial value)? initial,
    TResult? Function(UnitsLoading value)? loading,
    TResult? Function(UnitsLoaded value)? loaded,
    TResult? Function(UnitsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnitsInitial value)? initial,
    TResult Function(UnitsLoading value)? loading,
    TResult Function(UnitsLoaded value)? loaded,
    TResult Function(UnitsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UnitsStateCopyWith<$Res> {
  factory $UnitsStateCopyWith(
    UnitsState value,
    $Res Function(UnitsState) then,
  ) = _$UnitsStateCopyWithImpl<$Res, UnitsState>;
}

/// @nodoc
class _$UnitsStateCopyWithImpl<$Res, $Val extends UnitsState>
    implements $UnitsStateCopyWith<$Res> {
  _$UnitsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UnitsInitialImplCopyWith<$Res> {
  factory _$$UnitsInitialImplCopyWith(
    _$UnitsInitialImpl value,
    $Res Function(_$UnitsInitialImpl) then,
  ) = __$$UnitsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnitsInitialImplCopyWithImpl<$Res>
    extends _$UnitsStateCopyWithImpl<$Res, _$UnitsInitialImpl>
    implements _$$UnitsInitialImplCopyWith<$Res> {
  __$$UnitsInitialImplCopyWithImpl(
    _$UnitsInitialImpl _value,
    $Res Function(_$UnitsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnitsInitialImpl implements UnitsInitial {
  const _$UnitsInitialImpl();

  @override
  String toString() {
    return 'UnitsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnitsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UnitModel> units) loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UnitModel> units)? loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UnitModel> units)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnitsInitial value) initial,
    required TResult Function(UnitsLoading value) loading,
    required TResult Function(UnitsLoaded value) loaded,
    required TResult Function(UnitsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnitsInitial value)? initial,
    TResult? Function(UnitsLoading value)? loading,
    TResult? Function(UnitsLoaded value)? loaded,
    TResult? Function(UnitsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnitsInitial value)? initial,
    TResult Function(UnitsLoading value)? loading,
    TResult Function(UnitsLoaded value)? loaded,
    TResult Function(UnitsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class UnitsInitial implements UnitsState {
  const factory UnitsInitial() = _$UnitsInitialImpl;
}

/// @nodoc
abstract class _$$UnitsLoadingImplCopyWith<$Res> {
  factory _$$UnitsLoadingImplCopyWith(
    _$UnitsLoadingImpl value,
    $Res Function(_$UnitsLoadingImpl) then,
  ) = __$$UnitsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UnitsLoadingImplCopyWithImpl<$Res>
    extends _$UnitsStateCopyWithImpl<$Res, _$UnitsLoadingImpl>
    implements _$$UnitsLoadingImplCopyWith<$Res> {
  __$$UnitsLoadingImplCopyWithImpl(
    _$UnitsLoadingImpl _value,
    $Res Function(_$UnitsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UnitsLoadingImpl implements UnitsLoading {
  const _$UnitsLoadingImpl();

  @override
  String toString() {
    return 'UnitsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UnitsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UnitModel> units) loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UnitModel> units)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UnitModel> units)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnitsInitial value) initial,
    required TResult Function(UnitsLoading value) loading,
    required TResult Function(UnitsLoaded value) loaded,
    required TResult Function(UnitsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnitsInitial value)? initial,
    TResult? Function(UnitsLoading value)? loading,
    TResult? Function(UnitsLoaded value)? loaded,
    TResult? Function(UnitsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnitsInitial value)? initial,
    TResult Function(UnitsLoading value)? loading,
    TResult Function(UnitsLoaded value)? loaded,
    TResult Function(UnitsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class UnitsLoading implements UnitsState {
  const factory UnitsLoading() = _$UnitsLoadingImpl;
}

/// @nodoc
abstract class _$$UnitsLoadedImplCopyWith<$Res> {
  factory _$$UnitsLoadedImplCopyWith(
    _$UnitsLoadedImpl value,
    $Res Function(_$UnitsLoadedImpl) then,
  ) = __$$UnitsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<UnitModel> units});
}

/// @nodoc
class __$$UnitsLoadedImplCopyWithImpl<$Res>
    extends _$UnitsStateCopyWithImpl<$Res, _$UnitsLoadedImpl>
    implements _$$UnitsLoadedImplCopyWith<$Res> {
  __$$UnitsLoadedImplCopyWithImpl(
    _$UnitsLoadedImpl _value,
    $Res Function(_$UnitsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? units = null}) {
    return _then(
      _$UnitsLoadedImpl(
        null == units
            ? _value._units
            : units // ignore: cast_nullable_to_non_nullable
                  as List<UnitModel>,
      ),
    );
  }
}

/// @nodoc

class _$UnitsLoadedImpl implements UnitsLoaded {
  const _$UnitsLoadedImpl(final List<UnitModel> units) : _units = units;

  final List<UnitModel> _units;
  @override
  List<UnitModel> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  @override
  String toString() {
    return 'UnitsState.loaded(units: $units)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitsLoadedImpl &&
            const DeepCollectionEquality().equals(other._units, _units));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_units));

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitsLoadedImplCopyWith<_$UnitsLoadedImpl> get copyWith =>
      __$$UnitsLoadedImplCopyWithImpl<_$UnitsLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UnitModel> units) loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(units);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UnitModel> units)? loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(units);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UnitModel> units)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(units);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnitsInitial value) initial,
    required TResult Function(UnitsLoading value) loading,
    required TResult Function(UnitsLoaded value) loaded,
    required TResult Function(UnitsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnitsInitial value)? initial,
    TResult? Function(UnitsLoading value)? loading,
    TResult? Function(UnitsLoaded value)? loaded,
    TResult? Function(UnitsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnitsInitial value)? initial,
    TResult Function(UnitsLoading value)? loading,
    TResult Function(UnitsLoaded value)? loaded,
    TResult Function(UnitsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class UnitsLoaded implements UnitsState {
  const factory UnitsLoaded(final List<UnitModel> units) = _$UnitsLoadedImpl;

  List<UnitModel> get units;

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitsLoadedImplCopyWith<_$UnitsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnitsErrorImplCopyWith<$Res> {
  factory _$$UnitsErrorImplCopyWith(
    _$UnitsErrorImpl value,
    $Res Function(_$UnitsErrorImpl) then,
  ) = __$$UnitsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnitsErrorImplCopyWithImpl<$Res>
    extends _$UnitsStateCopyWithImpl<$Res, _$UnitsErrorImpl>
    implements _$$UnitsErrorImplCopyWith<$Res> {
  __$$UnitsErrorImplCopyWithImpl(
    _$UnitsErrorImpl _value,
    $Res Function(_$UnitsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnitsErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnitsErrorImpl implements UnitsError {
  const _$UnitsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UnitsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnitsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnitsErrorImplCopyWith<_$UnitsErrorImpl> get copyWith =>
      __$$UnitsErrorImplCopyWithImpl<_$UnitsErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<UnitModel> units) loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<UnitModel> units)? loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<UnitModel> units)? loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UnitsInitial value) initial,
    required TResult Function(UnitsLoading value) loading,
    required TResult Function(UnitsLoaded value) loaded,
    required TResult Function(UnitsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UnitsInitial value)? initial,
    TResult? Function(UnitsLoading value)? loading,
    TResult? Function(UnitsLoaded value)? loaded,
    TResult? Function(UnitsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UnitsInitial value)? initial,
    TResult Function(UnitsLoading value)? loading,
    TResult Function(UnitsLoaded value)? loaded,
    TResult Function(UnitsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UnitsError implements UnitsState {
  const factory UnitsError(final String message) = _$UnitsErrorImpl;

  String get message;

  /// Create a copy of UnitsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnitsErrorImplCopyWith<_$UnitsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
