// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_register_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CashRegisterModelImpl _$$CashRegisterModelImplFromJson(
  Map<String, dynamic> json,
) => _$CashRegisterModelImpl(
  id: json['id'] as String,
  branchId: json['branch_id'] as String,
  name: json['name'] as String,
  isActive: json['is_active'] as bool? ?? true,
  deviceIdentifier: json['device_identifier'] as String?,
);

Map<String, dynamic> _$$CashRegisterModelImplToJson(
  _$CashRegisterModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch_id': instance.branchId,
  'name': instance.name,
  'is_active': instance.isActive,
  'device_identifier': instance.deviceIdentifier,
};
