// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$NotificationsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )
    loaded,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationsInitial value) initial,
    required TResult Function(NotificationsLoading value) loading,
    required TResult Function(NotificationsLoaded value) loaded,
    required TResult Function(NotificationsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationsInitial value)? initial,
    TResult? Function(NotificationsLoading value)? loading,
    TResult? Function(NotificationsLoaded value)? loaded,
    TResult? Function(NotificationsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationsInitial value)? initial,
    TResult Function(NotificationsLoading value)? loading,
    TResult Function(NotificationsLoaded value)? loaded,
    TResult Function(NotificationsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsStateCopyWith<$Res> {
  factory $NotificationsStateCopyWith(
    NotificationsState value,
    $Res Function(NotificationsState) then,
  ) = _$NotificationsStateCopyWithImpl<$Res, NotificationsState>;
}

/// @nodoc
class _$NotificationsStateCopyWithImpl<$Res, $Val extends NotificationsState>
    implements $NotificationsStateCopyWith<$Res> {
  _$NotificationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$NotificationsInitialImplCopyWith<$Res> {
  factory _$$NotificationsInitialImplCopyWith(
    _$NotificationsInitialImpl value,
    $Res Function(_$NotificationsInitialImpl) then,
  ) = __$$NotificationsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationsInitialImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsInitialImpl>
    implements _$$NotificationsInitialImplCopyWith<$Res> {
  __$$NotificationsInitialImplCopyWithImpl(
    _$NotificationsInitialImpl _value,
    $Res Function(_$NotificationsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotificationsInitialImpl implements NotificationsInitial {
  const _$NotificationsInitialImpl();

  @override
  String toString() {
    return 'NotificationsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
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
    required TResult Function(NotificationsInitial value) initial,
    required TResult Function(NotificationsLoading value) loading,
    required TResult Function(NotificationsLoaded value) loaded,
    required TResult Function(NotificationsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationsInitial value)? initial,
    TResult? Function(NotificationsLoading value)? loading,
    TResult? Function(NotificationsLoaded value)? loaded,
    TResult? Function(NotificationsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationsInitial value)? initial,
    TResult Function(NotificationsLoading value)? loading,
    TResult Function(NotificationsLoaded value)? loaded,
    TResult Function(NotificationsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class NotificationsInitial implements NotificationsState {
  const factory NotificationsInitial() = _$NotificationsInitialImpl;
}

/// @nodoc
abstract class _$$NotificationsLoadingImplCopyWith<$Res> {
  factory _$$NotificationsLoadingImplCopyWith(
    _$NotificationsLoadingImpl value,
    $Res Function(_$NotificationsLoadingImpl) then,
  ) = __$$NotificationsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationsLoadingImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsLoadingImpl>
    implements _$$NotificationsLoadingImplCopyWith<$Res> {
  __$$NotificationsLoadingImplCopyWithImpl(
    _$NotificationsLoadingImpl _value,
    $Res Function(_$NotificationsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$NotificationsLoadingImpl implements NotificationsLoading {
  const _$NotificationsLoadingImpl();

  @override
  String toString() {
    return 'NotificationsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
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
    required TResult Function(NotificationsInitial value) initial,
    required TResult Function(NotificationsLoading value) loading,
    required TResult Function(NotificationsLoaded value) loaded,
    required TResult Function(NotificationsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationsInitial value)? initial,
    TResult? Function(NotificationsLoading value)? loading,
    TResult? Function(NotificationsLoaded value)? loaded,
    TResult? Function(NotificationsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationsInitial value)? initial,
    TResult Function(NotificationsLoading value)? loading,
    TResult Function(NotificationsLoaded value)? loaded,
    TResult Function(NotificationsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class NotificationsLoading implements NotificationsState {
  const factory NotificationsLoading() = _$NotificationsLoadingImpl;
}

/// @nodoc
abstract class _$$NotificationsLoadedImplCopyWith<$Res> {
  factory _$$NotificationsLoadedImplCopyWith(
    _$NotificationsLoadedImpl value,
    $Res Function(_$NotificationsLoadedImpl) then,
  ) = __$$NotificationsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<NotificationModel> notifications,
    int total,
    int skip,
    int limit,
    int unreadCount,
    NotificationFilter filter,
    bool isLoadingMore,
    bool isCheckingAlerts,
    String? errorMessage,
  });
}

/// @nodoc
class __$$NotificationsLoadedImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsLoadedImpl>
    implements _$$NotificationsLoadedImplCopyWith<$Res> {
  __$$NotificationsLoadedImplCopyWithImpl(
    _$NotificationsLoadedImpl _value,
    $Res Function(_$NotificationsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
    Object? total = null,
    Object? skip = null,
    Object? limit = null,
    Object? unreadCount = null,
    Object? filter = null,
    Object? isLoadingMore = null,
    Object? isCheckingAlerts = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$NotificationsLoadedImpl(
        notifications: null == notifications
            ? _value._notifications
            : notifications // ignore: cast_nullable_to_non_nullable
                  as List<NotificationModel>,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        skip: null == skip
            ? _value.skip
            : skip // ignore: cast_nullable_to_non_nullable
                  as int,
        limit: null == limit
            ? _value.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        filter: null == filter
            ? _value.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as NotificationFilter,
        isLoadingMore: null == isLoadingMore
            ? _value.isLoadingMore
            : isLoadingMore // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCheckingAlerts: null == isCheckingAlerts
            ? _value.isCheckingAlerts
            : isCheckingAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$NotificationsLoadedImpl implements NotificationsLoaded {
  const _$NotificationsLoadedImpl({
    required final List<NotificationModel> notifications,
    required this.total,
    required this.skip,
    required this.limit,
    required this.unreadCount,
    this.filter = NotificationFilter.all,
    this.isLoadingMore = false,
    this.isCheckingAlerts = false,
    this.errorMessage,
  }) : _notifications = notifications;

  final List<NotificationModel> _notifications;
  @override
  List<NotificationModel> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  final int total;
  @override
  final int skip;
  @override
  final int limit;
  @override
  final int unreadCount;
  @override
  @JsonKey()
  final NotificationFilter filter;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isCheckingAlerts;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'NotificationsState.loaded(notifications: $notifications, total: $total, skip: $skip, limit: $limit, unreadCount: $unreadCount, filter: $filter, isLoadingMore: $isLoadingMore, isCheckingAlerts: $isCheckingAlerts, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsLoadedImpl &&
            const DeepCollectionEquality().equals(
              other._notifications,
              _notifications,
            ) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.skip, skip) || other.skip == skip) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isCheckingAlerts, isCheckingAlerts) ||
                other.isCheckingAlerts == isCheckingAlerts) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_notifications),
    total,
    skip,
    limit,
    unreadCount,
    filter,
    isLoadingMore,
    isCheckingAlerts,
    errorMessage,
  );

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsLoadedImplCopyWith<_$NotificationsLoadedImpl> get copyWith =>
      __$$NotificationsLoadedImplCopyWithImpl<_$NotificationsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return loaded(
      notifications,
      total,
      skip,
      limit,
      unreadCount,
      filter,
      isLoadingMore,
      isCheckingAlerts,
      errorMessage,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return loaded?.call(
      notifications,
      total,
      skip,
      limit,
      unreadCount,
      filter,
      isLoadingMore,
      isCheckingAlerts,
      errorMessage,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(
        notifications,
        total,
        skip,
        limit,
        unreadCount,
        filter,
        isLoadingMore,
        isCheckingAlerts,
        errorMessage,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NotificationsInitial value) initial,
    required TResult Function(NotificationsLoading value) loading,
    required TResult Function(NotificationsLoaded value) loaded,
    required TResult Function(NotificationsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationsInitial value)? initial,
    TResult? Function(NotificationsLoading value)? loading,
    TResult? Function(NotificationsLoaded value)? loaded,
    TResult? Function(NotificationsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationsInitial value)? initial,
    TResult Function(NotificationsLoading value)? loading,
    TResult Function(NotificationsLoaded value)? loaded,
    TResult Function(NotificationsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class NotificationsLoaded implements NotificationsState {
  const factory NotificationsLoaded({
    required final List<NotificationModel> notifications,
    required final int total,
    required final int skip,
    required final int limit,
    required final int unreadCount,
    final NotificationFilter filter,
    final bool isLoadingMore,
    final bool isCheckingAlerts,
    final String? errorMessage,
  }) = _$NotificationsLoadedImpl;

  List<NotificationModel> get notifications;
  int get total;
  int get skip;
  int get limit;
  int get unreadCount;
  NotificationFilter get filter;
  bool get isLoadingMore;
  bool get isCheckingAlerts;
  String? get errorMessage;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsLoadedImplCopyWith<_$NotificationsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotificationsErrorImplCopyWith<$Res> {
  factory _$$NotificationsErrorImplCopyWith(
    _$NotificationsErrorImpl value,
    $Res Function(_$NotificationsErrorImpl) then,
  ) = __$$NotificationsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotificationsErrorImplCopyWithImpl<$Res>
    extends _$NotificationsStateCopyWithImpl<$Res, _$NotificationsErrorImpl>
    implements _$$NotificationsErrorImplCopyWith<$Res> {
  __$$NotificationsErrorImplCopyWithImpl(
    _$NotificationsErrorImpl _value,
    $Res Function(_$NotificationsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NotificationsErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NotificationsErrorImpl implements NotificationsError {
  const _$NotificationsErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'NotificationsState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsErrorImplCopyWith<_$NotificationsErrorImpl> get copyWith =>
      __$$NotificationsErrorImplCopyWithImpl<_$NotificationsErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )
    loaded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
      List<NotificationModel> notifications,
      int total,
      int skip,
      int limit,
      int unreadCount,
      NotificationFilter filter,
      bool isLoadingMore,
      bool isCheckingAlerts,
      String? errorMessage,
    )?
    loaded,
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
    required TResult Function(NotificationsInitial value) initial,
    required TResult Function(NotificationsLoading value) loading,
    required TResult Function(NotificationsLoaded value) loaded,
    required TResult Function(NotificationsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NotificationsInitial value)? initial,
    TResult? Function(NotificationsLoading value)? loading,
    TResult? Function(NotificationsLoaded value)? loaded,
    TResult? Function(NotificationsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NotificationsInitial value)? initial,
    TResult Function(NotificationsLoading value)? loading,
    TResult Function(NotificationsLoaded value)? loaded,
    TResult Function(NotificationsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class NotificationsError implements NotificationsState {
  const factory NotificationsError(final String message) =
      _$NotificationsErrorImpl;

  String get message;

  /// Create a copy of NotificationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationsErrorImplCopyWith<_$NotificationsErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
