import 'package:frantend/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:frantend/features/branches/presentation/cubit/branch_selector_cubit.dart';
import 'package:injectable/injectable.dart';

/// The branch every money action must be recorded against.
///
/// The backend treats a payment without a branch as business-wide, so screens
/// that take or make payments always ask this class and send the answer as
/// `branch_id`: the branch picked in the top bar, else the user's own branch.
@lazySingleton
class ActiveBranchResolver {
  ActiveBranchResolver(this._selector, this._auth);

  final BranchSelectorCubit _selector;
  final AuthLocalDataSource _auth;

  Future<String?> resolve() async {
    final selected = _selector.state.selectedBranchId;
    if (selected != null && selected.isNotEmpty) return selected;
    final user = await _auth.getCachedUser();
    final own = user?.branchId;
    return own != null && own.isNotEmpty ? own : null;
  }
}
