import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/accounting/data/models/chart_of_account_model.dart';
import 'package:frantend/features/accounting/domain/usecases/accounting_usecases.dart';
import 'package:frantend/features/accounting/domain/utils/account_type_subtype_map.dart';
import 'package:frantend/features/accounting/domain/utils/coa_form_payload.dart';
import 'package:frantend/features/accounting/domain/utils/coa_tree_utils.dart';
import 'package:frantend/features/accounting/presentation/cubit/coa_form_state.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:injectable/injectable.dart';

@injectable
class CoaFormCubit extends Cubit<CoaFormState> {
  CoaFormCubit({
    required AuthLocalDataSource authLocalDataSource,
    required ListChartOfAccountsUseCase listChartOfAccountsUseCase,
    required GetChartOfAccountUseCase getChartOfAccountUseCase,
    required CreateChartOfAccountUseCase createChartOfAccountUseCase,
    required UpdateChartOfAccountUseCase updateChartOfAccountUseCase,
    required DeleteChartOfAccountUseCase deleteChartOfAccountUseCase,
  })  : _authLocal = authLocalDataSource,
        _listCoa = listChartOfAccountsUseCase,
        _getCoa = getChartOfAccountUseCase,
        _createCoa = createChartOfAccountUseCase,
        _updateCoa = updateChartOfAccountUseCase,
        _deleteCoa = deleteChartOfAccountUseCase,
        super(const CoaFormState());

  final AuthLocalDataSource _authLocal;
  final ListChartOfAccountsUseCase _listCoa;
  final GetChartOfAccountUseCase _getCoa;
  final CreateChartOfAccountUseCase _createCoa;
  final UpdateChartOfAccountUseCase _updateCoa;
  final DeleteChartOfAccountUseCase _deleteCoa;

  Future<bool> _canManage() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canManageCoa(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  Future<bool> _canView() async {
    final user = await _authLocal.getCachedUser();
    return UserRoleUtils.canViewCoa(
      role: user?.role,
      permissionKeys: user?.permissionKeys ?? const [],
    );
  }

  Future<List<ChartOfAccountModel>> _loadCoaTree() async {
    final result = await _listCoa(tree: true);
    return result.fold((_) => const [], (roots) => roots);
  }

  Future<void> loadForCreate() async {
    if (!await _canManage()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final roots = await _loadCoaTree();
    final accountType = AccountType.asset;
    emit(
      CoaFormState(
        accountType: accountType,
        accountSubtype: defaultSubtypeForType(accountType),
        coaTreeRoots: roots,
        canManage: true,
      ),
    );
  }

  Future<void> loadForEdit(String accountId) async {
    if (!await _canView()) {
      emit(state.copyWith(errors: {'_general': 'Permission denied'}));
      return;
    }

    emit(state.copyWith(isLoading: true, errors: {}));

    final canManage = await _canManage();
    final accountResult = await _getCoa(accountId);
    if (accountResult.isLeft()) {
      emit(
        state.copyWith(
          isLoading: false,
          errors: {
            '_general': accountResult.fold((f) => f.message, (_) => ''),
          },
        ),
      );
      return;
    }

    final account = accountResult.getOrElse(() => throw StateError('unreachable'));
    final roots = await _loadCoaTree();

    emit(
      CoaFormState(
        accountId: account.id,
        accountCode: account.accountCode,
        accountName: account.accountName,
        accountType: account.accountType,
        accountSubtype: account.accountSubtype,
        parentId: account.parentId,
        description: account.description ?? '',
        isActive: account.isActive,
        isSystem: account.isSystem,
        coaTreeRoots: roots,
        canManage: canManage,
      ),
    );
  }

  Set<String> parentExcludeIds() {
    if (state.accountId == null) return const {};
    return descendantIds(state.accountId!, state.coaTreeRoots);
  }

  List<FlatCoaNode> parentPickerOptions() {
    return coaParentPickerOptions(
      roots: state.coaTreeRoots,
      excludeIds: parentExcludeIds(),
    );
  }

  void updateAccountCode(String value) =>
      emit(state.copyWith(accountCode: value, errors: {}));

  void updateAccountName(String value) =>
      emit(state.copyWith(accountName: value, errors: {}));

  void updateAccountType(String value) {
    final subtype = state.accountSubtype;
    final nextSubtype = isSubtypeValidForType(value, subtype)
        ? subtype
        : defaultSubtypeForType(value);
    emit(
      state.copyWith(
        accountType: value,
        accountSubtype: nextSubtype,
        errors: {},
      ),
    );
  }

  void updateAccountSubtype(String? value) =>
      emit(state.copyWith(accountSubtype: value, errors: {}));

  void updateParentId(String? value) =>
      emit(state.copyWith(parentId: value, errors: {}));

  void updateDescription(String value) =>
      emit(state.copyWith(description: value, errors: {}));

  void updateIsActive(bool value) =>
      emit(state.copyWith(isActive: value, errors: {}));

  Map<String, String> validate() {
    final errors = <String, String>{};
    if (!state.isSystem && state.accountCode.trim().isEmpty) {
      errors['account_code'] = 'Account code is required';
    }
    if (state.accountName.trim().isEmpty) {
      errors['account_name'] = 'Account name is required';
    }
    if (state.accountType.trim().isEmpty) {
      errors['account_type'] = 'Account type is required';
    }
    return errors;
  }

  Future<bool?> submit() async {
    if (!state.canManage) return false;

    final errors = validate();
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return false;
    }

    emit(state.copyWith(isSubmitting: true, errors: {}));

    if (state.isEdit) {
      final result = await _updateCoa(
        state.accountId!,
        buildUpdateCoaPayload(
          accountCode: state.accountCode,
          accountName: state.accountName,
          accountType: state.accountType,
          accountSubtype: state.accountSubtype,
          parentId: state.parentId,
          description: state.description,
          isActive: state.isActive,
          isSystem: state.isSystem,
        ),
      );
      return result.fold(
        (failure) {
          emit(state.copyWith(isSubmitting: false, errors: {'_general': failure.message}));
          return false;
        },
        (_) {
          emit(state.copyWith(isSubmitting: false));
          return true;
        },
      );
    }

    final result = await _createCoa(
      buildCreateCoaPayload(
        accountCode: state.accountCode,
        accountName: state.accountName,
        accountType: state.accountType,
        accountSubtype: state.accountSubtype,
        parentId: state.parentId,
        description: state.description,
        isActive: state.isActive,
      ),
    );
    return result.fold(
      (failure) {
        emit(state.copyWith(isSubmitting: false, errors: {'_general': failure.message}));
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }

  Future<bool?> deleteAccount() async {
    if (!state.canManage || state.accountId == null || state.isSystem) {
      return false;
    }

    emit(state.copyWith(isDeleting: true, errors: {}));

    final result = await _deleteCoa(state.accountId!);
    return result.fold(
      (failure) {
        emit(state.copyWith(isDeleting: false, errors: {'_general': failure.message}));
        return false;
      },
      (_) {
        emit(state.copyWith(isDeleting: false));
        return true;
      },
    );
  }
}
