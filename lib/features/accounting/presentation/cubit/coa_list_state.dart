import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';

part 'coa_list_state.freezed.dart';

@Freezed()
sealed class CoaListState with _$CoaListState {
  const factory CoaListState.initial() = CoaListInitial;

  const factory CoaListState.loading() = CoaListLoading;

  const factory CoaListState.loaded({
    required List<ChartOfAccountModel> treeRoots,
    required List<FlatCoaNode> filteredNodes,
    @Default(false) bool activeOnlyFilter,
    @Default('') String searchQuery,
    @Default(false) bool canManage,
  }) = CoaListLoaded;

  const factory CoaListState.error(String message) = CoaListError;

  const factory CoaListState.accessDenied() = CoaListAccessDenied;
}
