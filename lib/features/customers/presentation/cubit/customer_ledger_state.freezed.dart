// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_ledger_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LedgerDisplayRow {

 CustomerLedgerEntryModel get entry; String get runningBalance;
/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LedgerDisplayRowCopyWith<LedgerDisplayRow> get copyWith => _$LedgerDisplayRowCopyWithImpl<LedgerDisplayRow>(this as LedgerDisplayRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LedgerDisplayRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LedgerDisplayRow&&(identical(other.entry, _this.entry) || other.entry == _this.entry)&&(identical(other.runningBalance, _this.runningBalance) || other.runningBalance == _this.runningBalance));
}


@override
int get hashCode {
  final _this = this as LedgerDisplayRow;
  return Object.hash(runtimeType,_this.entry,_this.runningBalance);
}

@override
String toString() {
  final _this = this as LedgerDisplayRow;
  return 'LedgerDisplayRow(entry: ${_this.entry}, runningBalance: ${_this.runningBalance})';
}


}

/// @nodoc
abstract mixin class $LedgerDisplayRowCopyWith<$Res>  {
  factory $LedgerDisplayRowCopyWith(LedgerDisplayRow value, $Res Function(LedgerDisplayRow) _then) = _$LedgerDisplayRowCopyWithImpl;
@useResult
$Res call({
 CustomerLedgerEntryModel entry, String runningBalance
});


$CustomerLedgerEntryModelCopyWith<$Res> get entry;

}
/// @nodoc
class _$LedgerDisplayRowCopyWithImpl<$Res>
    implements $LedgerDisplayRowCopyWith<$Res> {
  _$LedgerDisplayRowCopyWithImpl(this._self, this._then);

  final LedgerDisplayRow _self;
  final $Res Function(LedgerDisplayRow) _then;

/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entry = null,Object? runningBalance = null,}) {
  return _then(LedgerDisplayRow(
entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as CustomerLedgerEntryModel,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerLedgerEntryModelCopyWith<$Res> get entry {
  
  return $CustomerLedgerEntryModelCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// Adds pattern-matching-related methods to [LedgerDisplayRow].
extension LedgerDisplayRowPatterns on LedgerDisplayRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LedgerDisplayRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LedgerDisplayRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LedgerDisplayRow value)  $default,){
final _that = this;
switch (_that) {
case _LedgerDisplayRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LedgerDisplayRow value)?  $default,){
final _that = this;
switch (_that) {
case _LedgerDisplayRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CustomerLedgerEntryModel entry,  String runningBalance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LedgerDisplayRow() when $default != null:
return $default(_that.entry,_that.runningBalance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CustomerLedgerEntryModel entry,  String runningBalance)  $default,) {final _that = this;
switch (_that) {
case _LedgerDisplayRow():
return $default(_that.entry,_that.runningBalance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CustomerLedgerEntryModel entry,  String runningBalance)?  $default,) {final _that = this;
switch (_that) {
case _LedgerDisplayRow() when $default != null:
return $default(_that.entry,_that.runningBalance);case _:
  return null;

}
}

}

/// @nodoc


class _LedgerDisplayRow implements LedgerDisplayRow {
  const _LedgerDisplayRow({required this.entry, required this.runningBalance});
  

@override final  CustomerLedgerEntryModel entry;
@override final  String runningBalance;

/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LedgerDisplayRowCopyWith<_LedgerDisplayRow> get copyWith => __$LedgerDisplayRowCopyWithImpl<_LedgerDisplayRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LedgerDisplayRow&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.runningBalance, runningBalance) || other.runningBalance == runningBalance));
}


@override
int get hashCode {
    return Object.hash(runtimeType,entry,runningBalance);
}

@override
String toString() {
    return 'LedgerDisplayRow(entry: $entry, runningBalance: $runningBalance)';
}


}

/// @nodoc
abstract mixin class _$LedgerDisplayRowCopyWith<$Res> implements $LedgerDisplayRowCopyWith<$Res> {
  factory _$LedgerDisplayRowCopyWith(_LedgerDisplayRow value, $Res Function(_LedgerDisplayRow) _then) = __$LedgerDisplayRowCopyWithImpl;
@override @useResult
$Res call({
 CustomerLedgerEntryModel entry, String runningBalance
});


@override $CustomerLedgerEntryModelCopyWith<$Res> get entry;

}
/// @nodoc
class __$LedgerDisplayRowCopyWithImpl<$Res>
    implements _$LedgerDisplayRowCopyWith<$Res> {
  __$LedgerDisplayRowCopyWithImpl(this._self, this._then);

  final _LedgerDisplayRow _self;
  final $Res Function(_LedgerDisplayRow) _then;

/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entry = null,Object? runningBalance = null,}) {
  return _then(_LedgerDisplayRow(
entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as CustomerLedgerEntryModel,runningBalance: null == runningBalance ? _self.runningBalance : runningBalance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of LedgerDisplayRow
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerLedgerEntryModelCopyWith<$Res> get entry {
  
  return $CustomerLedgerEntryModelCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

/// @nodoc
mixin _$CustomerLedgerState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerLedgerState()';
}


}

/// @nodoc
class $CustomerLedgerStateCopyWith<$Res>  {
$CustomerLedgerStateCopyWith(CustomerLedgerState _, $Res Function(CustomerLedgerState) __);
}


/// Adds pattern-matching-related methods to [CustomerLedgerState].
extension CustomerLedgerStatePatterns on CustomerLedgerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( CustomerLedgerInitial value)?  initial,TResult Function( CustomerLedgerLoading value)?  loading,TResult Function( CustomerLedgerLoaded value)?  loaded,TResult Function( CustomerLedgerError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case CustomerLedgerInitial() when initial != null:
return initial(_that);case CustomerLedgerLoading() when loading != null:
return loading(_that);case CustomerLedgerLoaded() when loaded != null:
return loaded(_that);case CustomerLedgerError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( CustomerLedgerInitial value)  initial,required TResult Function( CustomerLedgerLoading value)  loading,required TResult Function( CustomerLedgerLoaded value)  loaded,required TResult Function( CustomerLedgerError value)  error,}){
final _that = this;
switch (_that) {
case CustomerLedgerInitial():
return initial(_that);case CustomerLedgerLoading():
return loading(_that);case CustomerLedgerLoaded():
return loaded(_that);case CustomerLedgerError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( CustomerLedgerInitial value)?  initial,TResult? Function( CustomerLedgerLoading value)?  loading,TResult? Function( CustomerLedgerLoaded value)?  loaded,TResult? Function( CustomerLedgerError value)?  error,}){
final _that = this;
switch (_that) {
case CustomerLedgerInitial() when initial != null:
return initial(_that);case CustomerLedgerLoading() when loading != null:
return loading(_that);case CustomerLedgerLoaded() when loaded != null:
return loaded(_that);case CustomerLedgerError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( CustomerModel customer,  String balance,  List<LedgerDisplayRow> entries,  bool isLoadingMore,  bool hasMore,  int currentPage,  int pageSize,  bool isRecordingPayment,  String? paymentError,  bool isCheckingPaymentShift,  String? activePaymentShiftId,  bool isOpeningPaymentShift)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case CustomerLedgerInitial() when initial != null:
return initial();case CustomerLedgerLoading() when loading != null:
return loading();case CustomerLedgerLoaded() when loaded != null:
return loaded(_that.customer,_that.balance,_that.entries,_that.isLoadingMore,_that.hasMore,_that.currentPage,_that.pageSize,_that.isRecordingPayment,_that.paymentError,_that.isCheckingPaymentShift,_that.activePaymentShiftId,_that.isOpeningPaymentShift);case CustomerLedgerError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( CustomerModel customer,  String balance,  List<LedgerDisplayRow> entries,  bool isLoadingMore,  bool hasMore,  int currentPage,  int pageSize,  bool isRecordingPayment,  String? paymentError,  bool isCheckingPaymentShift,  String? activePaymentShiftId,  bool isOpeningPaymentShift)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case CustomerLedgerInitial():
return initial();case CustomerLedgerLoading():
return loading();case CustomerLedgerLoaded():
return loaded(_that.customer,_that.balance,_that.entries,_that.isLoadingMore,_that.hasMore,_that.currentPage,_that.pageSize,_that.isRecordingPayment,_that.paymentError,_that.isCheckingPaymentShift,_that.activePaymentShiftId,_that.isOpeningPaymentShift);case CustomerLedgerError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( CustomerModel customer,  String balance,  List<LedgerDisplayRow> entries,  bool isLoadingMore,  bool hasMore,  int currentPage,  int pageSize,  bool isRecordingPayment,  String? paymentError,  bool isCheckingPaymentShift,  String? activePaymentShiftId,  bool isOpeningPaymentShift)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case CustomerLedgerInitial() when initial != null:
return initial();case CustomerLedgerLoading() when loading != null:
return loading();case CustomerLedgerLoaded() when loaded != null:
return loaded(_that.customer,_that.balance,_that.entries,_that.isLoadingMore,_that.hasMore,_that.currentPage,_that.pageSize,_that.isRecordingPayment,_that.paymentError,_that.isCheckingPaymentShift,_that.activePaymentShiftId,_that.isOpeningPaymentShift);case CustomerLedgerError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class CustomerLedgerInitial implements CustomerLedgerState {
  const CustomerLedgerInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerLedgerState.initial()';
}


}




/// @nodoc


class CustomerLedgerLoading implements CustomerLedgerState {
  const CustomerLedgerLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'CustomerLedgerState.loading()';
}


}




/// @nodoc


class CustomerLedgerLoaded implements CustomerLedgerState {
  const CustomerLedgerLoaded({required this.customer, required this.balance, required  List<LedgerDisplayRow> entries, this.isLoadingMore = false, this.hasMore = true, this.currentPage = 1, this.pageSize = 10, this.isRecordingPayment = false, this.paymentError, this.isCheckingPaymentShift = false, this.activePaymentShiftId, this.isOpeningPaymentShift = false}): _entries = entries;
  

 final  CustomerModel customer;
 final  String balance;
 final  List<LedgerDisplayRow> _entries;
 List<LedgerDisplayRow> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}

@JsonKey() final  bool isLoadingMore;
@JsonKey() final  bool hasMore;
@JsonKey() final  int currentPage;
@JsonKey() final  int pageSize;
@JsonKey() final  bool isRecordingPayment;
 final  String? paymentError;
@JsonKey() final  bool isCheckingPaymentShift;
 final  String? activePaymentShiftId;
@JsonKey() final  bool isOpeningPaymentShift;

/// Create a copy of CustomerLedgerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerLedgerLoadedCopyWith<CustomerLedgerLoaded> get copyWith => _$CustomerLedgerLoadedCopyWithImpl<CustomerLedgerLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerLoaded&&(identical(other.customer, customer) || other.customer == customer)&&(identical(other.balance, balance) || other.balance == balance)&&const DeepCollectionEquality().equals(other.entries, _entries)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.isRecordingPayment, isRecordingPayment) || other.isRecordingPayment == isRecordingPayment)&&(identical(other.paymentError, paymentError) || other.paymentError == paymentError)&&(identical(other.isCheckingPaymentShift, isCheckingPaymentShift) || other.isCheckingPaymentShift == isCheckingPaymentShift)&&(identical(other.activePaymentShiftId, activePaymentShiftId) || other.activePaymentShiftId == activePaymentShiftId)&&(identical(other.isOpeningPaymentShift, isOpeningPaymentShift) || other.isOpeningPaymentShift == isOpeningPaymentShift));
}


@override
int get hashCode {
    return Object.hash(runtimeType,customer,balance,const DeepCollectionEquality().hash(_entries),isLoadingMore,hasMore,currentPage,pageSize,isRecordingPayment,paymentError,isCheckingPaymentShift,activePaymentShiftId,isOpeningPaymentShift);
}

@override
String toString() {
    return 'CustomerLedgerState.loaded(customer: $customer, balance: $balance, entries: $entries, isLoadingMore: $isLoadingMore, hasMore: $hasMore, currentPage: $currentPage, pageSize: $pageSize, isRecordingPayment: $isRecordingPayment, paymentError: $paymentError, isCheckingPaymentShift: $isCheckingPaymentShift, activePaymentShiftId: $activePaymentShiftId, isOpeningPaymentShift: $isOpeningPaymentShift)';
}


}

/// @nodoc
abstract mixin class $CustomerLedgerLoadedCopyWith<$Res> implements $CustomerLedgerStateCopyWith<$Res> {
  factory $CustomerLedgerLoadedCopyWith(CustomerLedgerLoaded value, $Res Function(CustomerLedgerLoaded) _then) = _$CustomerLedgerLoadedCopyWithImpl;
@useResult
$Res call({
 CustomerModel customer, String balance, List<LedgerDisplayRow> entries, bool isLoadingMore, bool hasMore, int currentPage, int pageSize, bool isRecordingPayment, String? paymentError, bool isCheckingPaymentShift, String? activePaymentShiftId, bool isOpeningPaymentShift
});


$CustomerModelCopyWith<$Res> get customer;

}
/// @nodoc
class _$CustomerLedgerLoadedCopyWithImpl<$Res>
    implements $CustomerLedgerLoadedCopyWith<$Res> {
  _$CustomerLedgerLoadedCopyWithImpl(this._self, this._then);

  final CustomerLedgerLoaded _self;
  final $Res Function(CustomerLedgerLoaded) _then;

/// Create a copy of CustomerLedgerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? customer = null,Object? balance = null,Object? entries = null,Object? isLoadingMore = null,Object? hasMore = null,Object? currentPage = null,Object? pageSize = null,Object? isRecordingPayment = null,Object? paymentError = freezed,Object? isCheckingPaymentShift = null,Object? activePaymentShiftId = freezed,Object? isOpeningPaymentShift = null,}) {
  return _then(CustomerLedgerLoaded(
customer: null == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as CustomerModel,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<LedgerDisplayRow>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,isRecordingPayment: null == isRecordingPayment ? _self.isRecordingPayment : isRecordingPayment // ignore: cast_nullable_to_non_nullable
as bool,paymentError: freezed == paymentError ? _self.paymentError : paymentError // ignore: cast_nullable_to_non_nullable
as String?,isCheckingPaymentShift: null == isCheckingPaymentShift ? _self.isCheckingPaymentShift : isCheckingPaymentShift // ignore: cast_nullable_to_non_nullable
as bool,activePaymentShiftId: freezed == activePaymentShiftId ? _self.activePaymentShiftId : activePaymentShiftId // ignore: cast_nullable_to_non_nullable
as String?,isOpeningPaymentShift: null == isOpeningPaymentShift ? _self.isOpeningPaymentShift : isOpeningPaymentShift // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CustomerLedgerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomerModelCopyWith<$Res> get customer {
  
  return $CustomerModelCopyWith<$Res>(_self.customer, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}

/// @nodoc


class CustomerLedgerError implements CustomerLedgerState {
  const CustomerLedgerError(this.message);
  

 final  String message;

/// Create a copy of CustomerLedgerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerLedgerErrorCopyWith<CustomerLedgerError> get copyWith => _$CustomerLedgerErrorCopyWithImpl<CustomerLedgerError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerLedgerError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'CustomerLedgerState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CustomerLedgerErrorCopyWith<$Res> implements $CustomerLedgerStateCopyWith<$Res> {
  factory $CustomerLedgerErrorCopyWith(CustomerLedgerError value, $Res Function(CustomerLedgerError) _then) = _$CustomerLedgerErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CustomerLedgerErrorCopyWithImpl<$Res>
    implements $CustomerLedgerErrorCopyWith<$Res> {
  _$CustomerLedgerErrorCopyWithImpl(this._self, this._then);

  final CustomerLedgerError _self;
  final $Res Function(CustomerLedgerError) _then;

/// Create a copy of CustomerLedgerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CustomerLedgerError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
