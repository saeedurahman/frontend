import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_of_account_model.freezed.dart';
part 'chart_of_account_model.g.dart';

@freezed
class ChartOfAccountModel with _$ChartOfAccountModel {
  const factory ChartOfAccountModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'account_code') required String accountCode,
    @JsonKey(name: 'account_name') required String accountName,
    @JsonKey(name: 'account_type') required String accountType,
    @JsonKey(name: 'account_subtype') String? accountSubtype,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    String? description,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'deleted_at') String? deletedAt,
    @Default([]) List<ChartOfAccountModel> children,
  }) = _ChartOfAccountModel;

  factory ChartOfAccountModel.fromJson(Map<String, dynamic> json) =>
      _$ChartOfAccountModelFromJson(json);
}

/// Backend account_type values.
abstract final class AccountType {
  static const asset = 'asset';
  static const liability = 'liability';
  static const equity = 'equity';
  static const income = 'income';
  static const expense = 'expense';

  static const all = [asset, liability, equity, income, expense];
}

/// Backend account_subtype values.
abstract final class AccountSubtype {
  static const cash = 'cash';
  static const bank = 'bank';
  static const accountsReceivable = 'accounts_receivable';
  static const accountsPayable = 'accounts_payable';
  static const inventory = 'inventory';
  static const cogs = 'cogs';
  static const salesRevenue = 'sales_revenue';
  static const taxPayable = 'tax_payable';
  static const other = 'other';

  static const all = [
    cash,
    bank,
    accountsReceivable,
    accountsPayable,
    inventory,
    cogs,
    salesRevenue,
    taxPayable,
    other,
  ];
}
