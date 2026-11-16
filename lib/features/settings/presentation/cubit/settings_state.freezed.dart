// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsState()';
}


}

/// @nodoc
class $SettingsStateCopyWith<$Res>  {
$SettingsStateCopyWith(SettingsState _, $Res Function(SettingsState) __);
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsInitial value)?  initial,TResult Function( SettingsLoading value)?  loading,TResult Function( SettingsLoaded value)?  loaded,TResult Function( SettingsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial(_that);case SettingsLoading() when loading != null:
return loading(_that);case SettingsLoaded() when loaded != null:
return loaded(_that);case SettingsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsInitial value)  initial,required TResult Function( SettingsLoading value)  loading,required TResult Function( SettingsLoaded value)  loaded,required TResult Function( SettingsError value)  error,}){
final _that = this;
switch (_that) {
case SettingsInitial():
return initial(_that);case SettingsLoading():
return loading(_that);case SettingsLoaded():
return loaded(_that);case SettingsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsInitial value)?  initial,TResult? Function( SettingsLoading value)?  loading,TResult? Function( SettingsLoaded value)?  loaded,TResult? Function( SettingsError value)?  error,}){
final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial(_that);case SettingsLoading() when loading != null:
return loading(_that);case SettingsLoaded() when loaded != null:
return loaded(_that);case SettingsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( BusinessProfileModel business,  List<AppSettingModel> businessSettings,  List<TaxRateModel> taxRates,  String footerText,  String paperSize,  bool showTaxOnReceipt,  bool showLogoOnReceipt,  String? branchOverrideId,  String? branchOverrideFooter,  bool branchFooterIsOverride,  bool isUploadingLogo,  bool isSavingBusiness,  bool isSavingReceipt,  bool isSavingBranchOverride,  bool isSavingTaxRate,  String? defaultTaxRateId,  bool isSavingDefaultTaxRate,  String? errorMessage)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial();case SettingsLoading() when loading != null:
return loading();case SettingsLoaded() when loaded != null:
return loaded(_that.business,_that.businessSettings,_that.taxRates,_that.footerText,_that.paperSize,_that.showTaxOnReceipt,_that.showLogoOnReceipt,_that.branchOverrideId,_that.branchOverrideFooter,_that.branchFooterIsOverride,_that.isUploadingLogo,_that.isSavingBusiness,_that.isSavingReceipt,_that.isSavingBranchOverride,_that.isSavingTaxRate,_that.defaultTaxRateId,_that.isSavingDefaultTaxRate,_that.errorMessage);case SettingsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( BusinessProfileModel business,  List<AppSettingModel> businessSettings,  List<TaxRateModel> taxRates,  String footerText,  String paperSize,  bool showTaxOnReceipt,  bool showLogoOnReceipt,  String? branchOverrideId,  String? branchOverrideFooter,  bool branchFooterIsOverride,  bool isUploadingLogo,  bool isSavingBusiness,  bool isSavingReceipt,  bool isSavingBranchOverride,  bool isSavingTaxRate,  String? defaultTaxRateId,  bool isSavingDefaultTaxRate,  String? errorMessage)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SettingsInitial():
return initial();case SettingsLoading():
return loading();case SettingsLoaded():
return loaded(_that.business,_that.businessSettings,_that.taxRates,_that.footerText,_that.paperSize,_that.showTaxOnReceipt,_that.showLogoOnReceipt,_that.branchOverrideId,_that.branchOverrideFooter,_that.branchFooterIsOverride,_that.isUploadingLogo,_that.isSavingBusiness,_that.isSavingReceipt,_that.isSavingBranchOverride,_that.isSavingTaxRate,_that.defaultTaxRateId,_that.isSavingDefaultTaxRate,_that.errorMessage);case SettingsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( BusinessProfileModel business,  List<AppSettingModel> businessSettings,  List<TaxRateModel> taxRates,  String footerText,  String paperSize,  bool showTaxOnReceipt,  bool showLogoOnReceipt,  String? branchOverrideId,  String? branchOverrideFooter,  bool branchFooterIsOverride,  bool isUploadingLogo,  bool isSavingBusiness,  bool isSavingReceipt,  bool isSavingBranchOverride,  bool isSavingTaxRate,  String? defaultTaxRateId,  bool isSavingDefaultTaxRate,  String? errorMessage)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SettingsInitial() when initial != null:
return initial();case SettingsLoading() when loading != null:
return loading();case SettingsLoaded() when loaded != null:
return loaded(_that.business,_that.businessSettings,_that.taxRates,_that.footerText,_that.paperSize,_that.showTaxOnReceipt,_that.showLogoOnReceipt,_that.branchOverrideId,_that.branchOverrideFooter,_that.branchFooterIsOverride,_that.isUploadingLogo,_that.isSavingBusiness,_that.isSavingReceipt,_that.isSavingBranchOverride,_that.isSavingTaxRate,_that.defaultTaxRateId,_that.isSavingDefaultTaxRate,_that.errorMessage);case SettingsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SettingsInitial implements SettingsState {
  const SettingsInitial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsState.initial()';
}


}




/// @nodoc


class SettingsLoading implements SettingsState {
  const SettingsLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SettingsState.loading()';
}


}




/// @nodoc


class SettingsLoaded implements SettingsState {
  const SettingsLoaded({required this.business, required  List<AppSettingModel> businessSettings, required  List<TaxRateModel> taxRates, required this.footerText, required this.paperSize, this.showTaxOnReceipt = true, this.showLogoOnReceipt = true, this.branchOverrideId, this.branchOverrideFooter, this.branchFooterIsOverride = false, this.isUploadingLogo = false, this.isSavingBusiness = false, this.isSavingReceipt = false, this.isSavingBranchOverride = false, this.isSavingTaxRate = false, this.defaultTaxRateId, this.isSavingDefaultTaxRate = false, this.errorMessage}): _businessSettings = businessSettings,_taxRates = taxRates;
  

 final  BusinessProfileModel business;
 final  List<AppSettingModel> _businessSettings;
 List<AppSettingModel> get businessSettings {
  if (_businessSettings is EqualUnmodifiableListView) return _businessSettings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_businessSettings);
}

 final  List<TaxRateModel> _taxRates;
 List<TaxRateModel> get taxRates {
  if (_taxRates is EqualUnmodifiableListView) return _taxRates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_taxRates);
}

 final  String footerText;
 final  String paperSize;
@JsonKey() final  bool showTaxOnReceipt;
@JsonKey() final  bool showLogoOnReceipt;
 final  String? branchOverrideId;
 final  String? branchOverrideFooter;
@JsonKey() final  bool branchFooterIsOverride;
@JsonKey() final  bool isUploadingLogo;
@JsonKey() final  bool isSavingBusiness;
@JsonKey() final  bool isSavingReceipt;
@JsonKey() final  bool isSavingBranchOverride;
@JsonKey() final  bool isSavingTaxRate;
 final  String? defaultTaxRateId;
@JsonKey() final  bool isSavingDefaultTaxRate;
 final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsLoadedCopyWith<SettingsLoaded> get copyWith => _$SettingsLoadedCopyWithImpl<SettingsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsLoaded&&(identical(other.business, business) || other.business == business)&&const DeepCollectionEquality().equals(other.businessSettings, _businessSettings)&&const DeepCollectionEquality().equals(other.taxRates, _taxRates)&&(identical(other.footerText, footerText) || other.footerText == footerText)&&(identical(other.paperSize, paperSize) || other.paperSize == paperSize)&&(identical(other.showTaxOnReceipt, showTaxOnReceipt) || other.showTaxOnReceipt == showTaxOnReceipt)&&(identical(other.showLogoOnReceipt, showLogoOnReceipt) || other.showLogoOnReceipt == showLogoOnReceipt)&&(identical(other.branchOverrideId, branchOverrideId) || other.branchOverrideId == branchOverrideId)&&(identical(other.branchOverrideFooter, branchOverrideFooter) || other.branchOverrideFooter == branchOverrideFooter)&&(identical(other.branchFooterIsOverride, branchFooterIsOverride) || other.branchFooterIsOverride == branchFooterIsOverride)&&(identical(other.isUploadingLogo, isUploadingLogo) || other.isUploadingLogo == isUploadingLogo)&&(identical(other.isSavingBusiness, isSavingBusiness) || other.isSavingBusiness == isSavingBusiness)&&(identical(other.isSavingReceipt, isSavingReceipt) || other.isSavingReceipt == isSavingReceipt)&&(identical(other.isSavingBranchOverride, isSavingBranchOverride) || other.isSavingBranchOverride == isSavingBranchOverride)&&(identical(other.isSavingTaxRate, isSavingTaxRate) || other.isSavingTaxRate == isSavingTaxRate)&&(identical(other.defaultTaxRateId, defaultTaxRateId) || other.defaultTaxRateId == defaultTaxRateId)&&(identical(other.isSavingDefaultTaxRate, isSavingDefaultTaxRate) || other.isSavingDefaultTaxRate == isSavingDefaultTaxRate)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,business,const DeepCollectionEquality().hash(_businessSettings),const DeepCollectionEquality().hash(_taxRates),footerText,paperSize,showTaxOnReceipt,showLogoOnReceipt,branchOverrideId,branchOverrideFooter,branchFooterIsOverride,isUploadingLogo,isSavingBusiness,isSavingReceipt,isSavingBranchOverride,isSavingTaxRate,defaultTaxRateId,isSavingDefaultTaxRate,errorMessage);
}

@override
String toString() {
    return 'SettingsState.loaded(business: $business, businessSettings: $businessSettings, taxRates: $taxRates, footerText: $footerText, paperSize: $paperSize, showTaxOnReceipt: $showTaxOnReceipt, showLogoOnReceipt: $showLogoOnReceipt, branchOverrideId: $branchOverrideId, branchOverrideFooter: $branchOverrideFooter, branchFooterIsOverride: $branchFooterIsOverride, isUploadingLogo: $isUploadingLogo, isSavingBusiness: $isSavingBusiness, isSavingReceipt: $isSavingReceipt, isSavingBranchOverride: $isSavingBranchOverride, isSavingTaxRate: $isSavingTaxRate, defaultTaxRateId: $defaultTaxRateId, isSavingDefaultTaxRate: $isSavingDefaultTaxRate, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsLoadedCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsLoadedCopyWith(SettingsLoaded value, $Res Function(SettingsLoaded) _then) = _$SettingsLoadedCopyWithImpl;
@useResult
$Res call({
 BusinessProfileModel business, List<AppSettingModel> businessSettings, List<TaxRateModel> taxRates, String footerText, String paperSize, bool showTaxOnReceipt, bool showLogoOnReceipt, String? branchOverrideId, String? branchOverrideFooter, bool branchFooterIsOverride, bool isUploadingLogo, bool isSavingBusiness, bool isSavingReceipt, bool isSavingBranchOverride, bool isSavingTaxRate, String? defaultTaxRateId, bool isSavingDefaultTaxRate, String? errorMessage
});


$BusinessProfileModelCopyWith<$Res> get business;

}
/// @nodoc
class _$SettingsLoadedCopyWithImpl<$Res>
    implements $SettingsLoadedCopyWith<$Res> {
  _$SettingsLoadedCopyWithImpl(this._self, this._then);

  final SettingsLoaded _self;
  final $Res Function(SettingsLoaded) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? business = null,Object? businessSettings = null,Object? taxRates = null,Object? footerText = null,Object? paperSize = null,Object? showTaxOnReceipt = null,Object? showLogoOnReceipt = null,Object? branchOverrideId = freezed,Object? branchOverrideFooter = freezed,Object? branchFooterIsOverride = null,Object? isUploadingLogo = null,Object? isSavingBusiness = null,Object? isSavingReceipt = null,Object? isSavingBranchOverride = null,Object? isSavingTaxRate = null,Object? defaultTaxRateId = freezed,Object? isSavingDefaultTaxRate = null,Object? errorMessage = freezed,}) {
  return _then(SettingsLoaded(
business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as BusinessProfileModel,businessSettings: null == businessSettings ? _self._businessSettings : businessSettings // ignore: cast_nullable_to_non_nullable
as List<AppSettingModel>,taxRates: null == taxRates ? _self._taxRates : taxRates // ignore: cast_nullable_to_non_nullable
as List<TaxRateModel>,footerText: null == footerText ? _self.footerText : footerText // ignore: cast_nullable_to_non_nullable
as String,paperSize: null == paperSize ? _self.paperSize : paperSize // ignore: cast_nullable_to_non_nullable
as String,showTaxOnReceipt: null == showTaxOnReceipt ? _self.showTaxOnReceipt : showTaxOnReceipt // ignore: cast_nullable_to_non_nullable
as bool,showLogoOnReceipt: null == showLogoOnReceipt ? _self.showLogoOnReceipt : showLogoOnReceipt // ignore: cast_nullable_to_non_nullable
as bool,branchOverrideId: freezed == branchOverrideId ? _self.branchOverrideId : branchOverrideId // ignore: cast_nullable_to_non_nullable
as String?,branchOverrideFooter: freezed == branchOverrideFooter ? _self.branchOverrideFooter : branchOverrideFooter // ignore: cast_nullable_to_non_nullable
as String?,branchFooterIsOverride: null == branchFooterIsOverride ? _self.branchFooterIsOverride : branchFooterIsOverride // ignore: cast_nullable_to_non_nullable
as bool,isUploadingLogo: null == isUploadingLogo ? _self.isUploadingLogo : isUploadingLogo // ignore: cast_nullable_to_non_nullable
as bool,isSavingBusiness: null == isSavingBusiness ? _self.isSavingBusiness : isSavingBusiness // ignore: cast_nullable_to_non_nullable
as bool,isSavingReceipt: null == isSavingReceipt ? _self.isSavingReceipt : isSavingReceipt // ignore: cast_nullable_to_non_nullable
as bool,isSavingBranchOverride: null == isSavingBranchOverride ? _self.isSavingBranchOverride : isSavingBranchOverride // ignore: cast_nullable_to_non_nullable
as bool,isSavingTaxRate: null == isSavingTaxRate ? _self.isSavingTaxRate : isSavingTaxRate // ignore: cast_nullable_to_non_nullable
as bool,defaultTaxRateId: freezed == defaultTaxRateId ? _self.defaultTaxRateId : defaultTaxRateId // ignore: cast_nullable_to_non_nullable
as String?,isSavingDefaultTaxRate: null == isSavingDefaultTaxRate ? _self.isSavingDefaultTaxRate : isSavingDefaultTaxRate // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BusinessProfileModelCopyWith<$Res> get business {
  
  return $BusinessProfileModelCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}
}

/// @nodoc


class SettingsError implements SettingsState {
  const SettingsError(this.message);
  

 final  String message;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsErrorCopyWith<SettingsError> get copyWith => _$SettingsErrorCopyWithImpl<SettingsError>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'SettingsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SettingsErrorCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory $SettingsErrorCopyWith(SettingsError value, $Res Function(SettingsError) _then) = _$SettingsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SettingsErrorCopyWithImpl<$Res>
    implements $SettingsErrorCopyWith<$Res> {
  _$SettingsErrorCopyWithImpl(this._self, this._then);

  final SettingsError _self;
  final $Res Function(SettingsError) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SettingsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
