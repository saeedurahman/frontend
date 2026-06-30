// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tables_floor_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TablesFloorState {
  TablesFloorStatus get status => throw _privateConstructorUsedError;
  FloorLayoutModel? get layout => throw _privateConstructorUsedError;
  String? get selectedFloorPlanId => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;
  bool get accessDenied => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TablesFloorStateCopyWith<TablesFloorState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TablesFloorStateCopyWith<$Res> {
  factory $TablesFloorStateCopyWith(
    TablesFloorState value,
    $Res Function(TablesFloorState) then,
  ) = _$TablesFloorStateCopyWithImpl<$Res, TablesFloorState>;
  @useResult
  $Res call({
    TablesFloorStatus status,
    FloorLayoutModel? layout,
    String? selectedFloorPlanId,
    bool isRefreshing,
    bool accessDenied,
    String? errorMessage,
  });

  $FloorLayoutModelCopyWith<$Res>? get layout;
}

/// @nodoc
class _$TablesFloorStateCopyWithImpl<$Res, $Val extends TablesFloorState>
    implements $TablesFloorStateCopyWith<$Res> {
  _$TablesFloorStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? layout = freezed,
    Object? selectedFloorPlanId = freezed,
    Object? isRefreshing = null,
    Object? accessDenied = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TablesFloorStatus,
            layout: freezed == layout
                ? _value.layout
                : layout // ignore: cast_nullable_to_non_nullable
                      as FloorLayoutModel?,
            selectedFloorPlanId: freezed == selectedFloorPlanId
                ? _value.selectedFloorPlanId
                : selectedFloorPlanId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isRefreshing: null == isRefreshing
                ? _value.isRefreshing
                : isRefreshing // ignore: cast_nullable_to_non_nullable
                      as bool,
            accessDenied: null == accessDenied
                ? _value.accessDenied
                : accessDenied // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FloorLayoutModelCopyWith<$Res>? get layout {
    if (_value.layout == null) {
      return null;
    }

    return $FloorLayoutModelCopyWith<$Res>(_value.layout!, (value) {
      return _then(_value.copyWith(layout: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TablesFloorStateImplCopyWith<$Res>
    implements $TablesFloorStateCopyWith<$Res> {
  factory _$$TablesFloorStateImplCopyWith(
    _$TablesFloorStateImpl value,
    $Res Function(_$TablesFloorStateImpl) then,
  ) = __$$TablesFloorStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TablesFloorStatus status,
    FloorLayoutModel? layout,
    String? selectedFloorPlanId,
    bool isRefreshing,
    bool accessDenied,
    String? errorMessage,
  });

  @override
  $FloorLayoutModelCopyWith<$Res>? get layout;
}

/// @nodoc
class __$$TablesFloorStateImplCopyWithImpl<$Res>
    extends _$TablesFloorStateCopyWithImpl<$Res, _$TablesFloorStateImpl>
    implements _$$TablesFloorStateImplCopyWith<$Res> {
  __$$TablesFloorStateImplCopyWithImpl(
    _$TablesFloorStateImpl _value,
    $Res Function(_$TablesFloorStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? layout = freezed,
    Object? selectedFloorPlanId = freezed,
    Object? isRefreshing = null,
    Object? accessDenied = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$TablesFloorStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TablesFloorStatus,
        layout: freezed == layout
            ? _value.layout
            : layout // ignore: cast_nullable_to_non_nullable
                  as FloorLayoutModel?,
        selectedFloorPlanId: freezed == selectedFloorPlanId
            ? _value.selectedFloorPlanId
            : selectedFloorPlanId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isRefreshing: null == isRefreshing
            ? _value.isRefreshing
            : isRefreshing // ignore: cast_nullable_to_non_nullable
                  as bool,
        accessDenied: null == accessDenied
            ? _value.accessDenied
            : accessDenied // ignore: cast_nullable_to_non_nullable
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

class _$TablesFloorStateImpl extends _TablesFloorState {
  const _$TablesFloorStateImpl({
    this.status = TablesFloorStatus.initial,
    this.layout,
    this.selectedFloorPlanId,
    this.isRefreshing = false,
    this.accessDenied = false,
    this.errorMessage,
  }) : super._();

  @override
  @JsonKey()
  final TablesFloorStatus status;
  @override
  final FloorLayoutModel? layout;
  @override
  final String? selectedFloorPlanId;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool accessDenied;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'TablesFloorState(status: $status, layout: $layout, selectedFloorPlanId: $selectedFloorPlanId, isRefreshing: $isRefreshing, accessDenied: $accessDenied, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TablesFloorStateImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.layout, layout) || other.layout == layout) &&
            (identical(other.selectedFloorPlanId, selectedFloorPlanId) ||
                other.selectedFloorPlanId == selectedFloorPlanId) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.accessDenied, accessDenied) ||
                other.accessDenied == accessDenied) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    layout,
    selectedFloorPlanId,
    isRefreshing,
    accessDenied,
    errorMessage,
  );

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TablesFloorStateImplCopyWith<_$TablesFloorStateImpl> get copyWith =>
      __$$TablesFloorStateImplCopyWithImpl<_$TablesFloorStateImpl>(
        this,
        _$identity,
      );
}

abstract class _TablesFloorState extends TablesFloorState {
  const factory _TablesFloorState({
    final TablesFloorStatus status,
    final FloorLayoutModel? layout,
    final String? selectedFloorPlanId,
    final bool isRefreshing,
    final bool accessDenied,
    final String? errorMessage,
  }) = _$TablesFloorStateImpl;
  const _TablesFloorState._() : super._();

  @override
  TablesFloorStatus get status;
  @override
  FloorLayoutModel? get layout;
  @override
  String? get selectedFloorPlanId;
  @override
  bool get isRefreshing;
  @override
  bool get accessDenied;
  @override
  String? get errorMessage;

  /// Create a copy of TablesFloorState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TablesFloorStateImplCopyWith<_$TablesFloorStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
