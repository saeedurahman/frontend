// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'users_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UsersListState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersListStateCopyWith<$Res> {
  factory $UsersListStateCopyWith(
    UsersListState value,
    $Res Function(UsersListState) then,
  ) = _$UsersListStateCopyWithImpl<$Res, UsersListState>;
}

/// @nodoc
class _$UsersListStateCopyWithImpl<$Res, $Val extends UsersListState>
    implements $UsersListStateCopyWith<$Res> {
  _$UsersListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$UsersListInitialImplCopyWith<$Res> {
  factory _$$UsersListInitialImplCopyWith(
    _$UsersListInitialImpl value,
    $Res Function(_$UsersListInitialImpl) then,
  ) = __$$UsersListInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UsersListInitialImplCopyWithImpl<$Res>
    extends _$UsersListStateCopyWithImpl<$Res, _$UsersListInitialImpl>
    implements _$$UsersListInitialImplCopyWith<$Res> {
  __$$UsersListInitialImplCopyWithImpl(
    _$UsersListInitialImpl _value,
    $Res Function(_$UsersListInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UsersListInitialImpl implements UsersListInitial {
  const _$UsersListInitialImpl();

  @override
  String toString() {
    return 'UsersListState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UsersListInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
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
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class UsersListInitial implements UsersListState {
  const factory UsersListInitial() = _$UsersListInitialImpl;
}

/// @nodoc
abstract class _$$UsersListLoadingImplCopyWith<$Res> {
  factory _$$UsersListLoadingImplCopyWith(
    _$UsersListLoadingImpl value,
    $Res Function(_$UsersListLoadingImpl) then,
  ) = __$$UsersListLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UsersListLoadingImplCopyWithImpl<$Res>
    extends _$UsersListStateCopyWithImpl<$Res, _$UsersListLoadingImpl>
    implements _$$UsersListLoadingImplCopyWith<$Res> {
  __$$UsersListLoadingImplCopyWithImpl(
    _$UsersListLoadingImpl _value,
    $Res Function(_$UsersListLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UsersListLoadingImpl implements UsersListLoading {
  const _$UsersListLoadingImpl();

  @override
  String toString() {
    return 'UsersListState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UsersListLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
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
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class UsersListLoading implements UsersListState {
  const factory UsersListLoading() = _$UsersListLoadingImpl;
}

/// @nodoc
abstract class _$$UsersListLoadedImplCopyWith<$Res> {
  factory _$$UsersListLoadedImplCopyWith(
    _$UsersListLoadedImpl value,
    $Res Function(_$UsersListLoadedImpl) then,
  ) = __$$UsersListLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<StaffUserModel> users, String? roleFilter});
}

/// @nodoc
class __$$UsersListLoadedImplCopyWithImpl<$Res>
    extends _$UsersListStateCopyWithImpl<$Res, _$UsersListLoadedImpl>
    implements _$$UsersListLoadedImplCopyWith<$Res> {
  __$$UsersListLoadedImplCopyWithImpl(
    _$UsersListLoadedImpl _value,
    $Res Function(_$UsersListLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? users = null, Object? roleFilter = freezed}) {
    return _then(
      _$UsersListLoadedImpl(
        users: null == users
            ? _value._users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<StaffUserModel>,
        roleFilter: freezed == roleFilter
            ? _value.roleFilter
            : roleFilter // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$UsersListLoadedImpl implements UsersListLoaded {
  const _$UsersListLoadedImpl({
    required final List<StaffUserModel> users,
    this.roleFilter,
  }) : _users = users;

  final List<StaffUserModel> _users;
  @override
  List<StaffUserModel> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  final String? roleFilter;

  @override
  String toString() {
    return 'UsersListState.loaded(users: $users, roleFilter: $roleFilter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersListLoadedImpl &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            (identical(other.roleFilter, roleFilter) ||
                other.roleFilter == roleFilter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_users),
    roleFilter,
  );

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersListLoadedImplCopyWith<_$UsersListLoadedImpl> get copyWith =>
      __$$UsersListLoadedImplCopyWithImpl<_$UsersListLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) {
    return loaded(users, roleFilter);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(users, roleFilter);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(users, roleFilter);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class UsersListLoaded implements UsersListState {
  const factory UsersListLoaded({
    required final List<StaffUserModel> users,
    final String? roleFilter,
  }) = _$UsersListLoadedImpl;

  List<StaffUserModel> get users;
  String? get roleFilter;

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersListLoadedImplCopyWith<_$UsersListLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UsersListAccessDeniedImplCopyWith<$Res> {
  factory _$$UsersListAccessDeniedImplCopyWith(
    _$UsersListAccessDeniedImpl value,
    $Res Function(_$UsersListAccessDeniedImpl) then,
  ) = __$$UsersListAccessDeniedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UsersListAccessDeniedImplCopyWithImpl<$Res>
    extends _$UsersListStateCopyWithImpl<$Res, _$UsersListAccessDeniedImpl>
    implements _$$UsersListAccessDeniedImplCopyWith<$Res> {
  __$$UsersListAccessDeniedImplCopyWithImpl(
    _$UsersListAccessDeniedImpl _value,
    $Res Function(_$UsersListAccessDeniedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$UsersListAccessDeniedImpl implements UsersListAccessDenied {
  const _$UsersListAccessDeniedImpl();

  @override
  String toString() {
    return 'UsersListState.accessDenied()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersListAccessDeniedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) {
    return accessDenied();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) {
    return accessDenied?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (accessDenied != null) {
      return accessDenied();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) {
    return accessDenied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) {
    return accessDenied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) {
    if (accessDenied != null) {
      return accessDenied(this);
    }
    return orElse();
  }
}

abstract class UsersListAccessDenied implements UsersListState {
  const factory UsersListAccessDenied() = _$UsersListAccessDeniedImpl;
}

/// @nodoc
abstract class _$$UsersListErrorImplCopyWith<$Res> {
  factory _$$UsersListErrorImplCopyWith(
    _$UsersListErrorImpl value,
    $Res Function(_$UsersListErrorImpl) then,
  ) = __$$UsersListErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UsersListErrorImplCopyWithImpl<$Res>
    extends _$UsersListStateCopyWithImpl<$Res, _$UsersListErrorImpl>
    implements _$$UsersListErrorImplCopyWith<$Res> {
  __$$UsersListErrorImplCopyWithImpl(
    _$UsersListErrorImpl _value,
    $Res Function(_$UsersListErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UsersListErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UsersListErrorImpl implements UsersListError {
  const _$UsersListErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'UsersListState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersListErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersListErrorImplCopyWith<_$UsersListErrorImpl> get copyWith =>
      __$$UsersListErrorImplCopyWithImpl<_$UsersListErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StaffUserModel> users, String? roleFilter)
    loaded,
    required TResult Function() accessDenied,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult? Function()? accessDenied,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StaffUserModel> users, String? roleFilter)? loaded,
    TResult Function()? accessDenied,
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
    required TResult Function(UsersListInitial value) initial,
    required TResult Function(UsersListLoading value) loading,
    required TResult Function(UsersListLoaded value) loaded,
    required TResult Function(UsersListAccessDenied value) accessDenied,
    required TResult Function(UsersListError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(UsersListInitial value)? initial,
    TResult? Function(UsersListLoading value)? loading,
    TResult? Function(UsersListLoaded value)? loaded,
    TResult? Function(UsersListAccessDenied value)? accessDenied,
    TResult? Function(UsersListError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(UsersListInitial value)? initial,
    TResult Function(UsersListLoading value)? loading,
    TResult Function(UsersListLoaded value)? loaded,
    TResult Function(UsersListAccessDenied value)? accessDenied,
    TResult Function(UsersListError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class UsersListError implements UsersListState {
  const factory UsersListError(final String message) = _$UsersListErrorImpl;

  String get message;

  /// Create a copy of UsersListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsersListErrorImplCopyWith<_$UsersListErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
