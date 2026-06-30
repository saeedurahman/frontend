import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/returns/data/models/sale_return_response_model.dart';

part 'returns_list_state.freezed.dart';

@freezed
sealed class ReturnsListState with _$ReturnsListState {
  const factory ReturnsListState.initial() = ReturnsListInitial;

  const factory ReturnsListState.loading() = ReturnsListLoading;

  const factory ReturnsListState.loaded({
    required List<SaleReturnResponseModel> items,
    required int skip,
    required int limit,
    String? branchIdFilter,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
  }) = ReturnsListLoaded;

  const factory ReturnsListState.accessDenied() = ReturnsListAccessDenied;

  const factory ReturnsListState.error(String message) = ReturnsListError;
}
