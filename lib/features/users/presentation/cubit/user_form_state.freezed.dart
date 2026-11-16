// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserFormState {

 String get mode; String? get userId; String get fullName; String get phone; String get password; String? get branchId; bool get isActive; String get originalFullName; String? get originalBranchId; bool get originalIsActive; List<String> get selectedRoleIds; List<String> get originalRoleIds; List<RoleModel> get availableRoles; List<BranchModel> get branches; bool get canUpdateProfile; bool get canEditRoles; bool get canDelete; bool get isLoading; bool get isSaving; bool get isDeleting; bool get isTogglingActive; bool get isResettingPin; String? get saveWarning; Map<String, String> get errors;
/// Create a copy of UserFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFormStateCopyWith<UserFormState> get copyWith => _$UserFormStateCopyWithImpl<UserFormState>(this as UserFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.branchId, _this.branchId) || other.branchId == _this.branchId)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.originalFullName, _this.originalFullName) || other.originalFullName == _this.originalFullName)&&(identical(other.originalBranchId, _this.originalBranchId) || other.originalBranchId == _this.originalBranchId)&&(identical(other.originalIsActive, _this.originalIsActive) || other.originalIsActive == _this.originalIsActive)&&const DeepCollectionEquality().equals(other.selectedRoleIds, _this.selectedRoleIds)&&const DeepCollectionEquality().equals(other.originalRoleIds, _this.originalRoleIds)&&const DeepCollectionEquality().equals(other.availableRoles, _this.availableRoles)&&const DeepCollectionEquality().equals(other.branches, _this.branches)&&(identical(other.canUpdateProfile, _this.canUpdateProfile) || other.canUpdateProfile == _this.canUpdateProfile)&&(identical(other.canEditRoles, _this.canEditRoles) || other.canEditRoles == _this.canEditRoles)&&(identical(other.canDelete, _this.canDelete) || other.canDelete == _this.canDelete)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.isDeleting, _this.isDeleting) || other.isDeleting == _this.isDeleting)&&(identical(other.isTogglingActive, _this.isTogglingActive) || other.isTogglingActive == _this.isTogglingActive)&&(identical(other.isResettingPin, _this.isResettingPin) || other.isResettingPin == _this.isResettingPin)&&(identical(other.saveWarning, _this.saveWarning) || other.saveWarning == _this.saveWarning)&&const DeepCollectionEquality().equals(other.errors, _this.errors));
}


@override
int get hashCode {
  final _this = this as UserFormState;
  return Object.hashAll([runtimeType,_this.mode,_this.userId,_this.fullName,_this.phone,_this.password,_this.branchId,_this.isActive,_this.originalFullName,_this.originalBranchId,_this.originalIsActive,const DeepCollectionEquality().hash(_this.selectedRoleIds),const DeepCollectionEquality().hash(_this.originalRoleIds),const DeepCollectionEquality().hash(_this.availableRoles),const DeepCollectionEquality().hash(_this.branches),_this.canUpdateProfile,_this.canEditRoles,_this.canDelete,_this.isLoading,_this.isSaving,_this.isDeleting,_this.isTogglingActive,_this.isResettingPin,_this.saveWarning,const DeepCollectionEquality().hash(_this.errors)]);
}

@override
String toString() {
  final _this = this as UserFormState;
  return 'UserFormState(mode: ${_this.mode}, userId: ${_this.userId}, fullName: ${_this.fullName}, phone: ${_this.phone}, password: ${_this.password}, branchId: ${_this.branchId}, isActive: ${_this.isActive}, originalFullName: ${_this.originalFullName}, originalBranchId: ${_this.originalBranchId}, originalIsActive: ${_this.originalIsActive}, selectedRoleIds: ${_this.selectedRoleIds}, originalRoleIds: ${_this.originalRoleIds}, availableRoles: ${_this.availableRoles}, branches: ${_this.branches}, canUpdateProfile: ${_this.canUpdateProfile}, canEditRoles: ${_this.canEditRoles}, canDelete: ${_this.canDelete}, isLoading: ${_this.isLoading}, isSaving: ${_this.isSaving}, isDeleting: ${_this.isDeleting}, isTogglingActive: ${_this.isTogglingActive}, isResettingPin: ${_this.isResettingPin}, saveWarning: ${_this.saveWarning}, errors: ${_this.errors})';
}


}

/// @nodoc
abstract mixin class $UserFormStateCopyWith<$Res>  {
  factory $UserFormStateCopyWith(UserFormState value, $Res Function(UserFormState) _then) = _$UserFormStateCopyWithImpl;
@useResult
$Res call({
 String mode, String? userId, String fullName, String phone, String password, String? branchId, bool isActive, String originalFullName, String? originalBranchId, bool originalIsActive, List<String> selectedRoleIds, List<String> originalRoleIds, List<RoleModel> availableRoles, List<BranchModel> branches, bool canUpdateProfile, bool canEditRoles, bool canDelete, bool isLoading, bool isSaving, bool isDeleting, bool isTogglingActive, bool isResettingPin, String? saveWarning, Map<String, String> errors
});




}
/// @nodoc
class _$UserFormStateCopyWithImpl<$Res>
    implements $UserFormStateCopyWith<$Res> {
  _$UserFormStateCopyWithImpl(this._self, this._then);

  final UserFormState _self;
  final $Res Function(UserFormState) _then;

/// Create a copy of UserFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? userId = freezed,Object? fullName = null,Object? phone = null,Object? password = null,Object? branchId = freezed,Object? isActive = null,Object? originalFullName = null,Object? originalBranchId = freezed,Object? originalIsActive = null,Object? selectedRoleIds = null,Object? originalRoleIds = null,Object? availableRoles = null,Object? branches = null,Object? canUpdateProfile = null,Object? canEditRoles = null,Object? canDelete = null,Object? isLoading = null,Object? isSaving = null,Object? isDeleting = null,Object? isTogglingActive = null,Object? isResettingPin = null,Object? saveWarning = freezed,Object? errors = null,}) {
  return _then(UserFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,originalFullName: null == originalFullName ? _self.originalFullName : originalFullName // ignore: cast_nullable_to_non_nullable
as String,originalBranchId: freezed == originalBranchId ? _self.originalBranchId : originalBranchId // ignore: cast_nullable_to_non_nullable
as String?,originalIsActive: null == originalIsActive ? _self.originalIsActive : originalIsActive // ignore: cast_nullable_to_non_nullable
as bool,selectedRoleIds: null == selectedRoleIds ? _self.selectedRoleIds : selectedRoleIds // ignore: cast_nullable_to_non_nullable
as List<String>,originalRoleIds: null == originalRoleIds ? _self.originalRoleIds : originalRoleIds // ignore: cast_nullable_to_non_nullable
as List<String>,availableRoles: null == availableRoles ? _self.availableRoles : availableRoles // ignore: cast_nullable_to_non_nullable
as List<RoleModel>,branches: null == branches ? _self.branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchModel>,canUpdateProfile: null == canUpdateProfile ? _self.canUpdateProfile : canUpdateProfile // ignore: cast_nullable_to_non_nullable
as bool,canEditRoles: null == canEditRoles ? _self.canEditRoles : canEditRoles // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isTogglingActive: null == isTogglingActive ? _self.isTogglingActive : isTogglingActive // ignore: cast_nullable_to_non_nullable
as bool,isResettingPin: null == isResettingPin ? _self.isResettingPin : isResettingPin // ignore: cast_nullable_to_non_nullable
as bool,saveWarning: freezed == saveWarning ? _self.saveWarning : saveWarning // ignore: cast_nullable_to_non_nullable
as String?,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFormState].
extension UserFormStatePatterns on UserFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFormState value)  $default,){
final _that = this;
switch (_that) {
case _UserFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFormState value)?  $default,){
final _that = this;
switch (_that) {
case _UserFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  String? userId,  String fullName,  String phone,  String password,  String? branchId,  bool isActive,  String originalFullName,  String? originalBranchId,  bool originalIsActive,  List<String> selectedRoleIds,  List<String> originalRoleIds,  List<RoleModel> availableRoles,  List<BranchModel> branches,  bool canUpdateProfile,  bool canEditRoles,  bool canDelete,  bool isLoading,  bool isSaving,  bool isDeleting,  bool isTogglingActive,  bool isResettingPin,  String? saveWarning,  Map<String, String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFormState() when $default != null:
return $default(_that.mode,_that.userId,_that.fullName,_that.phone,_that.password,_that.branchId,_that.isActive,_that.originalFullName,_that.originalBranchId,_that.originalIsActive,_that.selectedRoleIds,_that.originalRoleIds,_that.availableRoles,_that.branches,_that.canUpdateProfile,_that.canEditRoles,_that.canDelete,_that.isLoading,_that.isSaving,_that.isDeleting,_that.isTogglingActive,_that.isResettingPin,_that.saveWarning,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  String? userId,  String fullName,  String phone,  String password,  String? branchId,  bool isActive,  String originalFullName,  String? originalBranchId,  bool originalIsActive,  List<String> selectedRoleIds,  List<String> originalRoleIds,  List<RoleModel> availableRoles,  List<BranchModel> branches,  bool canUpdateProfile,  bool canEditRoles,  bool canDelete,  bool isLoading,  bool isSaving,  bool isDeleting,  bool isTogglingActive,  bool isResettingPin,  String? saveWarning,  Map<String, String> errors)  $default,) {final _that = this;
switch (_that) {
case _UserFormState():
return $default(_that.mode,_that.userId,_that.fullName,_that.phone,_that.password,_that.branchId,_that.isActive,_that.originalFullName,_that.originalBranchId,_that.originalIsActive,_that.selectedRoleIds,_that.originalRoleIds,_that.availableRoles,_that.branches,_that.canUpdateProfile,_that.canEditRoles,_that.canDelete,_that.isLoading,_that.isSaving,_that.isDeleting,_that.isTogglingActive,_that.isResettingPin,_that.saveWarning,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  String? userId,  String fullName,  String phone,  String password,  String? branchId,  bool isActive,  String originalFullName,  String? originalBranchId,  bool originalIsActive,  List<String> selectedRoleIds,  List<String> originalRoleIds,  List<RoleModel> availableRoles,  List<BranchModel> branches,  bool canUpdateProfile,  bool canEditRoles,  bool canDelete,  bool isLoading,  bool isSaving,  bool isDeleting,  bool isTogglingActive,  bool isResettingPin,  String? saveWarning,  Map<String, String> errors)?  $default,) {final _that = this;
switch (_that) {
case _UserFormState() when $default != null:
return $default(_that.mode,_that.userId,_that.fullName,_that.phone,_that.password,_that.branchId,_that.isActive,_that.originalFullName,_that.originalBranchId,_that.originalIsActive,_that.selectedRoleIds,_that.originalRoleIds,_that.availableRoles,_that.branches,_that.canUpdateProfile,_that.canEditRoles,_that.canDelete,_that.isLoading,_that.isSaving,_that.isDeleting,_that.isTogglingActive,_that.isResettingPin,_that.saveWarning,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _UserFormState extends UserFormState {
  const _UserFormState({this.mode = 'create', this.userId, this.fullName = '', this.phone = '', this.password = '', this.branchId, this.isActive = true, this.originalFullName = '', this.originalBranchId, this.originalIsActive = true,  List<String> selectedRoleIds = const [],  List<String> originalRoleIds = const [],  List<RoleModel> availableRoles = const [],  List<BranchModel> branches = const [], this.canUpdateProfile = false, this.canEditRoles = false, this.canDelete = false, this.isLoading = false, this.isSaving = false, this.isDeleting = false, this.isTogglingActive = false, this.isResettingPin = false, this.saveWarning,  Map<String, String> errors = const {}}): _selectedRoleIds = selectedRoleIds,_originalRoleIds = originalRoleIds,_availableRoles = availableRoles,_branches = branches,_errors = errors,super._();
  

@override@JsonKey() final  String mode;
@override final  String? userId;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String password;
@override final  String? branchId;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  String originalFullName;
@override final  String? originalBranchId;
@override@JsonKey() final  bool originalIsActive;
 final  List<String> _selectedRoleIds;
@override@JsonKey() List<String> get selectedRoleIds {
  if (_selectedRoleIds is EqualUnmodifiableListView) return _selectedRoleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedRoleIds);
}

 final  List<String> _originalRoleIds;
@override@JsonKey() List<String> get originalRoleIds {
  if (_originalRoleIds is EqualUnmodifiableListView) return _originalRoleIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_originalRoleIds);
}

 final  List<RoleModel> _availableRoles;
@override@JsonKey() List<RoleModel> get availableRoles {
  if (_availableRoles is EqualUnmodifiableListView) return _availableRoles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableRoles);
}

 final  List<BranchModel> _branches;
@override@JsonKey() List<BranchModel> get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}

@override@JsonKey() final  bool canUpdateProfile;
@override@JsonKey() final  bool canEditRoles;
@override@JsonKey() final  bool canDelete;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool isDeleting;
@override@JsonKey() final  bool isTogglingActive;
@override@JsonKey() final  bool isResettingPin;
@override final  String? saveWarning;
 final  Map<String, String> _errors;
@override@JsonKey() Map<String, String> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}


/// Create a copy of UserFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFormStateCopyWith<_UserFormState> get copyWith => __$UserFormStateCopyWithImpl<_UserFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.password, password) || other.password == password)&&(identical(other.branchId, branchId) || other.branchId == branchId)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.originalFullName, originalFullName) || other.originalFullName == originalFullName)&&(identical(other.originalBranchId, originalBranchId) || other.originalBranchId == originalBranchId)&&(identical(other.originalIsActive, originalIsActive) || other.originalIsActive == originalIsActive)&&const DeepCollectionEquality().equals(other.selectedRoleIds, _selectedRoleIds)&&const DeepCollectionEquality().equals(other.originalRoleIds, _originalRoleIds)&&const DeepCollectionEquality().equals(other.availableRoles, _availableRoles)&&const DeepCollectionEquality().equals(other.branches, _branches)&&(identical(other.canUpdateProfile, canUpdateProfile) || other.canUpdateProfile == canUpdateProfile)&&(identical(other.canEditRoles, canEditRoles) || other.canEditRoles == canEditRoles)&&(identical(other.canDelete, canDelete) || other.canDelete == canDelete)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.isDeleting, isDeleting) || other.isDeleting == isDeleting)&&(identical(other.isTogglingActive, isTogglingActive) || other.isTogglingActive == isTogglingActive)&&(identical(other.isResettingPin, isResettingPin) || other.isResettingPin == isResettingPin)&&(identical(other.saveWarning, saveWarning) || other.saveWarning == saveWarning)&&const DeepCollectionEquality().equals(other.errors, _errors));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,mode,userId,fullName,phone,password,branchId,isActive,originalFullName,originalBranchId,originalIsActive,const DeepCollectionEquality().hash(_selectedRoleIds),const DeepCollectionEquality().hash(_originalRoleIds),const DeepCollectionEquality().hash(_availableRoles),const DeepCollectionEquality().hash(_branches),canUpdateProfile,canEditRoles,canDelete,isLoading,isSaving,isDeleting,isTogglingActive,isResettingPin,saveWarning,const DeepCollectionEquality().hash(_errors)]);
}

@override
String toString() {
    return 'UserFormState(mode: $mode, userId: $userId, fullName: $fullName, phone: $phone, password: $password, branchId: $branchId, isActive: $isActive, originalFullName: $originalFullName, originalBranchId: $originalBranchId, originalIsActive: $originalIsActive, selectedRoleIds: $selectedRoleIds, originalRoleIds: $originalRoleIds, availableRoles: $availableRoles, branches: $branches, canUpdateProfile: $canUpdateProfile, canEditRoles: $canEditRoles, canDelete: $canDelete, isLoading: $isLoading, isSaving: $isSaving, isDeleting: $isDeleting, isTogglingActive: $isTogglingActive, isResettingPin: $isResettingPin, saveWarning: $saveWarning, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$UserFormStateCopyWith<$Res> implements $UserFormStateCopyWith<$Res> {
  factory _$UserFormStateCopyWith(_UserFormState value, $Res Function(_UserFormState) _then) = __$UserFormStateCopyWithImpl;
@override @useResult
$Res call({
 String mode, String? userId, String fullName, String phone, String password, String? branchId, bool isActive, String originalFullName, String? originalBranchId, bool originalIsActive, List<String> selectedRoleIds, List<String> originalRoleIds, List<RoleModel> availableRoles, List<BranchModel> branches, bool canUpdateProfile, bool canEditRoles, bool canDelete, bool isLoading, bool isSaving, bool isDeleting, bool isTogglingActive, bool isResettingPin, String? saveWarning, Map<String, String> errors
});




}
/// @nodoc
class __$UserFormStateCopyWithImpl<$Res>
    implements _$UserFormStateCopyWith<$Res> {
  __$UserFormStateCopyWithImpl(this._self, this._then);

  final _UserFormState _self;
  final $Res Function(_UserFormState) _then;

/// Create a copy of UserFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? userId = freezed,Object? fullName = null,Object? phone = null,Object? password = null,Object? branchId = freezed,Object? isActive = null,Object? originalFullName = null,Object? originalBranchId = freezed,Object? originalIsActive = null,Object? selectedRoleIds = null,Object? originalRoleIds = null,Object? availableRoles = null,Object? branches = null,Object? canUpdateProfile = null,Object? canEditRoles = null,Object? canDelete = null,Object? isLoading = null,Object? isSaving = null,Object? isDeleting = null,Object? isTogglingActive = null,Object? isResettingPin = null,Object? saveWarning = freezed,Object? errors = null,}) {
  return _then(_UserFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,branchId: freezed == branchId ? _self.branchId : branchId // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,originalFullName: null == originalFullName ? _self.originalFullName : originalFullName // ignore: cast_nullable_to_non_nullable
as String,originalBranchId: freezed == originalBranchId ? _self.originalBranchId : originalBranchId // ignore: cast_nullable_to_non_nullable
as String?,originalIsActive: null == originalIsActive ? _self.originalIsActive : originalIsActive // ignore: cast_nullable_to_non_nullable
as bool,selectedRoleIds: null == selectedRoleIds ? _self._selectedRoleIds : selectedRoleIds // ignore: cast_nullable_to_non_nullable
as List<String>,originalRoleIds: null == originalRoleIds ? _self._originalRoleIds : originalRoleIds // ignore: cast_nullable_to_non_nullable
as List<String>,availableRoles: null == availableRoles ? _self._availableRoles : availableRoles // ignore: cast_nullable_to_non_nullable
as List<RoleModel>,branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as List<BranchModel>,canUpdateProfile: null == canUpdateProfile ? _self.canUpdateProfile : canUpdateProfile // ignore: cast_nullable_to_non_nullable
as bool,canEditRoles: null == canEditRoles ? _self.canEditRoles : canEditRoles // ignore: cast_nullable_to_non_nullable
as bool,canDelete: null == canDelete ? _self.canDelete : canDelete // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,isDeleting: null == isDeleting ? _self.isDeleting : isDeleting // ignore: cast_nullable_to_non_nullable
as bool,isTogglingActive: null == isTogglingActive ? _self.isTogglingActive : isTogglingActive // ignore: cast_nullable_to_non_nullable
as bool,isResettingPin: null == isResettingPin ? _self.isResettingPin : isResettingPin // ignore: cast_nullable_to_non_nullable
as bool,saveWarning: freezed == saveWarning ? _self.saveWarning : saveWarning // ignore: cast_nullable_to_non_nullable
as String?,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
