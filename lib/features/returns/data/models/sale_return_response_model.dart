import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/returns/data/models/sale_return_line_model.dart';
import 'package:frantend/features/returns/data/models/sale_return_payment_model.dart';

part 'sale_return_response_model.freezed.dart';
part 'sale_return_response_model.g.dart';

@freezed
class SaleReturnResponseModel with _$SaleReturnResponseModel {
  const factory SaleReturnResponseModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'sale_id') String? saleId,
    @JsonKey(name: 'customer_id') String? customerId,
    @JsonKey(name: 'return_number') required String returnNumber,
    @JsonKey(name: 'returned_at') String? returnedAt,
    String? reason,
    @Default([]) List<SaleReturnLineModel> lines,
    @Default([]) List<SaleReturnPaymentModel> payments,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _SaleReturnResponseModel;

  factory SaleReturnResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SaleReturnResponseModelFromJson(json);
}
