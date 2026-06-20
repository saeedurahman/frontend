import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/expenses/data/models/expense_list_item_model.dart';

part 'paginated_expenses_model.freezed.dart';
part 'paginated_expenses_model.g.dart';

@freezed
class PaginatedExpensesModel with _$PaginatedExpensesModel {
  const factory PaginatedExpensesModel({
    required int total,
    required int skip,
    required int limit,
    @Default([]) List<ExpenseListItemModel> items,
  }) = _PaginatedExpensesModel;

  factory PaginatedExpensesModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedExpensesModelFromJson(json);
}
