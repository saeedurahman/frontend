// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_picker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CustomerPickerState {
  String get searchQuery => throw _privateConstructorUsedError;
  List<CustomerModel> get results => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  bool get isCreating => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  bool get showCreateForm => throw _privateConstructorUsedError;

  /// Create a copy of CustomerPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerPickerStateCopyWith<CustomerPickerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerPickerStateCopyWith<$Res> {
  factory $CustomerPickerStateCopyWith(
    CustomerPickerState value,
    $Res Function(CustomerPickerState) then,
  ) = _$CustomerPickerStateCopyWithImpl<$Res, CustomerPickerState>;
  @useResult
  $Res call({
    String searchQuery,
    List<CustomerModel> results,
    bool isSearching,
    bool isCreating,
    String? error,
    bool showCreateForm,
  });
}

/// @nodoc
class _$CustomerPickerStateCopyWithImpl<$Res, $Val extends CustomerPickerState>
    implements $CustomerPickerStateCopyWith<$Res> {
  _$CustomerPickerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? results = null,
    Object? isSearching = null,
    Object? isCreating = null,
    Object? error = freezed,
    Object? showCreateForm = null,
  }) {
    return _then(
      _value.copyWith(
            searchQuery: null == searchQuery
                ? _value.searchQuery
                : searchQuery // ignore: cast_nullable_to_non_nullable
                      as String,
            results: null == results
                ? _value.results
                : results // ignore: cast_nullable_to_non_nullable
                      as List<CustomerModel>,
            isSearching: null == isSearching
                ? _value.isSearching
                : isSearching // ignore: cast_nullable_to_non_nullable
                      as bool,
            isCreating: null == isCreating
                ? _value.isCreating
                : isCreating // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            showCreateForm: null == showCreateForm
                ? _value.showCreateForm
                : showCreateForm // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerPickerStateImplCopyWith<$Res>
    implements $CustomerPickerStateCopyWith<$Res> {
  factory _$$CustomerPickerStateImplCopyWith(
    _$CustomerPickerStateImpl value,
    $Res Function(_$CustomerPickerStateImpl) then,
  ) = __$$CustomerPickerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String searchQuery,
    List<CustomerModel> results,
    bool isSearching,
    bool isCreating,
    String? error,
    bool showCreateForm,
  });
}

/// @nodoc
class __$$CustomerPickerStateImplCopyWithImpl<$Res>
    extends _$CustomerPickerStateCopyWithImpl<$Res, _$CustomerPickerStateImpl>
    implements _$$CustomerPickerStateImplCopyWith<$Res> {
  __$$CustomerPickerStateImplCopyWithImpl(
    _$CustomerPickerStateImpl _value,
    $Res Function(_$CustomerPickerStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerPickerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? results = null,
    Object? isSearching = null,
    Object? isCreating = null,
    Object? error = freezed,
    Object? showCreateForm = null,
  }) {
    return _then(
      _$CustomerPickerStateImpl(
        searchQuery: null == searchQuery
            ? _value.searchQuery
            : searchQuery // ignore: cast_nullable_to_non_nullable
                  as String,
        results: null == results
            ? _value._results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<CustomerModel>,
        isSearching: null == isSearching
            ? _value.isSearching
            : isSearching // ignore: cast_nullable_to_non_nullable
                  as bool,
        isCreating: null == isCreating
            ? _value.isCreating
            : isCreating // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        showCreateForm: null == showCreateForm
            ? _value.showCreateForm
            : showCreateForm // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$CustomerPickerStateImpl implements _CustomerPickerState {
  const _$CustomerPickerStateImpl({
    this.searchQuery = '',
    final List<CustomerModel> results = const [],
    this.isSearching = false,
    this.isCreating = false,
    this.error,
    this.showCreateForm = false,
  }) : _results = results;

  @override
  @JsonKey()
  final String searchQuery;
  final List<CustomerModel> _results;
  @override
  @JsonKey()
  List<CustomerModel> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  @JsonKey()
  final bool isSearching;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  final String? error;
  @override
  @JsonKey()
  final bool showCreateForm;

  @override
  String toString() {
    return 'CustomerPickerState(searchQuery: $searchQuery, results: $results, isSearching: $isSearching, isCreating: $isCreating, error: $error, showCreateForm: $showCreateForm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerPickerStateImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(other._results, _results) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.showCreateForm, showCreateForm) ||
                other.showCreateForm == showCreateForm));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    searchQuery,
    const DeepCollectionEquality().hash(_results),
    isSearching,
    isCreating,
    error,
    showCreateForm,
  );

  /// Create a copy of CustomerPickerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerPickerStateImplCopyWith<_$CustomerPickerStateImpl> get copyWith =>
      __$$CustomerPickerStateImplCopyWithImpl<_$CustomerPickerStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CustomerPickerState implements CustomerPickerState {
  const factory _CustomerPickerState({
    final String searchQuery,
    final List<CustomerModel> results,
    final bool isSearching,
    final bool isCreating,
    final String? error,
    final bool showCreateForm,
  }) = _$CustomerPickerStateImpl;

  @override
  String get searchQuery;
  @override
  List<CustomerModel> get results;
  @override
  bool get isSearching;
  @override
  bool get isCreating;
  @override
  String? get error;
  @override
  bool get showCreateForm;

  /// Create a copy of CustomerPickerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerPickerStateImplCopyWith<_$CustomerPickerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
