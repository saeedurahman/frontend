import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';

part 'return_detail_state.freezed.dart';

@freezed
sealed class ReturnDetailState with _$ReturnDetailState {
  const factory ReturnDetailState.initial() = ReturnDetailInitial;

  const factory ReturnDetailState.loading() = ReturnDetailLoading;

  const factory ReturnDetailState.loaded({
    required SaleReturnResponseModel item,
  }) = ReturnDetailLoaded;

  const factory ReturnDetailState.accessDenied() = ReturnDetailAccessDenied;

  const factory ReturnDetailState.error(String message) = ReturnDetailError;
}
