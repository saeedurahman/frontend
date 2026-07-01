import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/manufacturing/data/models/bom_header_model.dart';

part 'boms_list_state.freezed.dart';

@Freezed()
sealed class BomsListState with _$BomsListState {
  const factory BomsListState.initial() = BomsListInitial;

  const factory BomsListState.loading() = BomsListLoading;

  const factory BomsListState.loaded({
    required List<BomHeaderModel> allBoms,
    required List<BomHeaderModel> filteredBoms,
    @Default(false) bool activeOnlyFilter,
    @Default('') String searchQuery,
    @Default(false) bool canManage,
  }) = BomsListLoaded;

  const factory BomsListState.error(String message) = BomsListError;

  const factory BomsListState.accessDenied() = BomsListAccessDenied;
}
