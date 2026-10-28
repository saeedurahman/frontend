import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frantend/core/permissions/permission_keys.dart';
import 'package:frantend/core/permissions/user_access.dart';
import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
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

  /// Live permissions + branch restriction (set by `SessionServices`). Falls
  /// back to the cached user when unset.
  ({UserAccess access, List<String> branchIds}) Function()? scopeProvider;

  /// Users who may see more than their own branch: a branch restriction that
  /// names several, or the owner / anyone with branch + reporting rights.
  @visibleForTesting
  static bool canListBranches(UserAccess access, List<String> branchIds) {
    if (!access.can(Perm.branchesView) && !access.isOwner) return false;
    if (branchIds.isNotEmpty) return branchIds.length > 1;
    return access.isOwner || access.can(Perm.reportsView);
  }

  /// Keeps only branches the user is limited to (all when unrestricted).
  @visibleForTesting
  static List<BranchModel> allowedBranches(
    List<BranchModel> all,
    List<String> branchIds,
  ) {
    if (branchIds.isEmpty) return all;
    return all.where((b) => branchIds.contains(b.id)).toList();
  }

  Future<void> startSession() async {
    emit(state.copyWith(isLoading: true));

    final user = await _authLocal.getCachedUser();
    if (user == null) {
      emit(const BranchSelectorState(isInitialized: true));
      return;
    }

    final scope = scopeProvider?.call();
    final access = scope?.access ??
        UserAccess(
          role: user.role,
          roles: user.roles,
          permissionKeys: user.permissionKeys,
        );
    final branchIds = scope?.branchIds ?? user.branchIds;

    if (!canListBranches(access, branchIds)) {
      await _initFixedBranch(
        branchIds.length == 1 ? branchIds.first : user.branchId,
      );
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
      (branches) => _emitFromBranchList(
        allowedBranches(branches, branchIds),
        user.branchId,
      ),
    );
  }

  /// A request for [branchId] came back 403: that branch is not for this
  /// user. Drop it, fall back to an allowed one and tell the user once.
  void handleForbiddenBranch(String? branchId) {
    if (branchId == null || branchId != state.selectedBranchId) return;
    final remaining =
        state.availableBranches.where((b) => b.id != branchId).toList();
    emit(
      BranchSelectorState(
        availableBranches: remaining,
        selectedBranchId: remaining.isEmpty ? null : remaining.first.id,
        canSwitch: remaining.length > 1,
        isInitialized: true,
        notice: "You don't have access to that branch.",
        noticeSeq: state.noticeSeq + 1,
      ),
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
