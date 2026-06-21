import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/auth/domain/utils/user_role_utils.dart';
import 'package:frantend/features/branches/domain/usecases/branches_usecases.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_state.dart';
import 'package:frantend/features/settings/data/models/branch_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BranchSelectorCubit extends Cubit<BranchSelectorState> {
  BranchSelectorCubit(this._useCases, this._authLocal)
      : super(const BranchSelectorState());

  final BranchesUseCases _useCases;
  final AuthLocalDataSource _authLocal;

  Future<void> startSession() async {
    emit(state.copyWith(isLoading: true));

    final user = await _authLocal.getCachedUser();
    if (user == null) {
      emit(const BranchSelectorState(isInitialized: true));
      return;
    }

    final canListAllBranches = UserRoleUtils.isOwner(user.role) ||
        UserRoleUtils.isManager(user.role);

    if (!canListAllBranches) {
      await _initFixedBranch(user.branchId);
      return;
    }

    final result = await _useCases.getBranches();
    result.fold(
      (_) => emit(
        BranchSelectorState(
          selectedBranchId: user.branchId,
          isInitialized: true,
        ),
      ),
      (branches) => _emitFromBranchList(branches, user.branchId),
    );
  }

  Future<void> _initFixedBranch(String? branchId) async {
    if (branchId == null) {
      emit(const BranchSelectorState(isInitialized: true));
      return;
    }

    final result = await _useCases.getBranchById(branchId);
    result.fold(
      (_) => emit(
        BranchSelectorState(
          selectedBranchId: branchId,
          isInitialized: true,
        ),
      ),
      (branch) => emit(
        BranchSelectorState(
          availableBranches: [branch],
          selectedBranchId: branch.id,
          canSwitch: false,
          isInitialized: true,
        ),
      ),
    );
  }

  void _emitFromBranchList(List<BranchModel> branches, String? userBranchId) {
    if (branches.isEmpty) {
      emit(
        BranchSelectorState(
          selectedBranchId: userBranchId,
          isInitialized: true,
        ),
      );
      return;
    }

    final canSwitch = branches.length > 1;
    final selectedId = _resolveSelectedBranchId(branches, userBranchId);

    emit(
      BranchSelectorState(
        availableBranches: branches,
        selectedBranchId: selectedId,
        canSwitch: canSwitch,
        isInitialized: true,
      ),
    );
  }

  String _resolveSelectedBranchId(
    List<BranchModel> branches,
    String? userBranchId,
  ) {
    if (userBranchId != null &&
        branches.any((branch) => branch.id == userBranchId)) {
      return userBranchId;
    }
    final defaultBranch = branches.where((b) => b.isDefault);
    if (defaultBranch.isNotEmpty) return defaultBranch.first.id;
    return branches.first.id;
  }

  void selectBranch(String branchId) {
    if (!state.canSwitch) return;
    if (!state.availableBranches.any((b) => b.id == branchId)) return;
    if (state.selectedBranchId == branchId) return;
    emit(state.copyWith(selectedBranchId: branchId));
  }

  void stopSession() {
    emit(const BranchSelectorState());
  }
}
