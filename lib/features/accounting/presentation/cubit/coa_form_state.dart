import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';

part 'coa_form_state.freezed.dart';

@freezed
class CoaFormState with _$CoaFormState {
  const CoaFormState._();

  const factory CoaFormState({
    String? accountId,
    @Default('') String accountCode,
    @Default('') String accountName,
    @Default(AccountType.asset) String accountType,
    String? accountSubtype,
    String? parentId,
    @Default('') String description,
    @Default(true) bool isActive,
    @Default(false) bool isSystem,
    @Default([]) List<ChartOfAccountModel> coaTreeRoots,
    @Default(false) bool canManage,
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isDeleting,
    @Default({}) Map<String, String> errors,
  }) = _CoaFormState;

  bool get isEdit => accountId != null;

  bool get isReadOnly => !canManage;
}
