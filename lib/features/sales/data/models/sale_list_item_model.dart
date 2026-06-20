import 'package:frantend/core/utils/api_json_utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sale_list_item_model.freezed.dart';
part 'sale_list_item_model.g.dart';

@freezed
class SaleListItemModel with _$SaleListItemModel {
  const factory SaleListItemModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'sale_number') required String saleNumber,
    @JsonKey(name: 'sale_type') required String saleType,
    required String status,
    @JsonKey(name: 'sold_at') required String soldAt,
    @JsonKey(name: 'total_amount') String? totalAmount,
    @JsonKey(name: 'total_paid') String? totalPaid,
    @JsonKey(name: 'balance_due') String? balanceDue,
    @JsonKey(name: 'customer_name') String? customerName,
    @JsonKey(name: 'cashier_name') String? cashierName,
    @JsonKey(name: 'item_count') int? itemCount,
    @JsonKey(name: 'payment_methods') @Default([]) List<String> paymentMethods,
  }) = _SaleListItemModel;

  factory SaleListItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleListItemModelFromJson(_normalizeJson(json));

  static Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    for (final key in ['total_amount', 'total_paid', 'balance_due']) {
      if (normalized[key] != null) {
        normalized[key] = ApiJsonUtils.stringValue(normalized[key]);
      }
    }
    return normalized;
  }
}
