import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/customers/data/models/customer_model.dart';
import 'package:frantend/features/sales/data/models/sale_response_model.dart';

part 'sale_detail_state.freezed.dart';

@freezed
sealed class SaleDetailState with _$SaleDetailState {
  const factory SaleDetailState.initial() = SaleDetailInitial;

  const factory SaleDetailState.loading() = SaleDetailLoading;

  const factory SaleDetailState.loaded({
    required SaleResponseModel sale,
    CustomerModel? customer,
    @Default(false) bool isCancelling,
  }) = SaleDetailLoaded;

  const factory SaleDetailState.error(String message) = SaleDetailError;
}
